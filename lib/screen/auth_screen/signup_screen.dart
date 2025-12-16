import 'dart:io';

import 'package:app/data/firebase_service/firebase_auth.dart';
import 'package:app/util/dialog.dart';
import 'package:app/util/exception.dart';
import 'package:app/util/imagepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  const SignupScreen(this.show, {super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  FocusNode email_F = FocusNode();
  final userNameController = TextEditingController();
  FocusNode userName_F = FocusNode();
  final bioController = TextEditingController();
  FocusNode bio_F = FocusNode();
  final passwordController = TextEditingController();
  FocusNode password_F = FocusNode();
  final confirmPasswordController = TextEditingController();
  FocusNode confirmPassword_F = FocusNode();
  bool isShowPass = false;
  bool isShowConfirm = false;

  File? _imageFile;
  @override
  void initState() {
    super.initState();
    email_F.addListener(() {
      setState(() {});
    });
    userName_F.addListener(() {
      setState(() {});
    });
    bio_F.addListener(() {
      setState(() {});
    });
    password_F.addListener(() {
      setState(() {});
    });
    confirmPassword_F.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: 96.w, height: 100.h),
              Center(child: Image.asset("images/logo.png")),
              SizedBox(height: 60.h),
              Center(
                child: InkWell(
                  onTap: () async {
                    File? _imageFilee = await ImagePickerr().uploadImage(
                      "gallery",
                    );
                    if (_imageFilee != null) {
                      setState(() {
                        _imageFile = _imageFilee;
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 36.r,
                    backgroundColor: Colors.grey,
                    child: _imageFile == null
                        ? CircleAvatar(
                            radius: 34.r,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: AssetImage('images/person.png'),
                          )
                        : CircleAvatar(
                            radius: 34.r,
                            backgroundImage: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ).image,
                            backgroundColor: Colors.grey.shade200,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              textField(emailController, email_F, "Email", Icons.email),
              SizedBox(height: 15.h),
              textField(
                userNameController,
                userName_F,
                "Tên đăng nhập",
                Icons.person,
              ),
              SizedBox(height: 15.h),
              textField(bioController, bio_F, "Tiểu sử", Icons.abc),
              SizedBox(height: 15.h),
              Padding(
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
                      controller: passwordController,
                      focusNode: password_F,
                      obscureText: !isShowPass,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: password_F.hasFocus ? Colors.black : Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              isShowPass = !isShowPass;
                            });
                          },
                          icon: isShowPass ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
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
              ),
              SizedBox(height: 15.h),
              Padding(
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
                      controller: confirmPasswordController,
                      focusNode: confirmPassword_F,
                      obscureText: !isShowConfirm,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: confirmPassword_F.hasFocus ? Colors.black : Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              isShowConfirm = !isShowConfirm;
                            });
                          },
                          icon: isShowConfirm ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
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
              ),
              SizedBox(height: 20.h),
              Signup(),
              SizedBox(height: 10.h),
              Have(),
            ],
          ),
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
              "Đăng nhập ",
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

  Widget Signup() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: () async {
          if (_imageFile == null) {
            dialogBuilder(context, "Vui lòng chọn ảnh đại diện.");
            return;
          }
          try {
            await Authentication().Signup(
              email: emailController.text,
              password: passwordController.text,
              passwordConfirm: confirmPasswordController.text,
              bio: bioController.text,
              userName: userNameController.text,
              profile: _imageFile!,
            );
            await Authentication().signOut();
            widget.show();
          } on exceptions catch (e) {
            dialogBuilder(context, e.message);
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            "Đăng ký",
            style: TextStyle(
              color: Colors.white,
              fontSize: 23.sp,
              fontWeight: FontWeight.bold,
            ),
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
