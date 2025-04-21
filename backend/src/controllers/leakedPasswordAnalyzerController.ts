import { Request, Response } from "express";
import { leakedPasswordAnalyzerService } from "../services/leakedPasswordAnalyzerService";

export const leakedPasswordAnalyzerController = async (req: Request, res: Response): Promise<void> => {
    const shaHash = req.query.shaHash as string;
  
    if (!shaHash) {
      res.status(400).json({ error: "sha hash not found correct" });
      return;
    }
  
    try {
      const result = await leakedPasswordAnalyzerService(shaHash);
      res.json(result);
    } catch (error: any) {
      res.status(error.status || 500).json({ error: error.message || "Internal Server Error" });
    }
  };
  
