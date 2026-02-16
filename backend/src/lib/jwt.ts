import type { Response } from "express";
import jwt from "jsonwebtoken";

export async function generateAccessToken(
  userID: string,
  res: Response,
): Promise<string> {
  const token = jwt.sign({ userID }, process.env.JWT_SECRET, {
    expiresIn: "1h",
  });
  res.cookie("jwt", token, {
    maxAge: 1000 * 60 * 60,
    httpOnly: true,
  });

  return token;
}

export function generateRefreshToken(userID: string): string {
  return jwt.sign({ userID: userID }, process.env.REFRESH_TOKEN_SECRET, {
    expiresIn: "7d",
  });
}
