import 'package:flutter/material.dart';
import '../models/login_result.dart';
import '../services/login_service.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider({required LoginService service}) : _service = service;

  final LoginService _service;

  bool _isLoading = false;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> init() async {
    final tokenData = _service.getStoredToken();

    _isLoggedIn = tokenData != null && !tokenData.isExpired;
    notifyListeners();
  }

  Future<LoginStatus> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.login(username: username, password: password);

    _isLoading = false;

    _isLoggedIn = result.status == LoginStatus.success;
    notifyListeners();

    return result.status;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _service.clearToken();
    _isLoggedIn = false;

    _isLoading = false;
    notifyListeners();
  }
}
