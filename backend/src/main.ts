import express from "express";
import { config } from "dotenv";
import cookieParser from "cookie-parser";
import cors from "cors";

import authRoute from "./routes/auth.route.ts";
import tripRoute from "./routes/trip.route.ts";
import expenseRoute from "./routes/expenses.route.ts";
import debtRoute from "./routes/debt.route.ts";
import { connectDB } from "./lib/db.ts";

config();

const app = express();
const PORT = process.env.PORT || 3000;
app.use(express.json());
app.use(cookieParser());

// TODO: add cors origins
app.use(cors());

app.use("/api/auth", authRoute);
app.use("/api/trip", tripRoute);
app.use("/api/expenses", expenseRoute);
app.use("/api/debt", debtRoute);

app.listen(PORT, () => {
  console.log(`Server is listening on port: ${PORT}`);
  connectDB();
});
