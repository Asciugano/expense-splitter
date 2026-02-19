import express from "express";
import { protectedRoute } from "../middlewares/auth.middleware.ts";
import {
  createExpense,
  deleteExpense,
  getAllExpenses,
  updateExpenses,
  getExpense,
} from "../controllers/expenses.controller.ts";

const router = express.Router();

router.get("/trip/:id", protectedRoute, getAllExpenses);
router.get("/:id", protectedRoute, getExpense);
router.post("/:id", protectedRoute, createExpense);
router.put("/:id", protectedRoute, updateExpenses);
router.delete("/:id", protectedRoute, deleteExpense);

export default router;
