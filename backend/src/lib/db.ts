import mongoose from "mongoose";

export async function connectDB() {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI ?? "");
    console.log(`mongoDB connected: ${conn.connection.host}`);
  } catch (error) {
    console.error("connection error", error);
  }
}
