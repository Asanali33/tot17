import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String get baseUrl {
    // Для Web используем localhost
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    // Для Android эмулятора используем 10.0.2.2 вместо localhost
    // Для физического устройства используем localhost
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000/api';
      } else if (Platform.isIOS) {
        return 'http://localhost:3000/api';
      }
    } catch (e) {
      // Если Platform недоступна, используем localhost по умолчанию
      return 'http://localhost:3000/api';
    }
    return 'http://localhost:3000/api';
  }

  static Future<Map<String, dynamic>?> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      print('🔵 Регистрация пользователя: $username');
      print('📍 Подключение к: $baseUrl/auth/register');
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      ).timeout(Duration(seconds: 5));

      print('📡 Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Сохраняем токен
        await _saveToken(data['token']);
        print('✅ Регистрация успешна');
        return data;
      } else {
        final error = jsonDecode(response.body);
        return {'error': error['error'] ?? 'Ошибка регистрации'};
      }
    } catch (e) {
      print('❌ Ошибка регистрации: $e');
      return {'error': 'Ошибка подключения: $e'};
    }
  }

  static Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  }) async {
    try {
      print('🔵 Вход пользователя: $username');
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(Duration(seconds: 5));

      print('📡 Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Сохраняем токен
        await _saveToken(data['token']);
        print('✅ Вход успешен');
        return data;
      } else {
        final error = jsonDecode(response.body);
        return {'error': error['error'] ?? 'Ошибка входа'};
      }
    } catch (e) {
      print('❌ Ошибка входа: $e');
      return {'error': 'Ошибка подключения: $e'};
    }
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    print('✅ Выход выполнен');
  }

  static Future<bool> verifyToken() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 5));

      print('🔵 Проверка токена - статус: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Ошибка проверки токена: $e');
      return false;
    }
  }
}
