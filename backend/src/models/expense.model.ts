import mongoose, { Types, type HydratedDocument } from "mongoose";

export const ExpenseStatus = {
  PAID: "PAID",
  PENDING: "PENDING",
} as const;

export type ExpenseStatus = (typeof ExpenseStatus)[keyof typeof ExpenseStatus];

const expenseSchema = new mongoose.Schema(
  {
    paidBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    amount: {
      type: Number,
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    tripId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Trip",
      required: true,
      index: true,
    },
    status: {
      type: String,
      enum: Object.values(typeof ExpenseStatus),
      default: "PENDING",
    },
  },
  { timestamps: true },
);

export type ExpenseDocument = HydratedDocument<{
  amount: number;
  title: string;
  paidBy: Types.ObjectId;
  tripId: Types.ObjectId;
  status: ExpenseStatus;
}>;

const Expense = mongoose.model("Expense", expenseSchema);
export default Expense;
