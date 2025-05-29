import axios from "axios";

export const breachAnalyticsService = async (email: string) => {
  const url = `https://api.xposedornot.com/v1/breach-analytics?email=${encodeURIComponent(email)}`;
  
  try {
    const response = await axios.get(url, {
      headers: {
        "User-Agent": "Mozilla/5.0 (compatible; NyxaraBot/1.0)",
      },
    });
    return response.data;
  } catch (error: any) {
    console.error("XposedOrNot breach analytics error:", error.response?.data);

    if (error.response) {
      throw {
        status: error.response.status,
        message: error.response.data?.Error || error.response.data?.message || "API Error",
      };
    }
    throw {
      status: 500,
      message: "Server Error",
    };
  }
};
