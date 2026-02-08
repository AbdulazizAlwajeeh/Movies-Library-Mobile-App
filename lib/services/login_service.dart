import 'dart:convert';
import 'package:flutter_proj_1/models/login_result.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/token.dart';

class LoginService {
  static const String baseUrl = 'http://16.171.43.166/api/Account/Login';

  LoginService(this._box);

  final Box _box;

  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse(baseUrl);

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = Token.fromJson(jsonDecode(response.body));
      await _box.put('token', token.toJson());
      return const LoginResult(status: LoginStatus.success);
    }

    if (response.statusCode == 401) {
      return const LoginResult(status: LoginStatus.invalidCredentials);
    }

    return const LoginResult(status: LoginStatus.serverError);
  }

  Token? getStoredToken() {
    final data = _box.get('token');
    if (data == null) return null;
    return Token.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> clearToken() async {
    await _box.delete('token');
  }
}
