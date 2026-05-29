import 'package:flutter/material.dart';

class ApplyTeamDialog extends StatefulWidget {
  final Function(String, String)? onApplyDone;
  final String title;
  final String category;
  final String desc;
  final String status;
  final String members;
  final String duration;
  final List<Map<String, dynamic>>? roles;
  final int? grade;
  final String? projectType;

  const ApplyTeamDialog({
    Key? key,
    this.onApplyDone,
    required this.title,
    required this.category,
    required this.desc,
    required this.status,
    required this.members,
    required this.duration,
    this.roles,
    this.grade,
    this.projectType,
  }) : super(key: key);

  @override
  State<ApplyTeamDialog> createState() => _ApplyTeamDialogState();
}

class _ApplyTeamDialogState extends State<ApplyTeamDialog> {
  final Color mintColor = const Color(0xFFBCE0D8);
  final Color activeBlueColor = const Color(0xFF80E2FF);

  final TextEditingController _customRoleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? _selectedRole;
  bool _isCustomRole = false;

  bool _showRoleError = false;
  bool _showMessageError = false;

  @override
  void initState() {
    super.initState();
    // 만약 사전에 정의된 역할이 있으면 첫 번째 역할을 기본값으로 설정해줍니다.
    final validRoles = widget.roles
        ?.where((r) => r['name'] != null && r['name'].toString().trim().isNotEmpty)
        .toList() ?? [];

    if (validRoles.isNotEmpty) {
      final firstRole = validRoles.first['name']?.toString() ?? "";
      if (firstRole.isNotEmpty) {
        _selectedRole = firstRole;
      } else {
        _isCustomRole = true;
      }
    } else {
      _isCustomRole = true;
    }
  }

  @override
  void dispose() {
    _customRoleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 필터링된 역할 리스트 (비어있지 않은 역할들만 선별)
    final validRoles = widget.roles
        ?.where((r) => r['name'] != null && r['name'].toString().trim().isNotEmpty)
        .toList() ?? [];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 500,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. 헤더 영역 (고정)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 20, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "스터디 지원하기",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F1F1)),

              // 2. 스크롤 가능한 본문 영역
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- 스터디 정보 섹션 ---
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: activeBlueColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.category,
                              style: TextStyle(color: Colors.blue.shade800, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.status == "모집중" ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.status,
                              style: TextStyle(
                                color: widget.status == "모집중" ? Colors.green.shade700 : Colors.red.shade700,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
                      ),
                      const SizedBox(height: 15),

                      // 정보 요약 뱃지들
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCFCF6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoBadge(Icons.people_outline, "모집 인원", widget.members),
                            _buildInfoBadge(Icons.calendar_today_outlined, "진행 기간", widget.duration),
                            if (widget.grade != null || widget.projectType != null)
                              _buildInfoBadge(
                                Icons.school_outlined,
                                "대상 구분",
                                "${widget.grade != null ? '${widget.grade}학년' : ''} ${widget.projectType ?? ''}".trim(),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 상세 모집 역할 카드들 (있는 경우에만 표시)
                      if (validRoles.isNotEmpty) ...[
                        const Text(
                          "구인 대상 및 분야",
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: validRoles.map((role) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: mintColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${role['name']} (${role['count']}명)",
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // 프로젝트 상세 소개 박스
                      const Text(
                        "상세 소개",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          widget.desc,
                          style: TextStyle(color: Colors.grey.shade800, fontSize: 13, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF1F1F1)),
                      const SizedBox(height: 20),

                      // --- 신청서 작성 섹션 ---
                      Row(
                        children: [
                          Icon(Icons.edit_note, size: 22, color: Colors.teal.shade400),
                          const SizedBox(width: 6),
                          const Text(
                            "지원 신청서 작성",
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // 역할 선택 칩스
                      const Text(
                        "희망하는 역할을 선택해 주세요.",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...validRoles.map((role) {
                            final roleName = role['name']?.toString() ?? "";
                            final isSelected = !_isCustomRole && _selectedRole == roleName;
                            return ChoiceChip(
                              label: Text(roleName),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedRole = roleName;
                                    _isCustomRole = false;
                                    _showRoleError = false;
                                  });
                                }
                              },
                              selectedColor: mintColor.withOpacity(0.3),
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.teal.shade800 : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? Colors.teal.shade400 : Colors.grey.shade300,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                            );
                          }).toList(),
                          ChoiceChip(
                            label: const Text("직접 입력"),
                            selected: _isCustomRole,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _isCustomRole = true;
                                  _selectedRole = null;
                                  _showRoleError = false;
                                });
                              }
                            },
                            selectedColor: mintColor.withOpacity(0.3),
                            backgroundColor: Colors.grey.shade100,
                            labelStyle: TextStyle(
                              color: _isCustomRole ? Colors.teal.shade800 : Colors.black87,
                              fontWeight: _isCustomRole ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: _isCustomRole ? Colors.teal.shade400 : Colors.grey.shade300,
                                width: _isCustomRole ? 1.5 : 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_showRoleError) ...[
                        const SizedBox(height: 8),
                        const Text(
                          "⚠️ 희망 역할을 선택하거나 직접 입력해 주세요.",
                          style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                      const SizedBox(height: 15),

                      // 직접 입력 활성화 시 혹은 애초에 역할 리스트가 비어있는 경우 직접 입력 칸 노출
                      if (_isCustomRole) ...[
                        TextField(
                          controller: _customRoleController,
                          onChanged: (val) {
                            if (val.trim().isNotEmpty && _showRoleError) {
                              setState(() => _showRoleError = false);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "희망 역할을 직접 입력해 주세요. (예: 개발자)",
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // 한마디/각오 입력
                      const Text(
                        "지원자의 각오 및 한마디",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _messageController,
                        onChanged: (val) {
                          if (val.trim().isNotEmpty && _showMessageError) {
                            setState(() => _showMessageError = false);
                          }
                        },
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "팀원들에게 어필할 각오나 자기소개를 적어주세요!",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                          ),
                        ),
                      ),
                      if (_showMessageError) ...[
                        const SizedBox(height: 8),
                        const Text(
                          "⚠️ 지원 각오 및 소개글을 입력해 주세요.",
                          style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // 3. 하단 신청하기 버튼 영역 (고정)
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F1F1)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final finalRole = _isCustomRole
                          ? _customRoleController.text.trim()
                          : (_selectedRole ?? "").trim();
                      final message = _messageController.text.trim();

                      setState(() {
                        _showRoleError = finalRole.isEmpty;
                        _showMessageError = message.isEmpty;
                      });

                      if (finalRole.isEmpty || message.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.warning_amber_outlined, color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  finalRole.isEmpty
                                      ? "지원할 희망 역할을 선택하거나 입력해 주세요."
                                      : "지원 각오 및 한마디를 적어주세요!",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.amber.shade800,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                        return;
                      }

                      Navigator.pop(context);

                      if (widget.onApplyDone != null) {
                        widget.onApplyDone!(widget.title, widget.category);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 10),
                              Text("성공적으로 신청완료 되었습니다!", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          backgroundColor: Colors.teal.shade400,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mintColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "신청하기",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}