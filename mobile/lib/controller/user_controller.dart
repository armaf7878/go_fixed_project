// lib/controller/user_controller.dart
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/router/app_router.dart';
import 'package:mobile/data/remote/user_api.dart';
// (tuỳ chọn) import model User nếu bạn đã có:
// import 'package:mobile/domain/model/user.dart';

class UserController {
  UserController(this._api, this._sp);

  final UserApi _api;
  final SharedPreferences _sp;

  /// Tạo controller kèm SharedPreferences + http.Client
  static Future<UserController> create({String? baseUrl}) async {
    final sp = await SharedPreferences.getInstance();
    final api = UserApi(http.Client(), baseUrl ?? AppRouter.main_domain);
    return UserController(api, sp);
  }

  String? get token => _sp.getString('token');
  bool get isLoggedIn => (token != null && token!.isNotEmpty);

  /// Đăng nhập: lưu token (nếu có). Trả true nếu OK.
  Future<bool> login({
    required String email,
    required String password,
    bool useHashKey = true, // đổi về false nếu server dùng 'password'
  }) async {
    final (t, userJson) = await _api.login(
      email: email,
      password: password,
      useHashKey: useHashKey,
    );

    if (t != null && t.isNotEmpty) {
      await _sp.setString('token', t);
      return true;
    }

    // Không có token nhưng vẫn coi là OK (tuỳ nhu cầu)
    // Có thể lưu tạm tên/email để hiển thị:
    // await _sp.setString('temp_name', (userJson['fullname'] ?? userJson['email'] ?? 'User').toString());
    return true;
  }

  /// Lấy tên hiển thị từ /account/me (cần token)
  Future<String> fetchDisplayName() async {
    final t = token;
    if (t == null || t.isEmpty) {
      // thử fallback temp_name nếu bạn đã lưu
      final tmp = _sp.getString('temp_name');
      if (tmp != null && tmp.isNotEmpty) return tmp;
      throw Exception('No token');
    }

    final user = await _api.me(token: t);
    final name = (user['fullName'] ?? user['fullname'] ?? user['email'] ?? 'User').toString();
    return name;
  }

  Future<void> logout() async {
    await _sp.remove('token');
    await _sp.remove('temp_name');
  }

  void dispose() {
    _api.dispose();
  }
}
