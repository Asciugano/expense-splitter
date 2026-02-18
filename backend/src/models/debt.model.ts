import mongoose, { Types, type HydratedDocument } from "mongoose";

const debtSchema = new mongoose.Schema(
  {
    amount: {
      type: Number,
      required: true,
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    expenseId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Expense",
      required: true,
      index: true,
    },
  },
  { timestamps: true },
);

export type debtDocument = HydratedDocument<{
  amount: number;
  expenseId: Types.ObjectId;
  userId: Types.ObjectId;
}>;

const Debt = mongoose.model("Debt", debtSchema);
export default Debt;
