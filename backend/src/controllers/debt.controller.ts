import type { Response } from "express";
import type { AuthRequest } from "../requests/auth.request.ts";
import Expense from "../models/expense.model.ts";
import Debt from "../models/debt.model.ts";
import mongoose from "mongoose";

export async function pay(req: AuthRequest<{ id: string }>, res: Response) {
  const { amount } = req.body;
  try {
    if (!amount || amount <= 0)
      return res.status(400).json({
        error: true,
        message: "You need to specify how mutch you pay back",
      });

    const debt = await Debt.findById(req.params.id);
    if (!debt)
      return res
        .status(404)
        .json({ error: true, message: "Unable to find the requested debt" });

    const expense = await Expense.findById(debt.expenseId);
    if (!expense)
      return res
        .status(404)
        .json({ error: true, message: "Unable to find the requested expense" });

    const paidAmount = Math.min(amount, debt.amount);
    debt.amount -= paidAmount;
    expense.amount -= paidAmount;

    if (debt.amount <= 0) await debt.deleteOne();
    if (expense.amount <= 0) await expense.deleteOne();
    else {
      await debt.save();
      await expense.save();
    }
    res.json({ amount: expense.amount });
  } catch (e) {
    console.error(`error in pay controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function getDebt(req: AuthRequest<{ id: string }>, res: Response) {
  try {
    const debt = await Debt.findById(req.params.id);
    if (!debt)
      return res
        .status(404)
        .json({ error: true, message: "Unable to find the requested debt" });

    if (!req.user) return;
    if (!debt.userId.equals(req.user._id))
      return res
        .status(401)
        .json({ error: true, message: "This is not your debt" });

    res.json({ debt });
  } catch (e) {
    console.error(`error in getDebt controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function getTotalDebt(
  req: AuthRequest<{ id: string }>,
  res: Response,
) {
  try {
    if (!req.user) return;

    const totalDebt = await Debt.aggregate([
      { $match: { userId: req.user._id } },
      { $group: { _id: "$userId", totalDebt: { $sum: "$amount" } } },
    ]);

    res.json({ totalDebt: totalDebt[0]?.totalDebt || 0.0 });
  } catch (e) {
    console.error(`error in getTotalDebt controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function getDebtByTrip(
  req: AuthRequest<{ id: string }>,
  res: Response,
) {
  try {
    if (!req.user) return;

    const totalDebt = await Debt.aggregate([
      { $match: { UserId: req.user._id } },
      {
        $lookup: {
          from: "expenses",
          localField: "expenseId",
          foreignField: "_id",
          as: "expense",
        },
      },
      { $unwind: "$expense" },
      {
        $match: {
          "expense.tripId": new mongoose.Types.ObjectId(req.params.id),
        },
      },
      { $group: { _id: null, totalDebt: { $sum: "$amount" } } },
    ]);

    res.json({ totalDebt: totalDebt[0]?.totalDebt || 0 });
  } catch (e) {
    console.error(`error in getDebtByTrip controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function createDebt(
  req: AuthRequest<{ id: string }>,
  res: Response,
) {
  const { method } = req.body;
  try {
    const expense = await Expense.findById(req.params.id);
    if (!expense)
      return res
        .status(404)
        .json({ error: true, message: "Unable to find the requested expense" });

    // TODO: finire
  } catch (e) {
    console.error(`error in createDebt controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}
