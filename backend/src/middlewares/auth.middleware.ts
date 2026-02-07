import type { NextFunction, Request, Response } from "express";
import jwt, { JwtPayload } from "jsonwebtoken";
import { config } from "dotenv";
import User from "../models/user.ts";

config();

export async function protectedRoute(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  try {
    const token = req.cookies.jwt;
    if (!token)
      return res
        .status(401)
        .json({ error: true, message: "Unauthorized - No token provided" });

    const decoded = jwt.verify(token, process.env.JWT_SECRET) as JwtPayload & {
      userID: string;
    };

    if (!decoded)
      return res
        .status(401)
        .json({ error: true, message: "Unauthorized - Invalid token" });

    const user = await User.findById(decoded.userID).select("-password");
    if (!user)
      return res.status(401).json({ error: true, message: "User not foud" });

    req.user = user;
    next();
  } catch (e) {
    console.error("error in protectRoute middleware ", e);
    res.status(500).json({ error: true, message: "internal server error" });
  }
}
