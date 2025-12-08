import 'package:app/widgets/comment.dart';
import 'package:app/util/image_cached.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_format/date_format.dart';

class PostWidget extends StatelessWidget {
  final snapshot;
  PostWidget(this.snapshot, {super.key});

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
                  child: CachedImage(snapshot['profileImage']),
                ),
              ),
              title: Text(snapshot['userName'], style: TextStyle(fontSize: 13.sp)),
              subtitle: Text(snapshot['location'], style: TextStyle(fontSize: 11.sp)),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ),
        // Chứa hình ảnh
        Container(
          height: 375.h,
          width: 375.w,
          child: CachedImage(snapshot['postImage']),
        ),
        // Phần like, comment và share
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
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                        backgroundColor: Colors.transparent,
                          context: context,
                          builder:(context) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: DraggableScrollableSheet(
                                maxChildSize: 0.6,
                                initialChildSize: 0.6,
                                minChildSize: 0.2,
                                builder: (context, scrollController) {
                                return Comment("posts",snapshot['postId']);
                              },
                              ),
                            );
                          },
                      );
                    },
                      child: Image.asset("images/comment.webp", height: 28.h),
                  ),
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
                  snapshot['like'].length.toString(),
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
                      snapshot['userName'] + ' ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(snapshot["caption"], style: TextStyle(fontSize: 13.sp)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 288.w, top: 10.h, bottom: 8.h),
                child: Text(
                  formatDate(snapshot['time'].toDate(), [dd, '-', mm, '-', yyyy]),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
