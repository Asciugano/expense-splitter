import mongoose, { Types, type HydratedDocument } from "mongoose";

const expenseSchema = new mongoose.Schema(
  {
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
    },
  },
  { timestamps: true },
);

export type ExpenseDocument = HydratedDocument<{
  amount: number;
  title: string;
  trip: Types.ObjectId;
}>;

const Expense = mongoose.model("Expense", expenseSchema);
export default Expense;
