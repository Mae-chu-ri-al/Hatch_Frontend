import 'package:flutter/material.dart';
import 'package:cap/screens/card/VerticalStudyCard.dart';
import 'package:cap/utils/slide_route.dart';
import '../../search/SearchScreen.dart';

class ContestPage extends StatelessWidget {
  final List<Map<String, dynamic>> contestData;
  final Function(String, String)? onApply;

  const ContestPage({Key? key, required this.contestData, this.onApply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      physics: const BouncingScrollPhysics(),
      children: [
        GestureDetector(
            onTap: () => Navigator.push(context, createSlideDownRoute(SearchScreen(allData: contestData))),
            child: Container(
                height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade300)),
                child: Row(children: [const SizedBox(width: 15), Icon(Icons.search, color: Colors.grey.shade500), const SizedBox(width: 10), Text("공모전 검색...", style: TextStyle(color: Colors.grey.shade400, fontSize: 15))])
            )
        ),
        const SizedBox(height: 25),

        if (contestData.isEmpty)
          Container(
            height: 350,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events_outlined, size: 80, color: Color(0xFFBCE0D8)),
                const SizedBox(height: 20),
                Text("등록된 공모전 글이 없습니다.", style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        else
          ...contestData.map((study) => VerticalStudyCard(
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