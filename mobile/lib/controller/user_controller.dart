import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode, defaultTargetPlatform, TargetPlatform;
import 'package:http/http.dart' as http;
import 'package:mobile/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kBaseUrl = AppRouter.main_domain;

class UserController {
  UserController(this._client, this._sp);
  final http.Client _client;
  final SharedPreferences _sp;

  /// Factory khởi tạo kèm SharedPreferences
  static Future<UserController> create() async {
    final sp = await SharedPreferences.getInstance();
    return UserController(http.Client(), sp);
  }

  String? get token => _sp.getString('token');

  Future<bool> login({required String email, required String password}) async {
    final res = await _client.post(
      Uri.parse('$kBaseUrl/account/login'),
      headers: {'Content-Type': 'application/json'},
      // Nếu server bạn vẫn dùng 'password_hash', đổi key ở đây
      body: jsonEncode({'email': email, 'password_hash': password}),
    );

    if (res.statusCode != 200) {
      // cố gắng đọc message lỗi
      try {
        final err = jsonDecode(res.body);
        throw Exception(err['error'] ?? err['message'] ?? 'Login failed');
      } catch (_) {
        throw Exception('Login failed (${res.statusCode})');
      }
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;

    // Nếu server trả JWT
    final t = data['token'] as String?;
    if (t != null && t.isNotEmpty) {
      await _sp.setString('token', t);
    }

    return true;
  }

  /// Lấy tên hiển thị từ /account/me (cần token)
  Future<String> fetchDisplayName() async {
    final t = token;
    if (t == null) throw Exception('No token');

    final res = await _client.get(
      Uri.parse('$kBaseUrl/account/me'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $t',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Fetch profile failed (${res.statusCode})');
    }

    final json = jsonDecode(res.body);
    final user = json['user'] ?? json;
    final name = (user['fullName'] ).toString();
    return name;
  }

  Future<void> logout() async {
    await _sp.remove('token');
  }
}
