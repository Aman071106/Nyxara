import { Request, Response } from "express";
import { checkEmailService } from "../services/emailService";

export const checkEmailController = async (req: Request, res: Response): Promise<void> => {
    const email = req.query.email as string;
  
    if (!email) {
      res.status(400).json({ error: "Email is required" });
      return;
    }
  
    try {
      const result = await checkEmailService(email);
      res.json(result);
    } catch (error: any) {
      res.status(error.status || 500).json({ error: error.message || "Internal Server Error" });
    }
  };
  
