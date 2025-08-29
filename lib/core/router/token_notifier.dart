import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TokenNotifier extends ValueNotifier<String> {
  TokenNotifier([super.initialToken = '']);

  /// Получить токен
  String get token => value;

  /// Установить новый токен
  void setToken(String newToken) {
    value = newToken;
  }

  /// Очистить токен
  void clearToken() {
    value = '';
  }

  /// Проверка, есть ли токен
  bool get hasToken => value.isNotEmpty;
}
