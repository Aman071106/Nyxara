import { Router } from "express";
import { leakedPasswordAnalyzerController } from "../controllers/leakedPasswordAnalyzerController";

const router = Router();

router.get("/isPasswordLeaked", leakedPasswordAnalyzerController);

export default router;
