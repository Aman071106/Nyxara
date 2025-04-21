import express from "express";
import cors from "cors";
import emailRoutes from "./routes/emailRoutes";
import breachAnalyticsRoutes from "./routes/breachAnalyticsRoutes";
const app = express();

app.use(cors());
app.use(express.json());

// Register routes
app.use("/api", emailRoutes);
app.use("/api", breachAnalyticsRoutes);

export default app;
