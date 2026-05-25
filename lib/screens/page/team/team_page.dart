import 'package:flutter/material.dart';
import 'package:cap/screens/card/VerticalStudyCard.dart';
import 'package:cap/utils/slide_route.dart';
import '../../search/SearchScreen.dart';

class TeamPage extends StatelessWidget {
  final List<Map<String, dynamic>> teamData;
  final Function(String, String)? onApply;

  const TeamPage({Key? key, required this.teamData, this.onApply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      physics: const BouncingScrollPhysics(),
      children: [
        GestureDetector(
            onTap: () => Navigator.push(context, createSlideDownRoute(SearchScreen(allData: teamData))),
            child: Container(
                height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade300)),
                child: Row(children: [const SizedBox(width: 15), Icon(Icons.search, color: Colors.grey.shade500), const SizedBox(width: 10), Text("팀플 검색...", style: TextStyle(color: Colors.grey.shade400, fontSize: 15))])
            )
        ),
        const SizedBox(height: 25),

        if (teamData.isEmpty)
          Container(
            height: 350,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people_outline, size: 80, color: Color(0xFFBCE0D8)),
                const SizedBox(height: 20),
                Text("등록된 팀플 글이 없습니다.", style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        else
          ...teamData.map((study) => VerticalStudyCard(
            title: study['title'].toString(),
            category: study['category'].toString(),
            desc: study['desc'].toString(),
            status: study['status'].toString(),
            members: study['members'].toString(),
            duration: study['duration'].toString(),
            onApply: onApply,
          )).toList(),

        const SizedBox(height: 100),
      ],
    );
  }
}