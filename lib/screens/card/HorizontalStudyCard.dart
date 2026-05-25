import 'package:flutter/material.dart';
import 'package:cap/screens/write_post/write_page/ApplyTeamDialog.dart';
import 'package:cap/screens/card/VerticalStudyCard.dart';
import 'package:cap/screens/page/home/home_page.dart';

class HorizontalStudyCard extends StatelessWidget {
  final String title;
  final String category;
  final String status;
  final String members;
  final String duration;
  final String desc; // 💡 찜 리스트 저장을 위해 내용 추가
  final Color imageColor;
  final IconData icon;
  final Function(String, String)? onApply;

  const HorizontalStudyCard({
    Key? key,
    required this.title,
    required this.category,
    required this.status,
    required this.members,
    required this.duration,
    required this.desc, // 💡 추가됨
    required this.imageColor,
    required this.icon,
    this.onApply,
  }) : super(key: key);

  void _toggleLike() {
    bool currentlyLiked = VerticalStudyCard.likedPosts.any((post) => post['title'] == title);

    if (!currentlyLiked) {
      VerticalStudyCard.likedPosts.add({
        'title': title, 'category': category, 'desc': desc,
        'status': status, 'members': members, 'duration': duration,
      });

      AppGlobal.activityLog.insert(0, {
        "title": "찜하기",
        "subtitle": "'$title'을(를) 찜했습니다.",
        "icon": "like"
      });
      AppGlobal.hasNewNotification.value = true;
    } else {
      VerticalStudyCard.likedPosts.removeWhere((post) => post['title'] == title);
    }

    // 💡 전역 찜 상태 업데이트 알림!
    VerticalStudyCard.likeUpdateNotifier.value++;
  }

  @override
  Widget build(BuildContext context) {
    final Color mintColor = const Color(0xFFBCE0D8);
    final Color activeBlueColor = const Color(0xFF80E2FF);

    bool isClosed = status == '모집마감' || status == '마감';
    Color statusBgColor = isClosed ? Colors.red.shade50 : Colors.greenAccent.shade100;
    Color statusTextColor = isClosed ? Colors.redAccent : Colors.green;

    return Container(
      width: 250,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 8))]
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(height: 160, width: double.infinity, color: imageColor, child: Center(child: Icon(icon, size: 80, color: Colors.white70)))
              ),
              Positioned(
                  top: 12, left: 12,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(6)),
                      child: Text(status, style: TextStyle(color: statusTextColor, fontSize: 11, fontWeight: FontWeight.bold))
                  )
              ),
              Positioned(
                  top: 12, right: 12,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: activeBlueColor, borderRadius: BorderRadius.circular(6)),
                      child: Text(category, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))
                  )
              ),
              // 💡 우측 하단 찜하기 버튼 (동그란 흰색 배경)
              Positioned(
                  bottom: 12, right: 12,
                  child: ValueListenableBuilder<int>(
                      valueListenable: VerticalStudyCard.likeUpdateNotifier,
                      builder: (context, value, child) {
                        bool isLiked = VerticalStudyCard.likedPosts.any((post) => post['title'] == title);
                        return GestureDetector(
                            onTap: _toggleLike,
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
                                child: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.pinkAccent.shade200 : Colors.grey.shade400, size: 20)
                            )
                        );
                      }
                  )
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600), const SizedBox(width: 4),
                      Text(members, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 15),
                      Icon(Icons.access_time, size: 16, color: Colors.grey.shade600), const SizedBox(width: 4),
                      Expanded(child: Text(duration, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis))
                    ]
                ),
                const SizedBox(height: 15),
                SizedBox(
                    width: double.infinity, height: 40,
                    child: ElevatedButton(
                        onPressed: isClosed ? null : () {
                          showDialog(
                              context: context,
                              builder: (context) => ApplyTeamDialog(onApplyDone: onApply, title: title, category: category)
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: isClosed ? Colors.grey.shade300 : mintColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        child: Text(isClosed ? "마감됨" : "살펴보기", style: TextStyle(color: isClosed ? Colors.grey.shade500 : Colors.white, fontWeight: FontWeight.bold, fontSize: 15))
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}