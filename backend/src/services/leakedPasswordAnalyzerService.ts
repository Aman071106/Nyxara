import axios from "axios";

export const leakedPasswordAnalyzerService = async (shaHash: string) => {
  const url = `https://passwords.xposedornot.com/v1/pass/anon/${encodeURIComponent(shaHash)}`;
  try {
    const response = await axios.get(url);
    return response.data;
  } catch (error: any) {
    if (error.response) {
      throw {
        status: error.response.status,
        message: error.response.data?.message || "API Error",
      };
    }
    throw {
      status: 500,
      message: "Server Error",
    };
  }
};
