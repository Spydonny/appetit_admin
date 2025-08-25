import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  String? _token;

  bool get isLoggedIn => _token != null;

  void login(String token) {
    _token = token;
    notifyListeners();
  }

  void logout() {
    _token = null;
    notifyListeners();
  }

  /// Имитация проверки токена (можно подменить на API запрос)
  Future<bool> validateToken() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _token != null && _token!.isNotEmpty;
  }
}