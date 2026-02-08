import express from "express";
import {
  createTrip,
  deleteTrip,
  getTripByID,
  getTripOfUser,
  joinTrip,
  updateTrip,
} from "../controllers/trip.controller.ts";
import { protectedRoute } from "../middlewares/auth.middleware.ts";

const router = express.Router();

// INFO: Get all the trips of the user
router.get("/", protectedRoute, getTripOfUser);
// INFO: Get the trip with the id
router.get("/:id", getTripByID);
router.get("/join/:id", protectedRoute, joinTrip);
router.post("/", protectedRoute, createTrip);
router.put("/:id", protectedRoute, updateTrip);
router.delete("/:id", protectedRoute, deleteTrip);

export default router;
