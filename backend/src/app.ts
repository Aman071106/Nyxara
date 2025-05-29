import express from "express";
import cors from "cors";
import emailRoutes from "./routes/emailRoutes";
import breachAnalyticsRoutes from "./routes/breachAnalyticsRoutes";
import authRoutes from "./routes/authRoutes";

const app = express();

app.use(cors());
app.use(express.json());

// Register routes
app.use("/api", emailRoutes);
app.use("/api", breachAnalyticsRoutes);
app.use("/api/auth", authRoutes);

export default app;
