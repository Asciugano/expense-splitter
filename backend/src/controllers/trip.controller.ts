import type { Request, Response } from "express";
import Trip from "../models/trip.ts";

export async function getTripByID(
  req: Request<{ id: string }, any>,
  res: Response,
) {
  try {
    const trip = await Trip.findById(req.params.id);
    if (!trip)
      return res
        .status(404)
        .json({ error: true, message: "Could not find the requested trip" });

    res.json({ trip });
  } catch (e) {
    console.error(`error in getTripByID controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function getTripOfUser(req: Request, res: Response) {
  try {
    res.json({ message: "test" });
  } catch (e) {
    console.error(`error in getTripByID controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function updateTrip(
  req: Request<{ id: string }, any>,
  res: Response,
) {
  res.json(`update trip: ${req.params.id}`);
}

export async function deleteTrip(
  req: Request<{ id: string }, any>,
  res: Response,
) {
  res.json(`delete trip: ${req.params.id}`);
}

export async function createTrip(req: Request, res: Response) {
  res.json(`create trip`);
}
