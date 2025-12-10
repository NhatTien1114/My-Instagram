import 'dart:io';

import 'package:app/data/firebase_service/firestor.dart';
import 'package:app/data/firebase_service/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostReelsScreen extends StatefulWidget {
  File videoFile;

  PostReelsScreen(this.videoFile, {super.key});

  @override
  State<PostReelsScreen> createState() => _PostReelsScreenState();
}

class _PostReelsScreenState extends State<PostReelsScreen> {
  final captionController = TextEditingController();
  late VideoPlayerController videoController;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        videoController.setLooping(true);
        videoController.setVolume(1.0);
        videoController.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text("Reel mới"),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Container(
                      height: 420.h,
                      width: 270.w,
                      child: videoController.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: videoController.value.aspectRatio,
                              child: VideoPlayer(videoController),
                            )
                          : const CircularProgressIndicator(),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 65.h,
                      width: 280.w,
                      child: TextField(
                        maxLines: 10,
                        controller: captionController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Nhập nội dung ... ",
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 45.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            "Lưu video",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            setState(() {
                              isLoading = true;
                            });
                            String ReelsURL = await StorageMethod().uploadImageToStorage("Reel", widget.videoFile);
                            await Firebase_Firestor().CreateReels(video: ReelsURL, caption: captionController.text);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 45.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              "Chia sẽ",
                              style: TextStyle(fontSize: 16.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
