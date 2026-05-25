import 'package:flutter/material.dart';

//맨 아래 6가지 버튼 기능
class BuildBottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const BuildBottomNavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color mintColor = const Color(0xFFBCE0D8);

    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index), // 탭 하면 받아온 함수를 실행, 부모한테 알림
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              icon,
              color: isSelected ? mintColor : Colors.grey.shade400,
              size: 26
          ),
          const SizedBox(height: 4),
          Text(
              label,
              style: TextStyle(
                  color: isSelected ? mintColor : Colors.grey.shade400,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
              )
          ),
        ],
      ),
    );
  }
}