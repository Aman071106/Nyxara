import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/user_auth_model.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';

class NyxaraDB {
  final String baseUrl = 'https://nyxara-backend.onrender.com';

  // Register User
  Future<User?> createUser(String email, String password) async {
    final userValues = {'email': email, 'password': password};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userValues),
      );

      developer.log(
        'Register Response: ${response.statusCode} ${response.body}',
      );

      if (response.statusCode == 201) {
        return User(
          email: email,
          password: password,
        ); // Replace with model parsing if needed
      } else {
        print('Failed to register: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  // Login User
  Future<String?> checkUser(String email, String password) async {
    final userValues = {'email': email, 'password': password};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userValues),
      );

      developer.log('Login Response: ${response.statusCode} ${response.body}');

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

  // Send otp
  Future<int?> SendOtp(String email) async {
    final String serviceid = dotenv.env['SERVICE_ID']!;
    final String templateid = dotenv.env['TEMPLATE_ID']!;
    final String privateKey = dotenv.env['PRIVATE_KEY']!;
    final String publicKey = dotenv.env['PUBLIC_KEY']!;
    developer.log(serviceid);
    final random = Random();
    int otp = 100000 + random.nextInt(900000);
    developer.log(otp.toString());
    try {
      await emailjs.send(
        serviceid,
        templateid,
        {'email': email, 'passcode': otp},
        emailjs.Options(publicKey: publicKey, privateKey: privateKey),
      );
      developer.log('SUCCESS!');
      return otp;
    } catch (error) {
      developer.log("Error in email sending $error");
      return null;
    }
  }
}
