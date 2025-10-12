import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/common/app_button.dart';
import 'package:mobile/config/assets/app_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/config/themes/app_color.dart';
import 'package:mobile/router/app_router.dart';
import 'package:mobile/view/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kBaseUrl = AppRouter.main_domain;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final pwd = _pwdController.text;

    if (email.isEmpty || pwd.isEmpty) {
      _showSnack('Vui lòng nhập email và mật khẩu');
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await http.post(
        Uri.parse('$kBaseUrl/account/login'),
        headers: {'Content-Type': 'application/json'},
        // Nếu server bạn đang nhận password_hash thay vì password:
        // body: jsonEncode({'email': email, 'password_hash': pwd}),
        body: jsonEncode({'email': email, 'password_hash': pwd}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;

        // Nếu bạn đã làm JWT ở server:
        final token = data['token'] as String?;
        if (token != null) {
          final sp = await SharedPreferences.getInstance();
          await sp.setString('token', token);
        }

        _showSnack('Đăng nhập thành công!');
        // // TODO: điều hướng sang Home
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Mainscreen()),
        );
      } else {
        // cố gắng đọc message từ server
        String msg = 'Đăng nhập thất bại (${res.statusCode})';
        try {
          final err = jsonDecode(res.body);
          msg = (err['error'] ?? err['message'] ?? msg).toString();
        } catch (_) {}
        _showSnack(msg);
      }
    } catch (e) {
      _showSnack('Lỗi kết nối: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      AppImages.img_login,
                      width: 279.w,
                      height: 279.h,
                    ),
                    Positioned(
                      bottom: 50,
                      right: 0,
                      child: Image.asset(
                        AppImages.img_man,
                        width: 187.w,
                        height: 187.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'Log In',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 20.h),
                _textFieldEmail(context),
                SizedBox(height: 20.h),
                _textFieldPwd(context),
                // SizedBox(height: 5.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forget password",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      content: 'Log In',
                      onPressed: () async {
                        if (_loading) return;
                        await _login();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Sign In With",
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: 16.sp,
                          ),
                        ), // dòng chữ ở giữa
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Orther(
                      onTap: () {
                        /* TODO */
                      },
                      child: Image.asset(
                        AppImages.img_google,
                        width: 0.5.sw, // 60% chiều rộng màn hình
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20),
                    _Orther(
                      onTap: () {
                        /* TODO */
                      },
                      child: Image.asset(
                        AppImages.img_facebook,
                        width: 0.5.sw, // 60% chiều rộng màn hình
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldEmail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffFFEEDF),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 1),
              blurRadius: 10,
              spreadRadius: -5,
            ),
          ],
        ),
        child: TextField(
          controller: _emailController,
          cursorColor: AppColor.primaryColor,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email_outlined, color: AppColor.textColor),
            hintText: 'Nhập email',
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black26),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.primaryColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldPwd(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffFFEEDF),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 1),
              blurRadius: 10,
              spreadRadius: -5,
            ),
          ],
        ),
        child: TextField(
          controller: _pwdController,
          cursorColor: AppColor.primaryColor,
          style: TextStyle(color: Colors.black),
          obscureText: true,
          decoration: InputDecoration(
            hintText: "PassWord",
            hintStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(Icons.key_sharp, color: AppColor.textColor),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: AppColor.textColor,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _Orther({required VoidCallback onTap, Widget? child}) {
    return RawMaterialButton(
      onPressed: onTap,
      fillColor: const Color(0xffD9D9D9),
      constraints: const BoxConstraints.tightFor(width: 50, height: 50),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Center(child: child ?? const Icon(Icons.more_horiz)),
    );
  }
}
