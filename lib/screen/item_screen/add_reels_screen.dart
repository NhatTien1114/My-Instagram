import 'dart:io';

import 'package:app/screen/item_screen/add_post_reels_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AddReelsScreen extends StatefulWidget {
  const AddReelsScreen({super.key});

  @override
  State<AddReelsScreen> createState() => _AddReelsScreenState();
}

class _AddReelsScreenState extends State<AddReelsScreen> {
  final List<AssetEntity> _mediaList = [];
  int currentPage = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _fetchNewMedia() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth || ps.hasAccess) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
      );

      if (albums.isNotEmpty) {
        List<AssetEntity> media = await albums[0].getAssetListPaged(
          page: currentPage,
          size: 60,
        );

        // Thêm bộ lọc để chắc chắn chỉ lấy các tệp video
        final videoOnlyMedia = media.where((asset) => asset.type == AssetType.video).toList();

        setState(() {
          _mediaList.addAll(videoOnlyMedia);
          currentPage++;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } else {
      PhotoManager.openSetting();
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text("Reels mới", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scroll) {
            if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent &&
                !isLoading) {
              _fetchNewMedia();
            }
            return true;
          },
          child: GridView.builder(
            itemCount: _mediaList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 250,
              crossAxisSpacing: 3,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final asset = _mediaList[index];
              final int durationInSeconds = asset.duration;
              final int minutes = durationInSeconds ~/ 60;
              final int seconds = durationInSeconds % 60;
              final String formattedDuration =
                  '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';

              return GestureDetector(
                onTap: () async {
                  File? videoFile = await asset.file;
                  if (videoFile != null && mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostReelsScreen(videoFile),
                      ),
                    );
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AssetEntityImage(
                      asset,
                      isOriginal: false,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Text(
                        formattedDuration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 1.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(150, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
