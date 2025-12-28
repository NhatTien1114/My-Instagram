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
  DocumentSnapshot? _currentUserData;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    try {
      var userSnap = await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      if (mounted) {
        setState(() {
          _currentUserData = userSnap;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

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
          SliverToBoxAdapter(
            child: Container(
              height: 100.h,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseFirestore
                    .collection("stories")
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Đã có lỗi xảy ra!'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Chỉ hiển thị skeleton cho "Tin của bạn" trong khi chờ
                    return _buildYourStoryItem(isLoading: true);
                  }

                  final stories = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: stories.length + 1, // +1 cho "Tin của bạn"
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Item đầu tiên luôn là "Tin của bạn"
                        return _buildYourStoryItem(isLoading: false);
                      }
                      // Các item khác là story từ Firestore
                      final storyData =
                          stories[index - 1].data() as Map<String, dynamic>;
                      final profileImageUrl = storyData['profile'];
                      final userName = storyData['userName'];

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 32.r,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: NetworkImage(profileImageUrl)
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              userName ?? '',
                              style: TextStyle(fontSize: 12.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          StreamBuilder(
            stream: _firebaseFirestore
                .collection("posts")
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
               if (snapshot.hasError) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('Không thể tải bài viết.')),
                );
              }
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return PostWidget(snapshot.data!.docs[index].data());
                  },
                  childCount: snapshot.data!.docs.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildYourStoryItem({bool isLoading = false}) {
    final data = _currentUserData?.data() as Map<String, dynamic>?;
    final profileImageUrl = data?['profile'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Stack(
            children: [
              // Avatar
              CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.grey[300],
                 backgroundImage: (profileImageUrl != null && profileImageUrl.isNotEmpty)
                    ? NetworkImage(profileImageUrl)
                    : null,
              ),
              // Add button
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Handle add story tap
                    },
                    child: Icon(Icons.add_circle, size: 22.r),
                  ),
                ),
              )
            ], 
          ),
          SizedBox(height: 5.h),
          Text("Tin của bạn", style: TextStyle(fontSize: 12.sp)),
        ],
      ),
    );
  }
}
