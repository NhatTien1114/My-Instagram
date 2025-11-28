import 'package:app/widgets/post_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: SizedBox(
          height: 28.h,
          width: 105.w,
          child: Image.asset("images/instagram.jpg"),
        ),
        leading: Image.asset("images/camera.jpg"),
        actions: [
          const Icon(Icons.favorite_border_outlined, color: Colors.black),
          SizedBox(width: 10.w),
          Image.asset("images/send.jpg"),
        ],
        backgroundColor: const Color(0xffFAFAFA),
      ),

      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return PostWidget();
            }, childCount: 5),
          ),
        ],
      ),
    );
  }
}
