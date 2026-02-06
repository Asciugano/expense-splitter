import type { Response } from "express";
import jwt from "jsonwebtoken";

export async function generateToken(userID: String, res: Response) {
  const token = jwt.sign({ userID }, process.env.JWT_SECRET, {
    expiresIn: "1h",
  });
  res.cookie("jwt", token, {
    maxAge: 1000 * 60,
    httpOnly: true,
  });

  return token;
}
