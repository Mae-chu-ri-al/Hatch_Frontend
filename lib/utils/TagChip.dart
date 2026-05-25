import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  // 1. 외부에서 전달받을 변수 선언
  final String label;
  final Color color;
  // 2. 생성자
  const TagChip({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  // 3. UI를 그리는 메서드
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)
            ),
            const SizedBox(width: 4),
            const Icon(Icons.close, size: 12, color: Colors.white)
          ]
      ),
    );
  }
}