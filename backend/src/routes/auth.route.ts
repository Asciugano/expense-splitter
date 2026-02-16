import express from "express";
import {
  login,
  logout,
  refresh,
  register,
} from "../controllers/auth.controller.ts";
import { protectedRoute } from "../middlewares/auth.middleware.ts";

const router = express.Router();

router.post("/login", login);
router.post("/logout", protectedRoute, logout);
router.post("/register", register);
router.post("/refresh", refresh);

export default router;
