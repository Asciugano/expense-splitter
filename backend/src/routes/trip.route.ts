import express from "express";
import {
  createTrip,
  deleteTrip,
  getTripByID,
  getTripOfUser,
  updateTrip,
} from "../controllers/trip.controller.ts";

const router = express.Router();

// INFO: Get all the trips of the user
router.get("/", getTripOfUser);
// INFO: Get the trip with the id
router.get("/:id", getTripByID);
router.post("/", createTrip);
router.put("/:id", updateTrip);
router.delete("/:id", deleteTrip);

export default router;
