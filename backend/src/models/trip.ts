import mongoose, { Types, type HydratedDocument } from "mongoose";
import type { UserDocument } from "./user.ts";

const tripSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    owner: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    partecipants: [
      {
        type: Types.ObjectId,
        ref: "User",
      },
    ],
    expenses: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Expense",
      },
    ],
  },
  { timestamps: true },
);

export type TripDocument = HydratedDocument<{
  name: string;
  owner: UserDocument;
  partecipants: Types.ObjectId[];
  expenses: Types.ObjectId[];
}>;

const Trip = mongoose.model("Trip", tripSchema);
export default Trip;
