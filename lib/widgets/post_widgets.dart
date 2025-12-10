import 'package:app/data/firebase_service/firestor.dart';
import 'package:app/widgets/comment.dart';
import 'package:app/util/image_cached.dart';
import 'package:app/widgets/like_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostWidget extends StatefulWidget {
  final snapshot;

  const PostWidget(this.snapshot, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!.uid;
  }

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
                  child: CachedImage(widget.snapshot['profileImage']),
                ),
              ),
              title: Text(
                widget.snapshot['userName'],
                style: TextStyle(fontSize: 13.sp),
              ),
              subtitle: Text(
                widget.snapshot['location'],
                style: TextStyle(fontSize: 11.sp),
              ),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ),
        // Chứa hình ảnh
        GestureDetector(
          onDoubleTap: () {
            if (!widget.snapshot['like'].contains(user)) {
              Firebase_Firestor().like(
                like: widget.snapshot['like'],
                type: "posts",
                uid: user,
                postId: widget.snapshot['postId'],
              );
            }
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              SizedBox(
                height: 375.h,
                width: 375.w,
                child: CachedImage(widget.snapshot['postImage']),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isAnimating,
                  duration: const Duration(milliseconds: 400),
                  End: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                  child: Icon(Icons.favorite, size: 100.w, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        // Phần like, comment và share
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 14.h),
              Row(
                children: [
                  SizedBox(width: 6.w),
                  LikeAnimation(
                      isAnimating: widget.snapshot['like'].contains(user),
                      child: IconButton(
                        onPressed: () {
                          Firebase_Firestor().like(
                            like: widget.snapshot['like'],
                            type: 'posts',
                            uid: user,
                            postId: widget.snapshot['postId'],
                          );
                        },
                        icon: Icon(
                          widget.snapshot['like'].contains(user)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.snapshot['like'].contains(user)
                              ? Colors.red
                              : Colors.black,
                          size: 24.w
                        ),
                      ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: DraggableScrollableSheet(
                              maxChildSize: 0.6,
                              initialChildSize: 0.6,
                              minChildSize: 0.2,
                              builder: (context, scrollController) {
                                return Comment(
                                  "posts",
                                  widget.snapshot['postId'],
                                );
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
                padding: EdgeInsets.only(left: 24.w, top: 1.h, bottom: 5.h),
                child: Text(
                  '${widget.snapshot['like'].length}',
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
                      '${widget.snapshot['userName']} ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.snapshot["caption"],
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 8.h),
                child: Text(
                  formatDate(widget.snapshot['time'].toDate(), [
                    dd,
                    '-',
                    mm,
                    '-',
                    yyyy,
                  ]),
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
