import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  final int currentExp;

  const RankingPage({Key? key, required this.currentExp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color mintColor = const Color(0xFFBCE0D8);

    // 현재 점수에 따른 변수 설정
    int nextGoal = 100;
    String currentTierName = "브론즈";
    String nextTierName = "실버";
    Color tierColor = Colors.brown.shade300;
    String? currentTierImage; // 현재 티어 이미지 경로 저장용

    // 경험치별 티어 결정 로직
    if (currentExp >= 1000) {
      currentTierName = "다이아"; nextTierName = "상위 150위"; nextGoal = 1500; ;currentTierImage = "assets/Diamond.png";
    } else if (currentExp >= 600) {
      currentTierName = "에메랄드"; nextTierName = "다이아"; nextGoal = 1000; currentTierImage = "assets/Emerald.png";
    } else if (currentExp >= 300) {
      currentTierName = "골드"; nextTierName = "에메랄드"; nextGoal = 600; currentTierImage = "assets/Gold.png";
    } else if (currentExp >= 100) {
      currentTierName = "실버"; nextTierName = "골드"; nextGoal = 300; currentTierImage = "assets/Shilver.png";
    } else {
      currentTierName = "브론즈";
      currentTierImage = "assets/Bronze.png";
    }

    final List<Map<String, dynamic>> tierData = [
      {"tier": "멋있는 메추리", "range": "상위 50위", "image": "assets/Cool_Mechuri.png"},
      {"tier": "성체 메추리", "range": "상위 150위", "image": "assets/Adult_Mechuri.png"},
      {"tier": "다이아", "range": "1000 ~ 1500점", "image": "assets/Diamond.png"},
      {"tier": "에메랄드", "range": "600 ~ 999점", "image": "assets/Emerald.png"},
      {"tier": "골드", "range": "300 ~ 599점", "image": "assets/Gold.png"},
      {"tier": "실버", "range": "100 ~ 299점", "image": "assets/Shilver.png"},
      {"tier": "브론즈", "range": "0 ~ 99점", "image": "assets/Bronze.png"},
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("내 랭킹", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]
            ),
            child: Column(
              children: [
                const Text("현재 나의 티어", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 15),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: tierColor.withOpacity(0.1),
                  // 현재 티어 이미지 경로가 있으면 이미지를, 없으면 아이콘을 보여줌
                  child: currentTierImage != null
                      ? Image.asset(currentTierImage, width: 45, height: 45, fit: BoxFit.contain)
                      : Icon(Icons.egg, size: 45, color: tierColor),
                ),
                const SizedBox(height: 15),
                Text(currentTierName, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: tierColor)),
                const SizedBox(height: 10),
                Text("누적 경험치 : $currentExp점", style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: currentExp / nextGoal,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(mintColor),
                  ),
                ),
                const SizedBox(height: 10),
                Text("$nextTierName까지 ${nextGoal - currentExp}점 남았습니다!", style: TextStyle(fontSize: 13, color: Colors.teal.shade700, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 35),
          const Text("티어 기준 안내", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tierData.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final tier = tierData[index];
                bool isMyTier = tier['tier'] == currentTierName;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  // 리스트 데이터에 image 키가 존재하면 이미지를, 아니면 아이콘을 보여줌
                  leading: tier.containsKey('image')
                      ? Image.asset(tier['image'], width: 30, height: 30, fit: BoxFit.contain)
                      : Icon(Icons.egg_alt, color: tier['color'], size: 30),
                  title: Text(tier['tier'], style: TextStyle(fontWeight: isMyTier ? FontWeight.w900 : FontWeight.bold, fontSize: 15, color: isMyTier ? Colors.black : Colors.black87)),
                  trailing: Text(tier['range'], style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 13)),
                  tileColor: isMyTier ? mintColor.withOpacity(0.15) : Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}