import Expense from "../models/expense.ts";
import Trip from "../models/trip.ts";
import type { AuthRequest } from "../requests/auth.request.ts";
import type { Response } from "express";

export async function getAllExpenses(
  req: AuthRequest<{ id: string }>,
  res: Response,
) {
  try {
    const expenses = await Expense.find({ tripId: { $eq: req.params.id } });
    res.json({ expenses });
  } catch (e) {
    console.error(`error in getAllExpenses controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function createExpense(
  req: AuthRequest<{ id: string }>,
  res: Response,
) {
  const { amount, title } = req.body;
  try {
    if (!amount || !title)
      return res
        .status(400)
        .json({ error: true, message: "All fields are required" });

    const newExpense = new Expense({
      title,
      amount,
    });

    if (!newExpense)
      return res.status(500).json({
        error: true,
        message: "Something went wrong while creating this expense",
      });

    await newExpense.save();
    res.status(201).json({ newExpense });
  } catch (e) {
    console.error(`error in createExpense controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function updateExpenses(
  req: AuthRequest<{ id: string }>,
  res: Response,
) {
  const { amount, title } = req.body;
  try {
    const expense = await Expense.findById(req.params.id);
    if (!expense)
      return res
        .status(404)
        .json({ error: true, message: "Unable to find the requested expense" });

    const trip = await Trip.findById(expense.tripId);
    if (!trip)
      return res
        .status(404)
        .json({ error: true, message: "Unable to find the requested trip" });

    if (!req.user) return;
    if (!trip.owner._id.equals(req.user._id))
      return res.status(401).json({
        error: true,
        message: "Only the owner of the trip can modify the properies",
      });

    if (amount) expense.amount = amount;
    if (title) expense.title = title;

    await expense.save();
    res.json({ expense });
  } catch (e) {
    console.error(`error in updateExpenses controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function deleteExpense(
  req: AuthRequest<{ id: string }>,
  res: Response,
) {
  try {
    const expense = await Expense.findById(req.params.id);
    if (!expense)
      return res
        .status(404)
        .json({ error: true, message: "Unable to find the requested expense" });

    if (!req.user) return;
    if (!(expense.tripId.toString() in req.user.trips))
      return res
        .status(401)
        .json({ error: true, message: "This expense is not in your trips" });

    if (expense.amount > 0) {
      const trip = await Trip.findById(expense.tripId);
      if (!trip)
        return res
          .status(404)
          .json({ error: true, message: "Unable to find the requested trip" });

      if (!trip.owner._id.equals(req.user._id))
        return res.status(401).json({
          error: true,
          message: "Only the owner of the trip can delete the expenses",
        });
    }

    await expense.deleteOne();
    res.status(204);
  } catch (e) {
    console.error(`error in deleteExpense controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function getExpense(
  req: AuthRequest<{ id: string }>,
  res: Response,
) {
  try {
    const expense = await Expense.findById(req.params.id);
    if (!expense)
      return res
        .status(404)
        .json({ error: true, message: "Unable to find the requested expense" });

    if (!req.user) return;

    if (!(expense.tripId.toString() in req.user.trips))
      return res.status(401).json({
        error: true,
        message: "This expense is not in your trips",
      });

    res.json({ expense });
  } catch (e) {
    console.error(`error in getExpense controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function pay(req: AuthRequest<{ id: string }>, res: Response) {
  const { amount } = req.body;
  try {
    if (!amount || amount <= 0)
      return res.status(400).json({
        error: true,
        message: "You need to specify how mutch you pay back",
      });

    const expense = await Expense.findById(req.params.id);
    if (!expense)
      return res
        .status(404)
        .json({ error: true, message: "Unable to find the requested expense" });

    expense.amount -= amount;
    if (expense.amount < 0) expense.amount = 0;

    await expense.save();
    res.json({ amount: expense.amount });
  } catch (e) {
    console.error(`error in getExpense controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}
