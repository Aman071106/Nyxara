import { Router } from "express";
import { breachAnalyticsController } from "../controllers/breachAnalyticsController";

const router = Router();

router.get("/check-breach-analytics", breachAnalyticsController);

export default router;
