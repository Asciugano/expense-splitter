import mongoose, { Types, type HydratedDocument } from "mongoose";

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
  },
  { timestamps: true },
);

export type ExpenseDocument = HydratedDocument<{
  amount: number;
  title: string;
  paidBy: Types.ObjectId;
  tripId: Types.ObjectId;
}>;

const Expense = mongoose.model("Expense", expenseSchema);
export default Expense;
