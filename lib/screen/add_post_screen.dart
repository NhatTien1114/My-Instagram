import 'dart:io';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:app/screen/add_post_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final List<AssetEntity> _mediaList = [];
  File? _selectedFile; // File đang được chọn để preview to
  AssetEntity? _selectedEntity; // Asset đang được chọn

  int currentPage = 0;
  bool isLoading = false; // Tránh gọi load nhiều lần

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  // Hàm load ảnh tối ưu
  _fetchNewMedia() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth || ps.hasAccess) {
      // Lấy danh sách album
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isNotEmpty) {
        // Lấy ảnh phân trang
        List<AssetEntity> media = await albums[0].getAssetListPaged(
          page: currentPage,
          size: 60,
        );

        // Load file cho ảnh đầu tiên để hiển thị mặc định (chỉ chạy lần đầu)
        if (_mediaList.isEmpty && media.isNotEmpty) {
          _selectedEntity = media[0];
          _loadFile(media[0]);
        }

        setState(() {
          _mediaList.addAll(media);
          currentPage++;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } else {
      // Xử lý khi không có quyền (mở setting hoặc thông báo)
      PhotoManager.openSetting();
      setState(() => isLoading = false);
    }
  }

  // Hàm riêng để chuyển Asset thành File (chỉ gọi khi cần)
  Future<void> _loadFile(AssetEntity entity) async {
    File? file = await entity.file;
    if (file != null) {
      setState(() {
        _selectedFile = file;
        _selectedEntity = entity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Bài đăng mới",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GestureDetector(
                onTap: () {
                  if (_selectedFile != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddPostTextScreen(_selectedFile!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn ảnh')),
                    );
                  }
                },
                child: Text(
                  "Tiếp",
                  style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Phần hiển thị ảnh to (Preview)
            SizedBox(
              height: 375.h,
              width: double.infinity,
              child: _selectedEntity == null
                  ? const Center(child: CircularProgressIndicator()) // Loading hoặc Empty
                  : AssetEntityImage( // Widget tiện ích của photo_manager
                _selectedEntity!,
                isOriginal: false, // Dùng ảnh thumbnail chất lượng cao cho nhanh
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text("Lỗi tải ảnh"));
                },
              ),
            ),

            // Thanh tiêu đề
            Container(
              height: 40.h,
              color: Colors.white,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                "Gần đây",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),

            // Lưới ảnh nhỏ (Grid Gallery)
            Expanded(
              child: NotificationListener<ScrollNotification>(
                // Load thêm ảnh khi cuộn xuống cuối (Infinite Scroll)
                onNotification: (ScrollNotification scroll) {
                  if (!isLoading &&
                      scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
                    _fetchNewMedia();
                  }
                  return true;
                },
                child: GridView.builder(
                  itemCount: _mediaList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemBuilder: (context, index) {
                    final asset = _mediaList[index];
                    return GestureDetector(
                      onTap: () {
                        // Khi bấm vào ảnh nhỏ -> Lấy file và hiển thị lên trên
                        _loadFile(asset);
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: AssetEntityImage(
                              asset,
                              isOriginal: false,
                              thumbnailSize: const ThumbnailSize.square(200), // Chỉ load thumbnail nhỏ
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Hiệu ứng làm mờ nếu ảnh đang được chọn
                          if (asset == _selectedEntity)
                            Container(color: Colors.white.withOpacity(0.5))
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}