import 'package:flutter/material.dart';
import 'package:cap/screens/card/VerticalStudyCard.dart';

class LikedPostsScreen extends StatelessWidget {
  const LikedPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color mintColor = const Color(0xFFBCE0D8);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("내가 찜한 글", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // 💡 찜 상태가 바뀔 때마다 찜 목록 화면 전체가 자동으로 새로고침 되도록 적용!
      body: ValueListenableBuilder<int>(
          valueListenable: VerticalStudyCard.likeUpdateNotifier,
          builder: (context, value, child) {
            // 화면이 다시 그려질 때마다 최신 찜 목록을 가져옵니다.
            List<Map<String, dynamic>> myLikes = VerticalStudyCard.likedPosts;

            if (myLikes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: mintColor),
                    const SizedBox(height: 20),
                    Text("아직 찜한 게시글이 없습니다.", style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              physics: const BouncingScrollPhysics(),
              itemCount: myLikes.length,
              itemBuilder: (context, index) {
                final item = myLikes[index];
                return VerticalStudyCard(
                  id: item['id']?.toString(),
                  title: item['title'].toString(),
                  category: item['category'].toString(),
                  desc: item['desc'].toString(),
                  status: item['status'].toString(),
                  members: item['members'].toString(),
                  duration: item['duration'].toString(),
                  roles: item['roles'] != null ? List<Map<String, dynamic>>.from(item['roles'] as List) : null,
                  grade: item['grade'] as int?,
                  projectType: item['projectType']?.toString(),
                );
              },
            );
          }
      ),
    );
  }
}