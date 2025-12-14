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

  Future<Usermodel> getUser({String? uidd}) async {
    try {
      final user = await _firebaseFirestore
          .collection("users")
          .doc(uidd ?? _auth.currentUser!.uid)
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

  Future<bool> CreateComment({
    required String comment,
    required String type,
    required String uidd,
  }) async {
    var uid = Uuid().v4();
    Usermodel user = await getUser();
    await _firebaseFirestore
        .collection(type)
        .doc(uidd)
        .collection("comments")
        .doc(uid)
        .set({
          'comment': comment,
          'userName': user.userName,
          'profileImage': user.profile,
          'CommentUid': uid,
        });
    return true;
  }

  Future<String> like({
    required List like,
    required String type,
    required String uid,
    required String postId,

    required,
  }) async {
    String res = "some error";
    try {
      if (like.contains(uid)) {
        await _firebaseFirestore.collection(type).doc(postId).update({
          'like': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection(type).doc(postId).update({
          'like': FieldValue.arrayUnion([uid]),
        });
      }
      res = "success";
    } on Exception catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> follow({required String uid}) async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    List following = (snap.data()! as dynamic)['following'];
    try {
      if (following.contains(uid)) {
        _firebaseFirestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
              'following': FieldValue.arrayRemove([uid]),
            });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'follower': FieldValue.arrayRemove([_auth.currentUser!.uid]),
        });
      } else {
        _firebaseFirestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
              'following': FieldValue.arrayUnion([uid]),
            });
        _firebaseFirestore.collection('users').doc(uid).update({
          'follower': FieldValue.arrayUnion([_auth.currentUser!.uid]),
        });
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
