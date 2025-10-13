// lib/data/remote/user_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  UserApi(this._client, this.baseUrl);

  final http.Client _client;
  final String baseUrl;

  /// Login: trả về (token, userJson). Đổi [useHashKey] tuỳ server (password vs password_hash)
  Future<(String? token, Map<String, dynamic> user)> login({
    required String email,
    required String password,
    bool useHashKey = true,
  }) async {
    final payload = <String, dynamic>{'email': email};
    payload[useHashKey ? 'password_hash' : 'password'] = password;

    final res = await _client
        .post(
          Uri.parse('$baseUrl/account/login'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 15));

    if (res.statusCode != 200) {
      throw Exception(_pickMsg(res.body, fallback: 'Login failed (${res.statusCode})'));
    }

    final data = _asMap(res.body);
    final token = (data['token'] as String?)?.trim();
    final user  = (data['user'] ?? data) as Map<String, dynamic>;
    return (token, user);
  }

  /// /account/me: trả về userJson
  Future<Map<String, dynamic>> me({required String token}) async {
    final res = await _client
        .get(
          Uri.parse('$baseUrl/account/me'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 15));

    if (res.statusCode != 200) {
      throw Exception('Fetch profile failed (${res.statusCode})');
    }
    final data = _asMap(res.body);
    final user = (data['user'] ?? data) as Map<String, dynamic>;
    return user;
  }

  void dispose() {
    _client.close();
  }

  // ===== helpers =====
  Map<String, dynamic> _asMap(String body) {
    final d = jsonDecode(body);
    if (d is Map<String, dynamic>) return d;
    throw Exception('Invalid JSON response');
  }

  String _pickMsg(String body, {required String fallback}) {
    try {
      final m = _asMap(body);
      return (m['error'] ?? m['message'] ?? fallback).toString();
    } catch (_) {
      return fallback;
    }
  }
}
