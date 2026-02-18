import express from "express";
import { protectedRoute } from "../middlewares/auth.middleware.ts";
import {
  getDebt,
  getDebtByTrip,
  getTotalDebt,
  pay,
} from "../controllers/debt.controller.ts";

const router = express.Router();

router.get("/total/", protectedRoute, getTotalDebt);
router.get("/trip/:id", protectedRoute, getDebtByTrip);
router.get("/:id", protectedRoute, getDebt);
router.post("/:id", protectedRoute, pay);

export default router;
