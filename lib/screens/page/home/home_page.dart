import 'dart:ui';
import 'dart:io';
import 'package:cap/screens/write_post/write_page/WritePostScreen.dart';
import 'package:flutter/material.dart';
import '../../card/VerticalStudyCard.dart';
import '../profile/ProfileTab.dart';
import 'package:cap/utils/slide_route.dart';
import 'package:cap/utils/BuildBottomNavItem.dart';
import 'home_content.dart';
import '../team/team_page.dart';
import '../study/study_page.dart';
import '../contest/contest_page.dart';
import '../../chat/chat_list_screen.dart';
import 'package:cap/models/study_model.dart';
import 'package:cap/services/api_service.dart';

class AppGlobal {
  static List<Map<String, String>> activityLog = [];
  static ValueNotifier<bool> hasNewNotification = ValueNotifier(false);
}

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _StudyMatchingScreenState();
}

class _StudyMatchingScreenState extends State<home_page> {
  final Color mintColor = const Color(0xFFBCE0D8);
  final Color activeBlueColor = const Color(0xFF80E2FF);
  int _selectedIndex = 0;
  bool _isNotificationOpen = false;
  int _totalExp = 0;

  final ApiService _apiService = ApiService();
  bool _isLoading = true;

  List<StudyModel> teamList = [];
  List<StudyModel> studyList = [];
  List<StudyModel> contestList = [];
  List<StudyModel> _appliedProjects = [];

  List<StudyModel> myActivities = []; // 0개 버그 수정

  List<Map<String, dynamic>> _chatRooms = [];
  File? _userProfileImage;

