import type { NextFunction, Response } from "express";
import jwt from "jsonwebtoken";
import { config } from "dotenv";
import User from "../models/user.ts";
import type { AuthRequest } from "../requests/auth.request.ts";

config();

export async function protectedRoute(
  req: AuthRequest,
  res: Response,
  next: NextFunction,
) {
  try {
    let token = req.cookies.jwt;
    if (!token) {
      const authHeader = req.headers.authorization;
      if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return res
          .status(401)
          .json({ error: true, message: "Unauthorized - No token provided" });
      }
      token = authHeader.split(" ")[1];

      if (!token)
        return res
          .status(401)
          .json({ error: true, message: "Unauthorized - No token provided" });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
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
