import 'package:flutter/material.dart';
import 'package:flutter_proj_1/models/token.dart';
import '../models/login_result.dart';
import '../services/login_service.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider({required LoginService service}) : _service = service;

  final LoginService _service;

  Token? _token;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  String get token => _token?.token ?? '';

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> init() async {
    final tokenData = _service.getStoredToken();
    if (tokenData != null && !tokenData.isExpired) {
      _token = tokenData;
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<LoginStatus> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.login(username: username, password: password);

    _isLoading = false;

    if (result.status == LoginStatus.success) {
      _token = _service.getStoredToken();
      _isLoggedIn = true;
    }
    notifyListeners();

    return result.status;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _service.clearToken();
    _token = null;
    _isLoggedIn = false;

    _isLoading = false;
    notifyListeners();
  }
}
