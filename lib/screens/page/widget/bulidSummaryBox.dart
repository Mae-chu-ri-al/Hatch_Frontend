import 'package:flutter/material.dart';

//활동 내용 위젯
Widget buildSummaryBox(String title, String count, Color bgColor) {
  return Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: bgColor.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black87)), const SizedBox(height: 8),
        Text(count, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black87)), const SizedBox(height: 8),
        Text("진행중 n | 완료 n", style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w800)),
      ],
    ),
  );
}