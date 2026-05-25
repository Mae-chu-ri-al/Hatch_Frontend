import 'package:flutter/material.dart';
import 'package:cap/screens/write_post/write_page/ApplyTeamDialog.dart';
import 'package:cap/screens/page/home/home_page.dart';

class VerticalStudyCard extends StatefulWidget {
  final String title;
  final String category;
  final String desc;
  final String status;
  final String members;
  final String duration;
  final Function(String, String)? onApply;

  static List<Map<String, dynamic>> likedPosts = [];
  // 💡 앱 전체에 찜 변화를 알리는 방송국(Notifier) 역할!
  static ValueNotifier<int> likeUpdateNotifier = ValueNotifier(0);

  const VerticalStudyCard({
    Key? key,
    required this.title,
    required this.category,
    required this.desc,
    required this.status,
    required this.members,
    required this.duration,
    this.onApply,
  }) : super(key: key);

  @override
  State<VerticalStudyCard> createState() => _VerticalStudyCardState();
}

class _VerticalStudyCardState extends State<VerticalStudyCard> {
  void _toggleLike() {
    bool currentlyLiked = VerticalStudyCard.likedPosts.any((post) => post['title'] == widget.title);

    if (!currentlyLiked) {
      VerticalStudyCard.likedPosts.add({
        'title': widget.title, 'category': widget.category, 'desc': widget.desc,
        'status': widget.status, 'members': widget.members, 'duration': widget.duration,
      });

      AppGlobal.activityLog.insert(0, {
        "title": "찜하기",
        "subtitle": "'${widget.title}'을(를) 찜했습니다.",
        "icon": "like"
      });
      AppGlobal.hasNewNotification.value = true;
    } else {
      VerticalStudyCard.likedPosts.removeWhere((post) => post['title'] == widget.title);
    }

    // 💡 찜을 누를 때마다 전역에 업데이트 신호를 보냄
    VerticalStudyCard.likeUpdateNotifier.value++;
  }

  @override
  Widget build(BuildContext context) {
    final Color mintColor = const Color(0xFFBCE0D8);
    final Color activeBlueColor = const Color(0xFF80E2FF);

    bool isClosed = widget.status == '모집마감' || widget.status == '마감';
    Color statusBgColor = isClosed ? Colors.red.shade50 : Colors.greenAccent.shade100;
    Color statusTextColor = isClosed ? Colors.redAccent : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 20), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 💡 찜 상태 신호를 듣고 스스로 새로고침하는 똑똑한 하트 아이콘
              ValueListenableBuilder<int>(
                  valueListenable: VerticalStudyCard.likeUpdateNotifier,
                  builder: (context, value, child) {
                    bool isLiked = VerticalStudyCard.likedPosts.any((post) => post['title'] == widget.title);
                    return GestureDetector(
                      onTap: _toggleLike,
                      child: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.pinkAccent.shade200 : Colors.grey.shade400, size: 24),
                    );
                  }
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 10),
              Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4), decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)), child: Text(widget.status, style: TextStyle(color: statusTextColor, fontSize: 11, fontWeight: FontWeight.bold))),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: activeBlueColor, borderRadius: BorderRadius.circular(12)), child: Text(widget.category, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 12),
          Text(widget.desc, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 20), const Divider(height: 1, thickness: 1), const SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.person_outline, size: 18, color: Colors.grey.shade500), const SizedBox(width: 5), Text(widget.members, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)), const SizedBox(width: 15),
              Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade500), const SizedBox(width: 5), Text(widget.duration, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              const Spacer(),
              GestureDetector(
                  onTap: isClosed ? null : () => showDialog(context: context, builder: (context) => ApplyTeamDialog(onApplyDone: widget.onApply, title: widget.title, category: widget.category)),
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: isClosed ? Colors.grey.shade200 : mintColor.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
                      child: Text(isClosed ? "마감됨" : "자세히 보기", style: TextStyle(color: isClosed ? Colors.grey.shade500 : Colors.teal.shade700, fontWeight: FontWeight.bold, fontSize: 12))
                  )
              ),
            ],
          )
        ],
      ),
    );
  }
}