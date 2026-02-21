import type { Request, Response } from "express";
import Trip from "../models/trip.model.ts";
import type { AuthRequest } from "../requests/auth.request.ts";
import { generatetokenForTrip } from "../lib/jwt.ts";
import jwt from "jsonwebtoken";

export async function getTripByID(
  req: Request<{ id: string }, any>,
  res: Response,
) {
  try {
    const trip = await Trip.findById(req.params.id).populate("expenses");
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

export async function getTripOfUser(req: AuthRequest, res: Response) {
  try {
    if (!req.user) return;
    if (req.user.trips.length === 0) return res.json({ trips: [] });
    const trips = await Trip.find({ _id: { $in: req.user.trips } }).populate(
      "expenses",
    );
    if (!trips)
      return res
        .status(404)
        .json({ error: true, message: "Could not find any trip" });

    res.json({ trips });
  } catch (e) {
    console.error(`error in getTripOfUser controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function updateTrip(
  req: AuthRequest<{ id: string }, any>,
  res: Response,
) {
  const { name, expenses, partecipants } = req.body;
  try {
    if (!name && !expenses && !partecipants)
      return res
        .status(400)
        .json({ error: true, message: "At least un fileld is required" });

    const trip = await Trip.findById(req.params.id);
    if (!trip)
      return res
        .status(404)
        .json({ error: true, message: "Could not find the trip" });

    if (!req.user) return;

    const isOwner = trip.owner.equals(req.user._id);
    const isPartecipant = trip.partecipants.includes(req.user._id);

    if (isOwner) {
      if (name) trip.name = name;
      if (expenses) trip.expenses = expenses;
      if (partecipants) trip.partecipants = partecipants;
    } else if (isPartecipant && expenses) {
      trip.expenses.push(...expenses);
    } else {
      return res
        .status(401)
        .json({ error: true, message: "Only the owner can modify everything" });
    }

    await trip.save();
    res.json({ trip });
  } catch (e) {
    console.error(`error in updateTrip controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function deleteTrip(
  req: AuthRequest<{ id: string }, any>,
  res: Response,
) {
  try {
    if (!req.user) return;
    const trip = await Trip.findById(req.params.id);
    if (!trip)
      return res
        .status(404)
        .json({ error: true, message: "Could not find the trip" });

    if (!trip.owner.equals(req.user._id))
      return res
        .status(401)
        .json({ error: true, message: "Only the owner can delete this trip" });

    await trip.deleteOne();
    res.status(204);
  } catch (e) {
    console.error(`error in deleteTrip controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function createTrip(req: AuthRequest, res: Response) {
  const { name } = req.body;
  const partecipants = Array.isArray(req.body.partecipants)
    ? req.body.partecipants
    : [];
  try {
    if (!name)
      return res
        .status(400)
        .json({ error: true, message: "All fields are required" });

    if (!req.user) return;

    const newTrip = new Trip({
      name,
      owner: req.user._id,
      partecipants: [...partecipants, req.user._id],
    });

    req.user.trips.push(newTrip._id);

    await req.user.save();
    await newTrip.save();
    res.status(201).json({ newTrip });
  } catch (e) {
    console.error(`error in createTrip controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function generateInviteToken(
  req: AuthRequest<{ id: string }>,
  res: Response,
) {
  try {
    if (!req.user) return;

    const trip = await Trip.findById(req.params.id);
    if (!trip)
      return res
        .status(404)
        .json({ error: true, message: "Unable to find the requested Trip" });

    if (!req.user._id.equals(trip.owner))
      return res.status(401).json({
        error: true,
        message: "Only the owner can generate the invite token",
      });

    const inviteToken = generatetokenForTrip(trip._id.toString());

    res.json({ inviteToken });
  } catch (e) {
    console.error(`error in generateInviteToken controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}

export async function joinTrip(req: AuthRequest, res: Response) {
  const { inviteToken } = req.body;
  try {
    if (!inviteToken)
      return res
        .status(400)
        .json({ error: true, message: "You must pass a invite token" });
    if (!req.user) return;
    const decoded = jwt.verify(inviteToken, process.env.INVITE_TOKEN_SECRET);
    if (!decoded)
      return res
        .status(400)
        .json({ error: true, message: "Invalid invite token" });

    const trip = await Trip.findById(decoded.tripID).populate("expenses");
    if (!trip)
      return res
        .status(404)
        .json({ error: true, message: "Could not find the trip" });

    if (trip.partecipants.includes(req.user._id))
      return res.status(400).json({ error: true, message: "Already joined" });

    trip.partecipants.push(req.user._id);
    req.user.trips.push(trip._id);
    await trip.save();
    await req.user.save();

    res.json({ userTrips: req.user.trips });
  } catch (e) {
    console.error(`error in joinTrip controller: ${e}`);
    res.status(500).json({ error: true, message: "Someting went wrog" });
  }
}
