import 'package:flutter/material.dart';
import 'package:mobile/common/app_button.dart';
import 'package:mobile/config/assets/app_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/config/themes/app_color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(AppImages.img_login, width: 279.w, height: 279.h),
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
                child: AppButton(content: 'Logn In', onPressed: () => {}),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(child: Divider(thickness: 1, color: Colors.black)),
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
                  Expanded(child: Divider(thickness: 1, color: Colors.black)),
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
              onPressed: () {},
              icon: Icon(
                Icons.remove_red_eye_outlined,
                color: AppColor.textColor,
                // size: 20,
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
      onPressed: () {},
      fillColor: const Color(0xffD9D9D9),
      constraints: const BoxConstraints.tightFor(width: 50, height: 50),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Center(child: child ?? const Icon(Icons.more_horiz)),
    );
  }
}
