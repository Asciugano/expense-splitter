import type { Request, Response } from "express";
import bcrypt from "bcryptjs";
import { generateToken } from "../lib/jwt.ts";

export async function login(req: Request, res: Response) {
  const { email, password } = req.body;
  try {
    if (!email || !password)
      return res
        .status(401)
        .json({ error: true, message: "Invalid credential" });

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user)
      return res
        .status(401)
        .json({ error: true, message: "Invalid credential" });

    const isPasswordCorrect = await bcrypt.compare(password, user.password);
    if (!isPasswordCorrect)
      return res
        .status(401)
        .json({ error: true, message: "Invalid credential" });

    const token = await generateToken(user.id, res);

    res.json({ user });
  } catch (e) {
    console.error(`error in login controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function logout(req: Request, res: Response) {
  const { email, fullName, password } = req.body;
  try {
    if (!email || !fullName || !password)
      return res
        .status(400)
        .json({ error: true, message: "All fields are required" });

    const user = await prisma.user.findUnique({ where: { email } });
    if (user)
      return res.status(400).json({
        error: true,
        message: "There is already an account with this email",
      });

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUser = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        fullName,
      },
    });

    if (!newUser)
      return res.status(500).json({
        error: true,
        message: "Could not create this account. try again later",
      });

    const token = generateToken(user.id, res);

    res.status(201).json({ user: newUser });
  } catch (e) {
    console.error(`error in register controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function register(req: Request, res: Response) {
  try {
    res.cookie("jwt", "", { maxAge: 0 });
    res.status(200).json({ message: "logout succussfully" });
  } catch (e) {
    console.error(`error in logout controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}
