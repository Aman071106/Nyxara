import { Router } from "express";
import { checkEmailController } from "../controllers/emailController";

const router = Router();

router.get("/check-email", checkEmailController);

export default router;
