import 'dart:io';

import 'package:app/data/firebase_service/firestor.dart';
import 'package:app/data/firebase_service/storage.dart';
import 'package:app/util/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> Login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }

  Future<void> Signup({
    required String email,
    required String password,
    required String passwordConfirm,
    required String bio,
    required String userName,
    required File profile,
  }) async {
    String URL;
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          userName.isNotEmpty &&
          bio.isNotEmpty) {
        if (password == passwordConfirm) {
          await _auth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

          // Tải ảnh lên FireStorage
          if (profile != File('')) {
            URL = await StorageMethod().uploadImageToStorage(
              "Profile",
              profile,
            );
          } else {
            URL = "";
          }

          // Lấy thông tin với firestor
          await Firebase_Firestor().createUser(
            email: email,
            userName: userName,
            bio: bio,
            profile: URL == '' ? '' : URL,
          );
        } else {
          throw Exception("Mật khẩu và xác nhận mật khẩu không khớp");
        }
      } else {
        throw exceptions("Nhập hết thông tin");
      }
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }
}
