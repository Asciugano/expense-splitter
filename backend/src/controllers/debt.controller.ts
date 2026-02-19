import type { Response } from "express";
import type { AuthRequest } from "../requests/auth.request.ts";
import { SplitStrategy } from "../types.ts";
import Expense from "../models/expense.model.ts";
import Debt from "../models/debt.model.ts";
import mongoose from "mongoose";
import Trip from "../models/trip.model.ts";

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
    else await debt.save();

    if (expense.amount <= 0) await expense.deleteOne();
    else await expense.save();
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
      { $group: { _id: null, totalDebt: { $sum: "$amount" } } },
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
      { $match: { userId: req.user._id } },
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
  const { splitDetail } = req.body;
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
        .json({ error: true, message: "Unable to find the requeted trip" });

    if (!splitDetail || !splitDetail.strategy)
      return res.status(400).json({ error: true, message: "Invalid body" });

    if (!req.user) return;

    if (!trip.partecipants.some((p) => p.equals(req.user!._id)))
      return res
        .status(401)
        .json({ error: true, message: "You aren't in this trip" });

    const debtsToCreate: { userId: string; amount: number }[] = [];

    switch (splitDetail.strategy) {
      case SplitStrategy.EQUAL:
        const share =
          Math.round((expense.amount / trip.partecipants.length) * 100) / 100;

        expense.paidBy = req.user._id;

        for (const partecipant of trip.partecipants) {
          if (partecipant.equals(expense.paidBy)) continue;

          debtsToCreate.push({ userId: partecipant.toString(), amount: share });
        }
        break;
      case SplitStrategy.EXACT:
        const total = splitDetail.splits.reduce(
          (sum: number, s: any) => sum + s.amount,
          0,
        );

        if (total != expense.amount)
          return res
            .status(400)
            .json({ error: true, message: "Split total mismatch" });

        for (const split of splitDetail.splits) {
          if (split.userId === expense.paidBy.toString()) continue;

          debtsToCreate.push({
            userId: split.userId,
            amount: split.amount,
          });
        }
        break;

      case SplitStrategy.PERCENTAGE:
        const totalPercentage = splitDetail.splits.reduce(
          (sum: number, s: any) => sum + s.percentage,
          0,
        );

        if (totalPercentage !== 100)
          return res
            .status(400)
            .json({ error: true, message: "Percentage must sum to 100%" });

        for (const split of splitDetail.splits) {
          if (!trip.partecipants.some((p) => p.equals(split.userId)))
            return res
              .status(401)
              .json({ error: true, message: "Not every user is in this trip" });

          const amount = (expense.amount * split.percentage) / 100;

          if (split.userId === expense.paidBy.toString()) continue;

          debtsToCreate.push({
            userId: split.userId,
            amount,
          });
        }
        break;

      default:
        return res
          .status(400)
          .json({ error: true, message: "Invalid split strategy" });
    }

    await expense.save();

    await Debt.insertMany(
      debtsToCreate.map((d) => ({
        userId: d.userId,
        expenseId: expense._id,
        amount: d.amount,
      })),
    );

    res.status(201).json({ message: "Debts created successully" });
  } catch (e) {
    console.error(`error in createDebt controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}
