import 'package:app/widgets/post_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 10.w),
        centerTitle: true,
        elevation: 0,
        title: SizedBox(
          height: 28.h,
          width: 105.w,
          child: Image.asset("images/instagram.png"),
        ),
        leading: Image.asset("images/camera.png"),
        actions: [
          const Icon(Icons.favorite_border_outlined, color: Colors.black),
          SizedBox(width: 10.w),
          Image.asset("images/send small.png"),
        ],
        backgroundColor: const Color(0xffFAFAFA),
      ),

      body: CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: _firebaseFirestore.collection("posts").orderBy('time', descending: true).snapshots(),
            builder: (context, snapshot)  {
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return PostWidget(snapshot.data!.docs[index].data());
                }, childCount: snapshot.data == null ? 0 : snapshot.data!.docs.length),
              );
            }
          ),
        ],
      ),
    );
  }
}
