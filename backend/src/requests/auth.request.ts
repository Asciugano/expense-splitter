import type { Request } from "express";
import { type UserDocument } from "../models/user.model.ts";

export interface AuthRequest<
  Params = {},
  Body = any,
  Query = any,
> extends Request<Params, any, Body, Query> {
  user?: UserDocument;
}
