import express from "express";
import {
  createTrip,
  deleteTrip,
  generateInviteToken,
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
router.post("/join", protectedRoute, joinTrip);
router.post("/join/generate_invite/:id", protectedRoute, generateInviteToken);
router.post("/", protectedRoute, createTrip);
router.put("/:id", protectedRoute, updateTrip);
router.delete("/:id", protectedRoute, deleteTrip);

export default router;
