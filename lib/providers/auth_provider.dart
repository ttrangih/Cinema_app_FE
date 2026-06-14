// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final _auth = AuthService();
  AuthStatus _status = AuthStatus.unknown;
  UserModel? _user;
  bool _loading = false;
  String? _error;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> checkAuth() async {
    final token = await _auth.getToken();
    if (token != null) {
      _user = await _auth.getSavedUser();
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _auth.login(email, password);
      _user = result['user'];
      _status = AuthStatus.authenticated;
      _loading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = ApiService().errorMessage(e);
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _auth.register(fullName, email, password);
      _loading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = ApiService().errorMessage(e);
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
