import 'package:flutter/material.dart';
import 'package:cap/screens/write_post/widget/WritePostScreen_Widget.dart';
import 'package:cap/models/study_model.dart';

class WritePostScreen extends StatefulWidget {
  final String? initialCategory;

  const WritePostScreen({Key? key, this.initialCategory}) : super(key: key);

  @override
  State<WritePostScreen> createState() => _WritePostScreenState();
}

class _WritePostScreenState extends State<WritePostScreen> {
  final Color mintColor = const Color(0xFFBCE0D8);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String? _selectedCategory;

  int _selectedType = 0;
  int _selectedGrade = 1;
  final List<Map<String, dynamic>> _roles = [{"name": "", "count": 1}];

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030),
      builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: mintColor, onPrimary: Colors.black87, onSurface: Colors.black87)), child: child!),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _startDate!.isAfter(_endDate!)) _endDate = null;
        } else { _endDate = picked; }
      });
    }
  }

  Widget _buildTimePickerBox(BuildContext context, String hint, TimeOfDay? time, Function(TimeOfDay) onPicked) {
    String displayTime = time != null
        ? "${time.period == DayPeriod.am ? '오전' : '오후'} ${time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')}"
        : hint;

    return GestureDetector(
        onTap: () async {
          TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: time ?? TimeOfDay.now(),
            builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: mintColor, onPrimary: Colors.black87, onSurface: Colors.black87)), child: child!),
          );
          if (picked != null) onPicked(picked);
        },
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10), color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    bool isFormDisabled = _selectedCategory == null;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFCF6), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28), onPressed: () => Navigator.pop(context)),
        title: const Text("게시글 작성", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 24)), centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            buildSectionCard(
              title: "카테고리",
              icon: Icons.category_outlined,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryRadio("팀플"), _buildCategoryRadio("스터디"), _buildCategoryRadio("공모전"),
                ],
              ),
            ),

            IgnorePointer(
              ignoring: isFormDisabled,
              child: Opacity(
                opacity: isFormDisabled ? 0.3 : 1.0,
                child: Column(
                  children: [
                    buildSectionCard(title: "제목", icon: Icons.label_outline, child: TextField(controller: _titleController, decoration: InputDecoration(hintText: "제목을 입력하세요.", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black87, width: 1.5)), contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15)))),
                    buildSectionCard(title: "모집 정보", icon: Icons.school_outlined, child: Column(children: [_buildTypeOption(0, "전공"), const SizedBox(height: 10), _buildTypeOption(1, "교양")])),
                    buildSectionCard(title: "수업", icon: Icons.people_outline, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildGradeOption(1, "1학년"), _buildGradeOption(2, "2학년"), _buildGradeOption(3, "3학년"), _buildGradeOption(4, "4학년")])),
                    Container(
                      padding: const EdgeInsets.all(20), margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("역할 및 구인 인원", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)), const SizedBox(height: 12),
                          ..._roles.asMap().entries.map((entry) {
                            int index = entry.key;
                            return Padding(padding: const EdgeInsets.only(bottom: 10.0), child: Row(children: [Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle)), const SizedBox(width: 10), Expanded(child: TextField(controller: TextEditingController(text: _roles[index]["name"]), onChanged: (value) => _roles[index]["name"] = value, decoration: InputDecoration(hintText: "예) 자료조사", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13), isDense: true, border: InputBorder.none))), const Text(" : ", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 40, child: TextField(textAlign: TextAlign.center, keyboardType: TextInputType.number, controller: TextEditingController(text: _roles[index]["count"].toString()), onChanged: (value) => _roles[index]["count"] = int.tryParse(value) ?? 1, decoration: InputDecoration(isDense: true, focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: mintColor, width: 2))))), const Text(" 명", style: TextStyle(fontWeight: FontWeight.bold))]));
                          }).toList(),
                          GestureDetector(onTap: () => setState(() => _roles.add({"name": "", "count": 1})), child: Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: Row(children: [Icon(Icons.add_circle_outline, size: 18, color: Colors.grey.shade500), const SizedBox(width: 5), Text("추가", style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.bold))]))),
                        ],
                      ),
                    ),
                    buildSectionCard(title: "모집 기간", icon: Icons.calendar_month_outlined, child: Row(children: [Expanded(child: _buildDateInputBox("시작일", true)), const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("≈", style: TextStyle(color: Colors.grey, fontSize: 24))), Expanded(child: _buildDateInputBox("종료일", false))])),

                    buildSectionCard(title: "희망 시간대", icon: Icons.access_time, child: Row(
                      children: [
                        Expanded(child: _buildTimePickerBox(context, "시작 시간", _startTime, (picked) => setState(() => _startTime = picked))),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("~", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey))),
                        Expanded(child: _buildTimePickerBox(context, "종료 시간", _endTime, (picked) => setState(() => _endTime = picked))),
                      ],
                    )),

                    buildSectionCard(title: "내용", icon: Icons.chat_bubble_outline, child: TextField(controller: _descController, maxLines: 4, decoration: InputDecoration(hintText: "내용을 자세히 적어주세요.", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black87, width: 1.5))))),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity, height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          int totalMembers = 0;
                          for (var role in _roles) totalMembers += (role['count'] as int);

                          // 💡 추가됨: 방장 본인 1명을 모집 인원에 추가하여 계산
                          int finalMaxMembers = totalMembers + 1;

                          String formatTime(TimeOfDay t) => "${t.period == DayPeriod.am ? '오전' : '오후'} ${t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod}:${t.minute.toString().padLeft(2, '0')}";

                          String durationText = "";
                          if (_startDate != null && _endDate != null) {
                            durationText += "${_startDate!.month}/${_startDate!.day}~${_endDate!.month}/${_endDate!.day}";
                          }
                          if (_startTime != null && _endTime != null) {
                            if (durationText.isNotEmpty) durationText += " ";
                            durationText += "${formatTime(_startTime!)}~${formatTime(_endTime!)}";
                          }
                          if (durationText.isEmpty) {
                            durationText = "시간협의";
                          }

                          StudyModel newPostData = StudyModel(
                            title: _titleController.text.isEmpty ? "무제 스터디" : _titleController.text,
                            category: _selectedCategory ?? "스터디",
                            desc: _descController.text.isEmpty ? "내용이 없습니다." : _descController.text,
                            status: "모집중",
                            maxMembers: finalMaxMembers, // 수정된 부분 적용!
                            currentMembers: 1,
                            duration: durationText,
                            meetingSchedule: (_startTime != null && _endTime != null)
                                ? "${formatTime(_startTime!)}~${formatTime(_endTime!)}"
                                : null,
                            startDate: _startDate,
                            endDate: _endDate,
                            grade: _selectedGrade,
                            projectType: _selectedType == 0 ? "전공" : "교양",
                            roles: _roles,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 10), Text("작성이 완료되었습니다!", style: TextStyle(fontWeight: FontWeight.bold))]), backgroundColor: Colors.teal.shade400, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), duration: const Duration(seconds: 2)));

                          Navigator.pop(context, newPostData);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: mintColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        child: const Text("작성하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRadio(String title) {
    bool isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.grey.shade50, border: Border.all(color: isSelected ? Colors.black87 : Colors.grey.shade300, width: isSelected ? 1.5 : 1), borderRadius: BorderRadius.circular(20)),
        child: Row(children: [Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.black87 : Colors.grey.shade600)), const SizedBox(width: 6), Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, size: 18, color: isSelected ? Colors.black87 : Colors.grey.shade400)]),
      ),
    );
  }

  Widget _buildTypeOption(int index, String text) {
    bool isSelected = _selectedType == index;
    return GestureDetector(onTap: () => setState(() => _selectedType = index), child: Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? Colors.black87 : Colors.grey.shade400, size: 22)])));
  }

  Widget _buildGradeOption(int grade, String text) {
    bool isSelected = _selectedGrade == grade;
    return GestureDetector(onTap: () => setState(() => _selectedGrade = grade), child: Row(children: [Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? Colors.black87 : Colors.grey.shade400, size: 20), const SizedBox(width: 5), Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]));
  }

  Widget _buildDateInputBox(String hintText, bool isStart) {
    DateTime? selectedDate = isStart ? _startDate : _endDate;
    String displayText = selectedDate != null ? "${selectedDate.year}.${selectedDate.month}.${selectedDate.day}" : hintText;
    return GestureDetector(
      onTap: () => _selectDate(context, isStart),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(displayText, style: TextStyle(color: selectedDate != null ? Colors.black87 : Colors.grey.shade400, fontSize: 14, fontWeight: selectedDate != null ? FontWeight.bold : FontWeight.normal)), Icon(Icons.calendar_month_outlined, color: selectedDate != null ? mintColor : Colors.grey.shade600, size: 20)])),
    );
  }
}