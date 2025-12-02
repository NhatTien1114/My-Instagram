import 'package:app/util/exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../model/usermodel.dart';

class Firebase_Firestor {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser({
    required String email,
    required String userName,
    required String bio,
    required String profile,
  }) async {
    await _firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .set({
          'email': email,
          'userName': userName,
          'bio': bio,
          'profile': profile,
          'follower': [],
          'following': [],
        });
    return true;
  }

  Future<Usermodel> getUser() async {
    try {
      final user = await _firebaseFirestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get();
      final snapuser = user.data()!;
      return Usermodel(
        snapuser['email'],
        snapuser['bio'],
        snapuser['profile'],
        snapuser['userName'],
        snapuser['following'],
        snapuser['follower'],
      );
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }

  Future<bool> CreatePost({
    required String postImage,
    required String caption,
    required location,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection('posts').doc(uid).set({
      'postImage': postImage,
      'userName': user.userName,
      'profileImage': user.profile,
      'caption': caption,
      'location': location,
      'uuid': _auth.currentUser!.uid,
      'postId': uid,
      'like': [],
      'time': data,
    });
    return true;
  }

  Future<bool> CreateReels({
    required String video,
    required String caption,
}) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection("reels").doc(uid).set({
      'reelsvideo': video,
      'userName': user.userName,
      'profileImage': user.profile,
      'caption': caption,
      'uuid': _auth.currentUser!.uid,
      'postId': uid,
      'like': [],
      'time': data,
    });
    return true;
  }
}
