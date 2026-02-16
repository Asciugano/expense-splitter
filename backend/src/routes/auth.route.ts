import express from "express";
import {
  login,
  logout,
  me,
  refresh,
  register,
} from "../controllers/auth.controller.ts";
import { protectedRoute } from "../middlewares/auth.middleware.ts";

const router = express.Router();

router.get("/me", protectedRoute, me);
router.post("/login", login);
router.post("/logout", protectedRoute, logout);
router.post("/register", register);
router.post("/refresh", refresh);

export default router;
