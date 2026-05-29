import 'package:flutter/material.dart';
import 'package:cap/utils/BulidFilterChip.dart';
import 'package:cap/screens/card/HorizontalStudyCard.dart';
import 'package:cap/screens/page/widget/bulidSummaryBox.dart';
import 'MyActivityListScreen.dart';

class HomeContent extends StatefulWidget {
  final List<Map<String, dynamic>> teamList;
  final List<Map<String, dynamic>> studyList;
  final List<Map<String, dynamic>> contestList;
  final List<Map<String, dynamic>> myCreatedProjects;
  final List<Map<String, dynamic>> appliedProjects;
  final Function(Map<String, dynamic>) onDeleteProject;
  final Function(Map<String, dynamic>) onCancelApply;
  final Function(String, String)? onApply;

  const HomeContent({
    Key? key,
    required this.teamList,
    required this.studyList,
    required this.contestList,
    required this.myCreatedProjects,
    required this.appliedProjects,
    required this.onDeleteProject,
    required this.onCancelApply,
    this.onApply,
  }) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _selectedFilter = "팀플";

  IconData _getEmptyIcon(String filter) {
    if (filter == "팀플") return Icons.people_outline;
    if (filter == "스터디") return Icons.menu_book;
    if (filter == "공모전") return Icons.emoji_events_outlined;
    return Icons.inbox;
  }

  @override
  Widget build(BuildContext context) {
    final Color mintLightColor = const Color(0xFFE2F3F0);
    final Color pinkLightColor = const Color(0xFFFFEBF0);

    List<Map<String, dynamic>> displayList = [];
    if (_selectedFilter == "팀플") displayList = widget.teamList;
    else if (_selectedFilter == "스터디") displayList = widget.studyList;
    else if (_selectedFilter == "공모전") displayList = widget.contestList;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(onTap: () => setState(() => _selectedFilter = "팀플"), child: BulidFilterChip(label: "팀플", isSelected: _selectedFilter == "팀플")),
                  const SizedBox(width: 10),
                  GestureDetector(onTap: () => setState(() => _selectedFilter = "스터디"), child: BulidFilterChip(label: "스터디", isSelected: _selectedFilter == "스터디")),
                  const SizedBox(width: 10),
                  GestureDetector(onTap: () => setState(() => _selectedFilter = "공모전"), child: BulidFilterChip(label: "공모전", isSelected: _selectedFilter == "공모전")),
                ],
              ),
              const SizedBox(height: 35),
              Text("떠오르는 인기 $_selectedFilter", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),

              SizedBox(
                height: 450,
                child: displayList.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_getEmptyIcon(_selectedFilter), size: 80, color: const Color(0xFFBCE0D8)),
                      const SizedBox(height: 20),
                      Text("등록된 $_selectedFilter 글이 없습니다.", style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
                  physics: const BouncingScrollPhysics(),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final item = displayList[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: HorizontalStudyCard(
                        id: item['id']?.toString(),
                        title: item['title'].toString(),
                        category: item['category'].toString(),
                        desc: item['desc'].toString(), // 💡 찜 리스트 저장을 위해 파라미터 추가!
                        status: item['status'].toString(),
                        members: item['members'].toString(),
                        duration: item['duration'].toString(),
                        imageColor: Colors.blueAccent.shade100,
                        icon: Icons.design_services,
                        roles: item['roles'] != null ? List<Map<String, dynamic>>.from(item['roles'] as List) : null,
                        grade: item['grade'] as int?,
                        projectType: item['projectType']?.toString(),
                        onApply: widget.onApply,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MyActivityListScreen(
                              title: "내가 만든 프로젝트",
                              projects: widget.myCreatedProjects,
                              buttonText: "삭제하기",
                              onAction: widget.onDeleteProject,
                            )
                        )),
                        child: buildSummaryBox("내가 만든 프로젝트", "${widget.myCreatedProjects.length}개", mintLightColor),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MyActivityListScreen(
                              title: "신청 대기 중인 프로젝트",
                              projects: widget.appliedProjects,
                              buttonText: "신청 취소",
                              onAction: widget.onCancelApply,
                            )
                        )),
                        child: buildSummaryBox("신청 대기 중인 프로젝트", "${widget.appliedProjects.length}개", pinkLightColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ],
    );
  }
}