import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  static const String baseUrl = 'http://localhost/todobackend';

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'}, // Change header to form-urlencoded
        body: {
          'username': email,
          'password': password,
        }, // Sending form data
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _isAuthenticated = true;
          notifyListeners();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to connect to API');
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> register(String name, String password) async {
    final url = Uri.parse('$baseUrl/auth/register.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'}, // Change header to form-urlencoded
        body: {
          'username': name,
          'password': password,
        }, // Sending form data
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data['success']) {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to connect to API');
      }
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    // Reset authentication status
    _isAuthenticated = false;
    notifyListeners();
  }
}