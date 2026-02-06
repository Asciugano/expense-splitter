import express from "express";
import { config } from "dotenv";

import authRoute from "./routes/auth.route.ts";
import { connectDB } from "./lib/db.ts";

config();

const app = express();
const PORT = process.env.PORT || 3000;
app.use(express.json());

app.use("/api/auth", authRoute);

app.listen(PORT, () => {
  console.log(`Server is listening on port: ${PORT}`);
  connectDB();
});
