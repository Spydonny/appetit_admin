import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthRepo {
  final String baseUrl;

  AuthRepo({required this.baseUrl});

  /// Регистрация через email или телефон
  Future<User> register({
    required String fullName,
    String? email,
    String? phone,
    String? dob,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "dob": dob,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ??
          'Failed to register user');
    }
  }

  /// Логин через email/phone + password
  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email_or_phone": emailOrPhone,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "accessToken": data['access_token'],
        "user": User.fromJson(data['user']),
      };
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to login');
    }
  }
}