import express from "express";
import { protectedRoute } from "../middlewares/auth.middleware.ts";
import {
  createExpense,
  deleteExpense,
  getAllExpenses,
  updateExpenses,
  getExpense,
  getExpenseDebt,
  updateExpenseStatus,
} from "../controllers/expenses.controller.ts";

const router = express.Router();

router.get("/trip/:id", protectedRoute, getAllExpenses);
router.get("/:id", protectedRoute, getExpense);
router.post("/:id", protectedRoute, createExpense);
router.post("/status/:id", protectedRoute, updateExpenseStatus);
router.put("/:id", protectedRoute, updateExpenses);
router.delete("/:id", protectedRoute, deleteExpense);
router.get("/debt/:id", protectedRoute, getExpenseDebt);

export default router;
