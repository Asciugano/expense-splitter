import type { Request, Response } from "express";
import bcrypt from "bcryptjs";
import { generateAccessToken, generateRefreshToken } from "../lib/jwt.ts";
import User from "../models/user.model.ts";
import jwt from "jsonwebtoken";
import type { AuthRequest } from "../requests/auth.request.ts";

export async function login(req: Request, res: Response) {
  const { email, password } = req.body;
  try {
    if (!email || !password)
      return res
        .status(401)
        .json({ error: true, message: "Invalid credential" });

    const user = await User.findOne({ email });
    if (!user)
      return res
        .status(401)
        .json({ error: true, message: "Invalid credential" });

    const isPasswordCorrect = await bcrypt.compare(password, user.password);
    if (!isPasswordCorrect)
      return res
        .status(401)
        .json({ error: true, message: "Invalid credential" });

    const accessToken = await generateAccessToken(user._id.toString(), res);
    const refreshToken = generateRefreshToken(user._id.toString());

    const hashedRefreshToken = await bcrypt.hash(refreshToken, 10);
    user.refreshToken = hashedRefreshToken;
    await user.save();

    res.json({ accessToken, refreshToken, user });
  } catch (e) {
    console.error(`error in login controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function register(req: Request, res: Response) {
  const { email, fullName, password } = req.body;
  try {
    if (!email || !fullName || !password)
      return res
        .status(400)
        .json({ error: true, message: "All fields are required" });

    const user = await User.findOne({ email });
    if (user)
      return res.status(400).json({
        error: true,
        message: "There is already an account with this email",
      });

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUser = new User({
      fullName,
      email,
      password: hashedPassword,
    });

    if (!newUser)
      return res.status(500).json({
        error: true,
        message: "Could not create this account. try again later",
      });

    const accessToken = await generateAccessToken(newUser._id.toString(), res);
    const refreshToken = generateRefreshToken(newUser._id.toString());

    const hashedRefreshToken = await bcrypt.hash(refreshToken, 10);
    newUser.refreshToken = hashedRefreshToken;
    await newUser.save();

    res.status(201).json({ accessToken, refreshToken, user: newUser });
  } catch (e) {
    console.error(`error in logout controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function logout(req: AuthRequest, res: Response) {
  try {
    if (!req.user) return;

    req.user.refreshToken = null;
    await req.user.save();

    res.cookie("jwt", "", { maxAge: 0 });

    res.status(200).json({ message: "logout succussfully" });
  } catch (e) {
    console.error(`error in logout controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function refresh(req: Request, res: Response) {
  const { refreshToken } = req.body;
  try {
    if (!refreshToken)
      return res
        .status(401)
        .json({ error: true, message: "No refresh token provided" });

    const decoded = jwt.verify(
      refreshToken,
      process.env.REFRESH_TOKEN_SECRET,
    ) as { userID: string };

    const user = await User.findById(decoded.userID);
    if (!user || !user.refreshToken)
      return res
        .status(403)
        .json({ error: true, message: "Invalid refreshToken" });

    const isValid = await bcrypt.compare(refreshToken, user.refreshToken);
    if (!isValid)
      return res
        .status(403)
        .json({ error: true, message: "Invalid refreshToken" });

    const newAccessToken = await generateAccessToken(user._id.toString(), res);
    const newRefreshToken = generateRefreshToken(user._id.toString());

    const hashedRefreshToken = await bcrypt.hash(newRefreshToken, 10);
    user.refreshToken = hashedRefreshToken;
    await user.save();

    res.json({ accessToken: newAccessToken, refreshToken: newRefreshToken });
  } catch (e) {
    console.error(`error in refresh controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export function me(req: AuthRequest, res: Response) {
  res.json({ user: req.user });
}
