import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cap/screens/page/profile/RankingPage.dart';
import 'package:image_picker/image_picker.dart';

import 'LikedPostsScreen.dart';
import 'ActivityLogScreen.dart';

class ProfileTab extends StatefulWidget {
  final int totalExp;
  final File? userProfileImage;
  final Function(File?) onProfileImageUpdated;

  const ProfileTab({
    Key? key,
    required this.totalExp,
    this.userProfileImage,
    required this.onProfileImageUpdated
  }) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final String _userName = "메추리 1호기";
  final String _university = "청주대학교";
  final String _department = "인공지능소프트웨어학과";

  String _introduction = "안녕하세요! 함께 성장할 팀원을 찾습니다.";

  List<String> _availableDays = [];
  String _availableTimeRange = "";

  // 💡 시계 위젯에서 선택한 시간을 저장할 변수 추가
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final List<String> _availableTags = ["IT/개발", "디자인", "기획/아이디어", "마케팅", "어학", "자격증", "공모전", "취업준비", "기타"];
  final List<String> _selectedTags = [];

  final Color mintColor = const Color(0xFFBCE0D8);
  final ImagePicker _picker = ImagePicker();

  File? _currentProfileImage;

  @override
  void initState() {
    super.initState();
    _currentProfileImage = widget.userProfileImage;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File newImage = File(pickedFile.path);
      widget.onProfileImageUpdated(newImage);
      setState(() { _currentProfileImage = newImage; });
    }
  }

  // 💡 시계 모양 타임 피커(Time Picker)를 띄워주는 공통 위젯 함수
  Widget _buildTimePickerBox(BuildContext context, String hint, TimeOfDay? time, Function(TimeOfDay) onPicked) {
    String displayTime = time != null
        ? "${time.period == DayPeriod.am ? '오전' : '오후'} ${time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')}"
        : hint;

    return GestureDetector(
        onTap: () async {
          // 시계 위젯 호출
          TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: time ?? TimeOfDay.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: mintColor, // 시계 헤더 및 선택 색상
                    onPrimary: Colors.black87,
                    onSurface: Colors.black87,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) onPicked(picked);
        },
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(displayTime, style: TextStyle(color: time != null ? Colors.black87 : Colors.grey.shade400, fontSize: 13, fontWeight: time != null ? FontWeight.bold : FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis)),
                Icon(Icons.access_time, color: time != null ? mintColor : Colors.grey.shade400, size: 16)
              ],
            )
        )
    );
  }

  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(text: _userName);
    final TextEditingController univController = TextEditingController(text: _university);
    final TextEditingController deptController = TextEditingController(text: _department);
    final TextEditingController introController = TextEditingController(text: _introduction);

    List<String> tempDays = List.from(_availableDays);
    // 💡 다이얼로그 내부 임시 시간 상태
    TimeOfDay? tempStartTime = _startTime;
    TimeOfDay? tempEndTime = _endTime;

    final List<String> weekDays = ["월", "화", "수", "목", "금", "토", "일"];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: const Color(0xFFF1EDF5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                title: const Padding(padding: EdgeInsets.only(top: 10, left: 5), child: Text("프로필 수정", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87))),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditField("이름", nameController, readOnly: true), const SizedBox(height: 15),
                      _buildEditField("학교", univController, readOnly: true), const SizedBox(height: 15),
                      _buildEditField("학과", deptController, readOnly: true), const SizedBox(height: 25),
                      _buildEditField("내 소개", introController, readOnly: false), const SizedBox(height: 35),

                      const Text("협업 가능 시간 설정", style: TextStyle(color: Color(0xFF7A708A), fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),

                      // 💡 입력 안 했을 때 띄워주는 경고 문구 조건 수정
                      if (tempDays.isEmpty && (tempStartTime == null || tempEndTime == null))
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text("협업 가능한 요일과 시간을 정해주세요.", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),

                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: weekDays.map((day) {
                          bool isSelected = tempDays.contains(day);
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                isSelected ? tempDays.remove(day) : tempDays.add(day);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(color: isSelected ? mintColor : Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
                              child: Text(day, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15),

                      // 💡 수기 입력 필드 삭제하고 타임 피커 버튼 2개(시작, 종료) 배치
                      Row(
                        children: [
                          Expanded(
                              child: _buildTimePickerBox(context, "시작 시간", tempStartTime, (picked) => setDialogState(() => tempStartTime = picked))
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("~", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                          ),
                          Expanded(
                              child: _buildTimePickerBox(context, "종료 시간", tempEndTime, (picked) => setDialogState(() => tempEndTime = picked))
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소", style: TextStyle(color: Color(0xFF8B809E), fontSize: 18, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _introduction = introController.text;
                              _availableDays = tempDays;
                              _startTime = tempStartTime;
                              _endTime = tempEndTime;

                              // 💡 시간 형식을 "오후 6:00 ~ 오후 10:00" 형태의 문자열로 변환하여 저장
                              if (_startTime != null && _endTime != null) {
                                String formatTime(TimeOfDay t) => "${t.period == DayPeriod.am ? '오전' : '오후'} ${t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod}:${t.minute.toString().padLeft(2, '0')}";
                                _availableTimeRange = "${formatTime(_startTime!)} ~ ${formatTime(_endTime!)}";
                              } else {
                                _availableTimeRange = "";
                              }
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC7EAE1), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12)),
                          child: const Text("저장", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF7A708A), fontSize: 14, fontWeight: FontWeight.bold)),
        TextField(controller: controller, readOnly: readOnly, maxLines: label == "내 소개" ? null : 1, style: TextStyle(color: readOnly ? Colors.grey.shade600 : Colors.black87), decoration: InputDecoration(isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 8), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: readOnly ? Colors.transparent : const Color(0xFFB5AEC0))), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: readOnly ? Colors.transparent : Colors.black, width: 1.5)))),
      ],
    );
  }

  Widget _buildTagChip(String label) {
    bool isSelected = _selectedTags.contains(label);
    return GestureDetector(
      onTap: () { setState(() { isSelected ? _selectedTags.remove(label) : _selectedTags.add(label); }); },
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: isSelected ? mintColor : Colors.grey.shade100, borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, fontSize: 13))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(backgroundColor: Colors.grey.shade50, elevation: 0, iconTheme: const IconThemeData(color: Colors.black), title: const Text("내 프로필", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(radius: 40, backgroundColor: Colors.grey.shade200, backgroundImage: _currentProfileImage != null ? (kIsWeb ? NetworkImage(_currentProfileImage!.path) : FileImage(_currentProfileImage!)) as ImageProvider : null, child: _currentProfileImage == null ? Icon(Icons.person, size: 50, color: Colors.grey.shade500) : null),
                    GestureDetector(onTap: _pickImage, child: Container(padding: const EdgeInsets.all(5), decoration: const BoxDecoration(color: Color(0xFFBCE0D8), shape: BoxShape.circle), child: const Icon(Icons.camera_alt, size: 18, color: Colors.white)))
                  ],
                ),
                const SizedBox(height: 15),
                Text(_userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 5),
                Text("$_university | $_department", style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w600)), const SizedBox(height: 15),
                Text(_introduction.isEmpty ? "소개글이 없습니다." : _introduction, style: const TextStyle(fontSize: 14, color: Colors.black87), textAlign: TextAlign.center),

                if (_availableDays.isNotEmpty || _availableTimeRange.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 15), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(color: mintColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                    child: Text("협업 가능: ${_availableDays.join(', ')} / $_availableTimeRange", style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),

                const SizedBox(height: 20),
                GestureDetector(onTap: _showEditProfileDialog, child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)), child: const Center(child: Text("프로필 수정", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("관심 분야", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), const SizedBox(height: 15), Wrap(spacing: 10, runSpacing: 10, children: _availableTags.map((tag) => _buildTagChip(tag)).toList())]),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RankingPage(currentExp: widget.totalExp))),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), decoration: BoxDecoration(color: mintColor.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: mintColor, width: 1.5)), child: Row(children: [CircleAvatar(backgroundColor: Colors.white, child: Image.asset("assets/Ranking_Mechuri.png", width: 22, height: 22, fit: BoxFit.contain)), const SizedBox(width: 15), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("나의 현재 랭킹 확인하기", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black87)), const SizedBox(height: 4), Text("현재 티어: 브론즈 (${widget.totalExp}점)", style: TextStyle(color: Colors.teal.shade700, fontSize: 13, fontWeight: FontWeight.bold))]), const Spacer(), Icon(Icons.chevron_right, color: Colors.teal.shade700)])),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
            child: Column(
              children: [
                _buildMenuListItem(Icons.history_outlined, "내 활동", "나의 전반적인 활동 히스토리를 확인합니다.", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivityLogScreen()));
                }),
                _buildMenuListItem(Icons.favorite_border_rounded, "내가 찜한 글", "찜해둔 스터디/팀플 글을 확인합니다.", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LikedPostsScreen()));
                }),
                _buildMenuListItem(Icons.history_edu_outlined, "내가 쓴 글", "내가 작성한 스터디/팀플 모집 글을 관리합니다."),
                _buildMenuListItem(Icons.reviews_outlined, "내 리뷰", "받은 리뷰와 작성한 리뷰를 확인합니다."),
                _buildMenuListItem(Icons.send_outlined, "지원 현황", "지원한 스터디 및 팀플의 상태를 확인합니다.", isLast: true),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: mintColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("로그아웃", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))), const SizedBox(height: 15),
          SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9B9B), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("계정 탈퇴", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))), const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildMenuListItem(IconData icon, String title, String subtitle, {bool isLast = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(title == "내 활동" ? 20 : 0),
        bottom: Radius.circular(isLast ? 20 : 0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade100))),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey.shade600), const SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.black87)), const SizedBox(height: 4), Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 12))])),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}