import express from "express";
import { config } from "dotenv";
import cookieParser from "cookie-parser";

import authRoute from "./routes/auth.route.ts";
import tripRoute from "./routes/trip.route.ts";
import { connectDB } from "./lib/db.ts";

config();

const app = express();
const PORT = process.env.PORT || 3000;
app.use(express.json());
app.use(cookieParser());

app.use("/api/auth", authRoute);
app.use("/api/trip", tripRoute);

app.listen(PORT, () => {
  console.log(`Server is listening on port: ${PORT}`);
  connectDB();
});
