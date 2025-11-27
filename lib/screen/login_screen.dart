import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback show;
  const LoginScreen(this.show, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  FocusNode email_F = FocusNode();
  final passwordController = TextEditingController();
  FocusNode password_F = FocusNode();

  @override
  void initState() {
    super.initState();
    email_F.addListener(() {
      setState(() {});
    });
    password_F.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 96.w, height: 100.h),
            Center(child: Image.asset("images/logo.jpg")),
            SizedBox(height: 120.h),
            textField(emailController, email_F, "Email", Icons.email),
            SizedBox(height: 15.h),
            textField(passwordController, password_F, "Mật khẩu", Icons.lock),
            SizedBox(height: 10.h),
            Forgot(),
            SizedBox(height: 10.h),
            Login(),
            SizedBox(height: 10.h),
            Have(),
          ],
        ),
      ),
    );
  }

  Widget Have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Chưa có tài khoản? ",
            style: TextStyle(color: Colors.grey, fontSize: 13.sp),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              "Đăng ký ",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Login() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          "Đăng nhập",
          style: TextStyle(
            color: Colors.white,
            fontSize: 23.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget Forgot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Text(
        "Quên mật khẩu?",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget textField(
    TextEditingController controller,
    FocusNode focus,
    String type,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: TextField(
            style: TextStyle(fontSize: 18.sp, color: Colors.black),
            controller: controller,
            focusNode: focus,
            decoration: InputDecoration(
              hintText: type,
              prefixIcon: Icon(
                icon,
                color: focus.hasFocus ? Colors.black : Colors.grey,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 15.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: Colors.grey, width: 2.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: Colors.black, width: 2.w),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
