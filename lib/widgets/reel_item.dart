import 'package:app/util/image_cached.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'Comment.dart';

class ReelItem extends StatefulWidget {
  final snapshot;

  ReelItem(this.snapshot, {super.key});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController _controller;
  bool isPlay = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.snapshot['reelsvideo']),
    )..initialize().then((_) {
        if (mounted) {
          setState(() {
            _controller.setLooping(true);
            _controller.setVolume(1);
            _controller.play();
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isPlay = !isPlay;
            });
            if (isPlay) {
              _controller.play();
            } else {
              _controller.pause();
            }
          },
          child: Container(
            height: 812.h,
            width: double.infinity,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        if (!isPlay)
          Center(
            child: CircleAvatar(
              radius: 35.r,
              backgroundColor: Colors.white24,
              child: Icon(Icons.play_arrow, size: 35.sp, color: Colors.white),
            ),
          ),
        Positioned(
          top: 450.h,
          right: 15.w,
          child: Column(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 28.w,
                    color: Colors.white,
                  ),
                  Text(
                    "0",
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                      onTap: () {
                        showBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: DraggableScrollableSheet(
                                maxChildSize: 0.6,
                                initialChildSize: 0.6,
                                minChildSize: 0.2,
                                builder: (context, scrollController) {
                                  return Comment("reels", widget.snapshot['postId']);
                                },
                              ),
                            );
                          },
                        );
                      },
                      child:
                          Icon(Icons.comment, size: 28.w, color: Colors.white)),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('reels')
                        .doc(widget.snapshot['postId'])
                        .collection('comments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          '0',
                          style: TextStyle(fontSize: 12.sp, color: Colors.white),
                        );
                      }
                      return Text(
                        snapshot.data?.docs.length.toString() ?? '0',
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      );
                    },
                  ),
                  SizedBox(height: 15.h),
                  Icon(Icons.send, size: 28.w, color: Colors.white),
                  Text(
                    "0",
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 40.h,
          left: 10.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                      height: 40.h,
                      width: 40.w,
                      child: CachedImage(widget.snapshot['profileImage']),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    widget.snapshot['userName'],
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 25.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Text(
                      "Follow",
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                widget.snapshot['caption'],
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