  bool _isSearchActive = false;
  bool _isCardsVisible = false;
  bool _isSearchFilterOpen = false;
  String _searchQuery = "";
  List<String> _selectedSearchFilters = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final teams = await _apiService.fetchStudies("팀플");
    final studies = await _apiService.fetchStudies("스터디");
    final contests = await _apiService.fetchStudies("공모전");
    if (mounted) {
      setState(() {
        teamList = teams; studyList = studies; contestList = contests;
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _modelToMap(StudyModel model) {
    // 💡 꽉 찼으면 상태를 모집마감으로 자동 변경
    String displayStatus = model.status;
    if (model.currentMembers >= model.maxMembers) {
      displayStatus = "모집마감";
    }

    return {
      "id": model.id,
      "title": model.title, "category": model.category, "desc": model.desc,
      "status": displayStatus, "members": "${model.currentMembers}/${model.maxMembers}명",
      "duration": model.duration, "isMine": false,
      "roles": model.roles,
      "grade": model.grade,
      "projectType": model.projectType,
    };
  }

  void _updateProfileImage(File? newImage) => setState(() => _userProfileImage = newImage);

  String _getTierName(int exp) {
    if (exp >= 1000) return "다이아몬드"; if (exp >= 600) return "플래티넘";
    if (exp >= 300) return "골드"; if (exp >= 100) return "실버"; return "브론즈";
  }

  void _handleApply(String title, String category) {
    setState(() {
      // 지원할 때 해당 스터디의 현재 인원을 1명 늘립니다.
      for (int i = 0; i < teamList.length; i++) {
        if (teamList[i].title == title) {
          final p = teamList[i];
          if (p.currentMembers < p.maxMembers) {
            teamList[i] = StudyModel(
              id: p.id, title: p.title, category: p.category, desc: p.desc, status: p.status,
              maxMembers: p.maxMembers, currentMembers: p.currentMembers + 1, duration: p.duration,
              meetingSchedule: p.meetingSchedule, startDate: p.startDate, endDate: p.endDate,
              grade: p.grade, projectType: p.projectType, roles: p.roles,
            );
          }
        }
      }
      for (int i = 0; i < studyList.length; i++) {
        if (studyList[i].title == title) {
          final p = studyList[i];
          if (p.currentMembers < p.maxMembers) {
            studyList[i] = StudyModel(
              id: p.id, title: p.title, category: p.category, desc: p.desc, status: p.status,
              maxMembers: p.maxMembers, currentMembers: p.currentMembers + 1, duration: p.duration,
              meetingSchedule: p.meetingSchedule, startDate: p.startDate, endDate: p.endDate,
              grade: p.grade, projectType: p.projectType, roles: p.roles,
            );
          }
        }
      }
      for (int i = 0; i < contestList.length; i++) {
        if (contestList[i].title == title) {
          final p = contestList[i];
          if (p.currentMembers < p.maxMembers) {
            contestList[i] = StudyModel(
              id: p.id, title: p.title, category: p.category, desc: p.desc, status: p.status,
              maxMembers: p.maxMembers, currentMembers: p.currentMembers + 1, duration: p.duration,
              meetingSchedule: p.meetingSchedule, startDate: p.startDate, endDate: p.endDate,
              grade: p.grade, projectType: p.projectType, roles: p.roles,
            );
          }
        }
      }

      var project = allData.firstWhere((item) => item.title == title);
      if (!_appliedProjects.contains(project)) {
        _appliedProjects.add(project);
        bool roomExists = _chatRooms.any((room) => room['title'] == title);
        if (!roomExists) _chatRooms.insert(0, {"title": title, "category": category, "members": "${project.currentMembers}/${project.maxMembers}명", "messages": <Map<String, dynamic>>[]});
      }
      AppGlobal.hasNewNotification.value = true;
      AppGlobal.activityLog.insert(0, {"title": title, "subtitle": "$category 지원을 완료했습니다.", "icon": "apply"});
    });
  }

  void _deleteMyProject(Map<String, dynamic> projectMap) => setState(() {
    teamList.removeWhere((item) => item.title == projectMap['title']);
    studyList.removeWhere((item) => item.title == projectMap['title']);
    contestList.removeWhere((item) => item.title == projectMap['title']);
    myActivities.removeWhere((item) => item.title == projectMap['title']);
  });

  void _cancelApplication(Map<String, dynamic> projectMap) => setState(() => _appliedProjects.removeWhere((item) => item.title == projectMap['title']));

  List<StudyModel> get allData => [...teamList, ...studyList, ...contestList];

  List<StudyModel> get filteredSearchData {
    return allData.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) || item.desc.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedSearchFilters.isEmpty || _selectedSearchFilters.contains(item.category);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _onItemTapped(int index) {
    if (_isSearchActive) _closeSearch();
    setState(() { _selectedIndex = index; _isNotificationOpen = false; });
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0: return HomeContent(
          teamList: teamList.map(_modelToMap).toList(),
          studyList: studyList.map(_modelToMap).toList(),
          contestList: contestList.map(_modelToMap).toList(),
          myCreatedProjects: myActivities.map(_modelToMap).toList(),
          appliedProjects: _appliedProjects.map(_modelToMap).toList(),
          onDeleteProject: _deleteMyProject,
          onCancelApply: _cancelApplication,
          onApply: _handleApply
      );
      case 1: return TeamPage(teamData: teamList.map(_modelToMap).toList(), onApply: _handleApply);
      case 2: return StudyPage(studyData: studyList.map(_modelToMap).toList(), onApply: _handleApply);
      case 3: return ContestPage(contestData: contestList.map(_modelToMap).toList(), onApply: _handleApply);
      default: return Container();
    }
  }

  void _openSearch() {
    setState(() {
      _isSearchActive = true;
      _isNotificationOpen = false;
      _selectedSearchFilters.clear();
      if (_selectedIndex == 1) {
        _selectedSearchFilters.add("팀플");
      } else if (_selectedIndex == 2) {
        _selectedSearchFilters.add("스터디");
      } else if (_selectedIndex == 3) {
        _selectedSearchFilters.add("공모전");
      }
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _isSearchActive) { setState(() => _isCardsVisible = true); _searchFocusNode.requestFocus(); }
    });
  }

  void _closeSearch() {
    setState(() { _isCardsVisible = false; _searchFocusNode.unfocus(); });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() { _isSearchActive = false; _isSearchFilterOpen = false; });
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            _searchController.clear();
            _searchQuery = "";
            _selectedSearchFilters.clear();
          }
        });
      }
    });
  }

  void _handleBackgroundTap() { _isSearchFilterOpen ? setState(() => _isSearchFilterOpen = false) : _searchFocusNode.unfocus(); }

  @override
  Widget build(BuildContext context) {
    const Color backgroundGrey = Color(0xFFF5F6F8);

    return Scaffold(
      backgroundColor: backgroundGrey,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 3, offset: const Offset(0, 1))]
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutQuart,
                    width: _isSearchActive ? 0.0 : 44.0,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    clipBehavior: Clip.hardEdge,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        width: 44,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const home_page()), (route) => false),
                            child: const CircleAvatar(radius: 14, backgroundColor: Colors.transparent, backgroundImage: AssetImage("assets/Logo_MeChuri.png")),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          height: 40, width: constraints.maxWidth,
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutQuart,
                                  left: _isSearchActive ? 0 : constraints.maxWidth - 40,
                                  top: 0, bottom: 0,
                                  child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 200), opacity: _isSearchActive ? 1.0 : 0.0,
                                      child: IgnorePointer(ignoring: !_isSearchActive, child: _buildCleanFilterChipButton())
                                  )
                              ),
                              AnimatedPositioned(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutQuart,
                                  left: _isSearchActive ? 55 : constraints.maxWidth - 40,
                                  right: 0, top: 0, bottom: 0,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: _isSearchActive ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 3, offset: const Offset(0, 1))] : null
                                      )
                                  )
                              ),
                              AnimatedPositioned(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutQuart,
                                  left: _isSearchActive ? 55 : constraints.maxWidth - 40,
                                  top: 0, bottom: 0,
                                  child: GestureDetector(
                                      onTap: _isSearchActive ? null : _openSearch,
                                      child: Container(width: 40, alignment: Alignment.center, child: Icon(Icons.search, color: _isSearchActive ? Colors.grey.shade400 : Colors.black, size: 28))
                                  )
                              ),
                              if (_isSearchActive)
                                Positioned(
                                    left: 100,
                                    right: 40,
                                    top: 8, bottom: 0,
                                    child: AnimatedOpacity(
                                        duration: const Duration(milliseconds: 300), opacity: _isCardsVisible ? 1.0 : 0.0,
                                        child: TextField(
                                            controller: _searchController, focusNode: _searchFocusNode, textAlignVertical: TextAlignVertical.center, onChanged: (value) => setState(() => _searchQuery = value),
                                            style: const TextStyle(fontSize: 14, height: 1.0), decoration: InputDecoration(hintText: "스터디를 검색하세요.", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14), border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true)
                                        )
                                    )
                                ),
                              if (_isSearchActive)
                                Positioned(
                                    right: 5, top: 0, bottom: 0,
                                    child: AnimatedOpacity(
                                        duration: const Duration(milliseconds: 300), opacity: _isCardsVisible ? 1.0 : 0.0,
                                        child: GestureDetector(onTap: _closeSearch, child: Container(width: 30, alignment: Alignment.center, child: const Icon(Icons.close, color: Colors.black87, size: 18)))
                                    )
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutQuart,
                    width: _isSearchActive ? 0.0 : 105.0,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        width: 105.0,
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            GestureDetector(
                                onTap: () => setState(() { _isNotificationOpen = !_isNotificationOpen; if (_isNotificationOpen) AppGlobal.hasNewNotification.value = false; }),
                                child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0), child: Icon(Icons.notifications_outlined, color: Colors.black, size: 28)),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: AppGlobal.hasNewNotification,
                                        builder: (context, hasNew, child) {
                                          if (hasNew) return Positioned(top: 8, right: 5, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)));
                                          return const SizedBox.shrink();
                                        },
                                      )
                                    ]
                                )
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileTab(totalExp: _totalExp, userProfileImage: _userProfileImage, onProfileImageUpdated: _updateProfileImage))),
                                child: Stack(alignment: Alignment.bottomRight, children: [
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: CircleAvatar(radius: 16, backgroundColor: Colors.grey, backgroundImage: _userProfileImage != null ? FileImage(_userProfileImage!) : null, child: _userProfileImage == null ? const Icon(Icons.person, size: 20, color: Colors.white) : null)),
                                  Positioned(bottom: 8, right: 0, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))))
                                ])
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFBCE0D8)))
          : Stack(
          children: [
            Positioned.fill(child: _getSelectedPage()),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !_isSearchActive && !_isCardsVisible,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: _isSearchActive ? 1.0 : 0.0), duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuart,
                  builder: (context, value, child) {
                    if (value == 0.0 && !_isSearchActive) return const SizedBox.shrink();
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0 * value, sigmaY: 10.0 * value),
                      child: Container(
                          color: Colors.black.withOpacity(0.65 * value),
                          child: Stack(
                            children: [
                              Positioned.fill(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: _handleBackgroundTap, child: Container(color: Colors.transparent))),
                              Positioned(
                                  top: 15, left: 0, right: 0, bottom: 0,
                                  child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 350), opacity: _isCardsVisible ? 1.0 : 0.0,
                                      child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 350), curve: Curves.easeOutQuart, transform: Matrix4.translationValues(0, _isCardsVisible ? 0 : 30, 0),
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.translucent, onTap: _handleBackgroundTap,
                                            child: filteredSearchData.isEmpty
                                                ? const Center(child: Text("검색 결과가 없습니다.", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)))
                                                : ListView.builder(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), physics: const BouncingScrollPhysics(), itemCount: filteredSearchData.length,
                                              itemBuilder: (context, index) {
                                                final item = filteredSearchData[index];
                                                return VerticalStudyCard(
                                                  id: item.id,
                                                  title: item.title,
                                                  category: item.category,
                                                  desc: item.desc,
                                                  status: item.status,
                                                  members: "${item.currentMembers}/${item.maxMembers}명",
                                                  duration: item.duration,
                                                  roles: item.roles,
                                                  grade: item.grade,
                                                  projectType: item.projectType,
                                                  onApply: _handleApply,
                                                );
                                              },
                                            ),
                                          )
                                      )
                                  )
                              ),
                              if (_isSearchFilterOpen) Positioned(top: 10, left: 20, child: AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: 1.0, child: Container(width: 250, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))]), child: Wrap(spacing: 10, runSpacing: 10, children: [_buildDropdownChip("팀플"), _buildDropdownChip("스터디"), _buildDropdownChip("공모전")])))),
                            ],
                          )
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(bottom: 20, right: 20, child: AnimatedScale(scale: _isSearchActive ? 0.0 : 1.0, duration: const Duration(milliseconds: 300), curve: Curves.easeInBack, child: SizedBox(width: 55, height: 55, child: FloatingActionButton(heroTag: 'chat_btn', onPressed: () => Navigator.push(context, createSlideDownRoute(ChatListScreen(chatRooms: _chatRooms))), backgroundColor: mintColor, elevation: 4, shape: const CircleBorder(), child: const Icon(Icons.chat_bubble, color: Colors.white, size: 28))))),

            if (_isNotificationOpen) Positioned.fill(child: GestureDetector(onTap: () => setState(() => _isNotificationOpen = false), behavior: HitTestBehavior.opaque, child: Container(color: Colors.transparent))),
            if (_isNotificationOpen)
              Positioned(
                top: 10, right: 20,
                child: Container(
                  width: 260, constraints: const BoxConstraints(maxHeight: 350),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.all(15), child: Text("알림", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                      AppGlobal.activityLog.isEmpty
                          ? const Padding(padding: EdgeInsets.all(30), child: Center(child: Text("새로운 알림이 없습니다.", style: TextStyle(color: Colors.grey, fontSize: 13))))
                          : Flexible(
                        child: ListView.builder(
                          shrinkWrap: true, padding: EdgeInsets.zero, itemCount: AppGlobal.activityLog.length,
                          itemBuilder: (context, index) {
                            final item = AppGlobal.activityLog[index];
                            bool isWrite = item['icon'] == 'write';
                            bool isPromotion = item['icon'] == 'promotion';
                            bool isLike = item['icon'] == 'like';

                            IconData iconData = isPromotion ? Icons.stars : (isWrite ? Icons.edit_document : (isLike ? Icons.favorite : Icons.check_circle));
                            Color iconColor = isPromotion ? Colors.orange : (isWrite ? Colors.teal.shade700 : (isLike ? Colors.pinkAccent : Colors.blue.shade600));
                            Color bgColor = isPromotion ? Colors.amber.withOpacity(0.2) : (isWrite ? mintColor.withOpacity(0.3) : (isLike ? Colors.pink.withOpacity(0.1) : Colors.blue.withOpacity(0.15)));

                            return ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), leading: CircleAvatar(backgroundColor: bgColor, child: Icon(iconData, color: iconColor, size: 18)), title: Text(item['title']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis), subtitle: Text(item['subtitle']!, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 2));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _getFAB(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, elevation: 20, shape: const CircularNotchedRectangle(), notchMargin: 8.0,
        child: SizedBox(height: 60, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: BuildBottomNavItem(icon: Icons.home, label: "홈", index: 0, selectedIndex: _selectedIndex, onTap: _onItemTapped)), Expanded(child: BuildBottomNavItem(icon: Icons.groups, label: "팀플", index: 1, selectedIndex: _selectedIndex, onTap: _onItemTapped)), const SizedBox(width: 105), Expanded(child: BuildBottomNavItem(icon: Icons.menu_book, label: "스터디", index: 2, selectedIndex: _selectedIndex, onTap: _onItemTapped)), Expanded(child: BuildBottomNavItem(icon: Icons.emoji_events_outlined, label: "공모전", index: 3, selectedIndex: _selectedIndex, onTap: _onItemTapped))])),
      ),
    );
  }

  Widget _buildCleanFilterChipButton() {
    String currentFilters = _selectedSearchFilters.isEmpty ? "All" : _selectedSearchFilters.join(', ');
    return GestureDetector(
        onTap: () => setState(() { _isSearchFilterOpen = !_isSearchFilterOpen; if (_isSearchFilterOpen) _searchFocusNode.unfocus(); }),
        child: Container(
            width: 50, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 2, offset: const Offset(0, 1))]),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(currentFilters, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  const Icon(Icons.arrow_drop_down, size: 14, color: Colors.grey)
                ]
            )
        )
    );
  }

  Widget _buildDropdownChip(String label) {
    bool isSelected = _selectedSearchFilters.contains(label);
    return GestureDetector(onTap: () => setState(() { if (isSelected) _selectedSearchFilters.remove(label); else _selectedSearchFilters.add(label); }), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: isSelected ? mintColor : Colors.grey.shade100, borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600))));
  }

  Widget _getFAB() {
    return Transform.translate(
      offset: const Offset(0, 20),
      child: SizedBox(
        width: 75, height: 75,
        child: FloatingActionButton(
          heroTag: 'write_btn',
          onPressed: () async {
            String? presetCategory;
            if (_selectedIndex == 1) presetCategory = "팀플"; if (_selectedIndex == 2) presetCategory = "스터디"; if (_selectedIndex == 3) presetCategory = "공모전";
            final newPostMap = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WritePostScreen(
                  initialCategory: presetCategory,
                  existingTitles: allData.map((item) => item.title).toList(),
                ),
              ),
            );

            if (newPostMap != null) {
              setState(() {
                StudyModel newPost = newPostMap as StudyModel;
                _isNotificationOpen = false;
                String oldTier = _getTierName(_totalExp); _totalExp += 10; String newTier = _getTierName(_totalExp);

                if (newPost.category == "팀플") { teamList.insert(0, newPost); _selectedIndex = 1; }
                else if (newPost.category == "스터디") { studyList.insert(0, newPost); _selectedIndex = 2; }
                else if (newPost.category == "공모전") { contestList.insert(0, newPost); _selectedIndex = 3; }

                myActivities.insert(0, newPost);

                AppGlobal.hasNewNotification.value = true;
                if (oldTier != newTier) AppGlobal.activityLog.insert(0, {"title": "티어 승급", "subtitle": "축하합니다! $newTier(으)로 승급하셨습니다.", "icon": "promotion"});
                AppGlobal.activityLog.insert(0, {"title": newPost.title, "subtitle": "게시글 작성 완료 + 10경험치", "icon": "write"});
              });
            }
          },
          backgroundColor: mintColor, elevation: 4, shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 4)),
          child: const Icon(Icons.add, size: 40, color: Colors.white),
        ),
      ),
    );
  }
}