from flask import Flask, request, jsonify
from flask_cors import CORS
from groq import Groq
from dotenv import load_dotenv
import os
import json

load_dotenv()

GROQ_API_KEY = os.getenv("GROQ_API_KEY")
if not GROQ_API_KEY:
    raise ValueError("GROQ_API_KEY is not set in your .env file")

client = Groq(api_key=GROQ_API_KEY)

app = Flask(__name__)
CORS(app)

@app.route('/api/analyze-breach', methods=['POST'])
def analyze_breach():
    try:
        json_breach_content = request.get_json()
        if not json_breach_content:
            return jsonify({"error": "Invalid JSON input"}), 400

        # Turn dictionary into formatted string
        formatted_json_str = json.dumps(json_breach_content, indent=4)

        prompt = f"""
         You are an expert in analysing a JSON file telling about a user's data breach. You have to carefully analyze it and provide a response containing the following schema:

            1. A list of column labels and a corresponding list of percentage values for each category(like entertainment, miscellaneous...where data is breached) — used in a Flutter pie chart.

            2. The above two lists should have keys: pie_labels and pie_percentage.

            3. All your response should be pure JSON, extractable using keys.

            4. Also include a key advices containing at least 5 ordered security advice strings.

           
        Analyze this JSON:
        ```json
        {formatted_json_str}
        ```

        IMPORTANT: Response should ONLY contain valid JSON, no explanations.
        """

        chat_completion = client.chat.completions.create(
            messages=[
                {
                    "role": "user",
                    "content": prompt
                }
            ],
            model="llama-3.3-70b-versatile",
        )

        response_content = chat_completion.choices[0].message.content

        # Extract valid JSON from triple backticks if needed
        start = response_content.find("{")
        end = response_content.find("}") + 1
        extracted_json = response_content[start:end]

        parsed = json.loads(extracted_json)
        return jsonify(parsed)

    except json.JSONDecodeError:
        return jsonify({"error": "Invalid JSON returned by AI"}), 500
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
