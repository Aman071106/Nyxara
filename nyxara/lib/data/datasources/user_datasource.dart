import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/user_auth_model.dart';

class NyxaraDB {
  final String baseUrl = 'https://nyxara-backend.onrender.com';

  /// Register User
  Future<User?> createUser(String email, String password) async {
    final userValues = {'email': email, 'password': password};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userValues),
      );

      log('Register Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 201) {
        return User(email: email,password: password); // Replace with model parsing if needed
      } else {
        print('Failed to register: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  /// Login User
  Future<String?> checkUser(String email, String password) async {
    final userValues = {'email': email, 'password': password};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userValues),
      );

      log('Login Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        return token;
      } else {
        print('Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}
