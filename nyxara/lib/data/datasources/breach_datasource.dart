import 'dart:convert';
import 'dart:developer';

import 'package:nyxara/data/models/advice_response_model.dart';
import 'package:nyxara/data/models/breach_analytics_model.dart';
import 'package:http/http.dart' as http;

class BreachDatasource {
  final String baseURL = "https://nyxara-backend.onrender.com";
  String jsonBody = '';
  Future<bool> checkBreach(String email) async {
    final Uri url = Uri.parse(
      "$baseURL/api/check-email?email=${Uri.encodeComponent(email)}",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return jsonMap['email'] != null;
      } else {
        print("Failed to check breach, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error checking breach: ${e.toString()}");
    }
    return false;
  }

  Future<AnalyticsModel?> fetchBreachAnalytics(String email) async {
    final Uri url = Uri.parse(
      "$baseURL/api/check-breach-analytics?email=${Uri.encodeComponent(email)}",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        jsonBody = response.body;
        fetchAdvice();
        return AnalyticsModel.fromJson(jsonMap);
      } else {
        print(
          "Failed to fetch breach analytics, status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Error fetching analytics: ${e.toString()}");
    }
    return null;
  }

  Future<AdviceResponseModel?> fetchAdvice() async {
    Uri url = Uri.parse('https://nyxaraagent.onrender.com/api/analyze-breach');

    try {
      //to remove the non useful data
      Map<String, dynamic> originalJson = jsonDecode(jsonBody);

      originalJson.remove("ExposedBreaches");

      String cleanedJson = jsonEncode(originalJson);
      log("CleanedJson: $originalJson");
      //Send POST request
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: cleanedJson,
      );

      if (response.statusCode == 200) {
        // Parse and return your model

        log("In if block :${response.statusCode},${response.body}");
        return AdviceResponseModel.fromJson(jsonDecode(response.body));
      } else {
        log("${response.statusCode},${response.body}");
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
