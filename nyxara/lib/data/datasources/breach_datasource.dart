import 'dart:convert';

import 'package:nyxara/data/models/breach_analytics_model.dart';
import 'package:http/http.dart' as http;

class BreachDatasource {
  final String baseURL = "https://nyxara-backend.onrender.com";

  Future<bool> checkBreach(String email) async {
    final Uri url = Uri.parse("$baseURL/api/check-email?email=${Uri.encodeComponent(email)}");
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
    final Uri url = Uri.parse("$baseURL/api/check-breach-analytics?email=${Uri.encodeComponent(email)}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return AnalyticsModel.fromJson(jsonMap);
      } else {
        print("Failed to fetch breach analytics, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching analytics: ${e.toString()}");
    }
    return null;
  }
}
