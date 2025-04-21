import axios from "axios";

export const checkEmailService = async (email: string) => {
  const url = `https://api.xposedornot.com/v1/check-email/${encodeURIComponent(email)}`;
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
