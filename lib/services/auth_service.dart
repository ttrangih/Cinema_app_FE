// lib/services/auth_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/app_config.dart';
import 'api_service.dart';

class AuthService {
  final _api = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _api.post('/auth/login', data: {'email': email, 'password': password});
    final token = res.data['token'];
    final user = UserModel.fromJson(res.data['user']);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.tokenKey, token);
    await prefs.setString(AppConfig.userKey, jsonEncode(user.toJson()));
    return {'token': token, 'user': user};
  }

  Future<void> register(String fullName, String email, String password) async {
    await _api.post('/auth/register', data: {'fullName': fullName, 'email': email, 'password': password});
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.tokenKey);
    await prefs.remove(AppConfig.userKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.tokenKey);
  }

  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConfig.userKey);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw));
  }
}
