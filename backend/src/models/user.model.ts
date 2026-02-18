import mongoose, { Types, type HydratedDocument } from "mongoose";

const userSchema = new mongoose.Schema(
  {
    email: {
      type: String,
      required: true,
      unique: true,
    },
    fullName: {
      type: String,
      required: true,
    },
    password: {
      type: String,
      required: true,
      minlength: 6,
    },
    refreshToken: {
      type: String,
    },
    trips: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Trip",
      },
    ],
  },
  { timestamps: true },
);

export type UserDocument = HydratedDocument<{
  email: string;
  fullName: string;
  password: string;
  refreshToken?: string | null;
  trips: Types.ObjectId[];
}>;

const User = mongoose.model("User", userSchema);
export default User;
