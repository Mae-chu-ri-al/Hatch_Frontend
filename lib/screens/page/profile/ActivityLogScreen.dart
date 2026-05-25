import 'package:flutter/material.dart';
// 💡 알림(활동 이력) 전역 저장소를 불러옵니다.
import 'package:cap/screens/page/home/home_page.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color mintColor = const Color(0xFFBCE0D8);

    // 💡 더미 데이터 대신 전역으로 쌓인 실제 활동 데이터를 가져옴
    final List<Map<String, String>> activityData = AppGlobal.activityLog;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("내 활동 이력", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: activityData.isEmpty
          ? Center(child: Text("아직 활동 이력이 없습니다.", style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.bold)))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        itemCount: activityData.length,
        itemBuilder: (context, index) {
          final item = activityData[index];
          bool isWrite = item['icon'] == 'write';
          bool isPromotion = item['icon'] == 'promotion';
          bool isLike = item['icon'] == 'like'; // 찜하기 아이콘

          IconData iconData = isPromotion ? Icons.stars : (isWrite ? Icons.edit_document : (isLike ? Icons.favorite : Icons.check_circle));
          Color iconColor = isPromotion ? Colors.orange : (isWrite ? Colors.teal.shade700 : (isLike ? Colors.pinkAccent : Colors.blue.shade600));
          Color bgColor = isPromotion ? Colors.amber.withOpacity(0.2) : (isWrite ? mintColor.withOpacity(0.3) : (isLike ? Colors.pink.withOpacity(0.1) : Colors.blue.withOpacity(0.15)));

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
            child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: CircleAvatar(backgroundColor: bgColor, child: Icon(iconData, color: iconColor, size: 22)),
                title: Text(item['title']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: Padding(padding: const EdgeInsets.only(top: 5), child: Text(item['subtitle']!, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)))
            ),
          );
        },
      ),
    );
  }
}