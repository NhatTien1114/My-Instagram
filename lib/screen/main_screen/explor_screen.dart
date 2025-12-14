import 'package:app/screen/main_screen/post_screen.dart';
import 'package:app/screen/main_screen/profile_screen.dart';
import 'package:app/util/image_cached.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final find = TextEditingController();
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SearchBox(),
            if (show)
              StreamBuilder<QuerySnapshot>(
                stream: _firebaseFirestore.collection("posts").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final snap = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostScreen(snap.data()),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey),
                          child: CachedImage(snap['postImage']),
                        ),
                      );
                    }, childCount: snapshot.data!.docs.length),
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 3,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      pattern: const [
                        QuiltedGridTile(2, 1),
                        QuiltedGridTile(2, 2),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                      ],
                    ),
                  );
                },
              ),
            if (!show)
              StreamBuilder(
                  stream: _firebaseFirestore
                      .collection('users')
                      .where('userName', isGreaterThanOrEqualTo: find.text)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return SliverPadding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final snap = snapshot.data!.docs[index];
                            return Column(
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(Uid: snap.id,)));
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 23.r,
                                        backgroundImage: NetworkImage(snap['profile']),
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(snap['userName']),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                          childCount: snapshot.data!.docs.length,
                        ),
                      ),
                    );
                  })
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter SearchBox() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Container(
          height: 36.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        if (value.length > 0)
                          show = false;
                        else
                          show = true;
                      });
                    },
                    controller: find,
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
