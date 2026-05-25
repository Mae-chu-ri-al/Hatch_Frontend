import 'package:flutter/material.dart';

//상단 필터 디자인 , 탐플,공모전,스터디
class BulidFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const BulidFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color mintColor = const Color(0xFFBCE0D8);

    // 원래 있던 UI 코드 반환
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? mintColor : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
        boxShadow: isSelected
            ? [BoxShadow(color: mintColor.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 3))]
            : [],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
    );
  }
}