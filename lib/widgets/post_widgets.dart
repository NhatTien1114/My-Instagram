import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35.w,
                  height: 35.h,
                  child: Image.asset("images/person.png"),
                ),
              ),
              title: Text("username", style: TextStyle(fontSize: 13.sp)),
              subtitle: Text("location", style: TextStyle(fontSize: 11.sp)),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ),
        Container(
          height: 375.h,
          width: 375.w,
          child: Image.asset("images/post.jpg", fit: BoxFit.cover),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 14.h),
              Row(
                children: [
                  SizedBox(width: 14.w),
                  Icon(Icons.favorite_border_outlined, size: 25.w),
                  SizedBox(width: 17.w),
                  Image.asset("images/comment.webp", height: 28.h),
                  SizedBox(width: 17.w),
                  Image.asset('images/send.jpg', height: 28.h),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Image.asset("images/save.png", height: 28.h),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 324.w, top: 7.5.h, bottom: 5.h),
                child: Text(
                  "0",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Text(
                      "username " + '',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("caption", style: TextStyle(fontSize: 13.sp)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 288.w, top: 10.h, bottom: 8.h),
                child: Text(
                  'dateformat',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    ;
  }
}
