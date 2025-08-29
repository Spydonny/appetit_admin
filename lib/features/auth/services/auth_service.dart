import 'dart:convert';

import 'package:appetit_admin/core/core.dart';
import 'package:appetit_admin/core/router/token_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data.dart';

class AuthService {
  final AuthRepo _repo;
  String? _accessToken;
  User? _currentUser;

  AuthService(this._repo);

  String? get accessToken => _accessToken;

  User? get currentUser => _currentUser;

  /// Load token + user from local storage
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken');
    final userJson = prefs.getString('user');

    if (_accessToken != null) {
      getIt<TokenNotifier>().setToken(_accessToken!);
    }

    if (userJson != null) {
      _currentUser = User.fromJson(jsonDecode(userJson));
    }
  }

  /// Save session to local storage
  Future<void> _saveSession(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    await prefs.setString('user', jsonEncode(user.toJson()));

    getIt<TokenNotifier>().setToken(token); // ✅ через getIt
    _accessToken = token;
    _currentUser = user;
  }

  /// Register new user (email/phone + password)
  Future<User> register({
    required String fullName,
    String? email,
    String? phone,
    required String dob,
    required String password,
  }) async {
    final user = await _repo.register(
      fullName: fullName,
      email: email,
      phone: phone,
      dob: dob,
      password: password,
    );
    return user;
  }

  /// Login (email/phone + password)
  Future<User> login({
    required String emailOrPhone,
    required String password,
  })
  async {
    final result = await _repo.login(
      emailOrPhone: emailOrPhone,
      password: password,
    );

    final token = result['accessToken'];
    final user = result['user'] as User;

    await _saveSession(token, user);
    return user;
  }
}
