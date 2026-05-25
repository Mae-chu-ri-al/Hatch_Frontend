import 'package:flutter/material.dart';

class MyActivityListScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> projects;
  final String buttonText;
  final Function(Map<String, dynamic>) onAction;

  const MyActivityListScreen({
    Key? key,
    required this.title,
    required this.projects,
    required this.buttonText,
    required this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF6),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFFCFCF6),
        foregroundColor: Colors.black,
      ),
      body: projects.isEmpty
          ? Center(child: Text("내역이 없습니다.", style: TextStyle(color: Colors.grey.shade500, fontSize: 16)))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final item = projects[index];

          // 💡 모집마감 상태면 배경 빨갛게 변경
          bool isClosed = item['status'] == '모집마감' || item['status'] == '마감';
          Color statusBgColor = isClosed ? Colors.red.shade50 : Colors.greenAccent.shade100;
          Color statusTextColor = isClosed ? Colors.redAccent : Colors.green;

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF80E2FF), borderRadius: BorderRadius.circular(12)),
                        child: Text(item['category'], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)),
                        child: Text(item['status'], style: TextStyle(color: statusTextColor, fontSize: 11, fontWeight: FontWeight.bold))
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(item['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Text(item['desc'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 15),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: [
                          Icon(Icons.person_outline, size: 16, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(item['members'], style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                        ]
                    ),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          onAction(item);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 10), Text("$buttonText 완료", style: const TextStyle(fontWeight: FontWeight.bold))]),
                                  backgroundColor: Colors.teal.shade400, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), duration: const Duration(seconds: 2)
                              )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: buttonText == "삭제하기" ? Colors.red.shade400 : Colors.grey.shade500,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: Text(buttonText, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}