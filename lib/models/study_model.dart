// lib/models/study_model.dart
class StudyModel {
  final String? id; // 나중에 백엔드에서 받을 고유 ID
  final String title;
  final String category; // 팀플, 스터디, 공모전
  final String desc;
  final String status; // recruiting, closed 등
  final int maxMembers;
  final int currentMembers;
  final String duration;
  final String? meetingSchedule;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? grade;
  final String? projectType;
  final List<Map<String, dynamic>>? roles;

  StudyModel({
    this.id,
    required this.title,
    required this.category,
    required this.desc,
    required this.status,
    required this.maxMembers,
    required this.currentMembers,
    required this.duration,
    this.meetingSchedule,
    this.startDate,
    this.endDate,
    this.grade,
    this.projectType,
    this.roles,
  });

  // 1. 백엔드(JSON) -> 플러터 앱으로 변환할 때 사용 (연동 대비용)
  factory StudyModel.fromJson(Map<String, dynamic> json) {
    return StudyModel(
      id: json['id']?.toString(),
      title: json['title'] ?? '제목 없음',
      category: json['category'] ?? '스터디',
      desc: json['description'] ?? '내용 없음',
      status: json['status'] == 'recruiting' ? '모집중' : '마감',
      maxMembers: json['max_members'] ?? 4,
      currentMembers: json['current_members'] ?? 1,
      duration: "시간협의", // 임시 (백엔드의 deadline 활용 가능)
      meetingSchedule: json['meeting_schedule']?['time'],
      startDate: json['startline'] != null ? DateTime.tryParse(json['startline']) : null,
      endDate: json['deadline'] != null ? DateTime.tryParse(json['deadline']) : null,
      grade: json['project_details']?['grade'],
      projectType: json['project_details']?['project_type'],
      roles: (json['recruitment_roles'] as List?)?.map((r) => {
        "name": r['role_name'],
        "count": r['required_count']
      }).toList(),
    );
  }

  // 2. 플러터 앱 -> 백엔드(JSON)로 보낼 때 사용 (작성하기 대비용)
  Map<String, dynamic> toJson() {
    return {
      "category": category,
      "title": title,
      "description": desc,
      "meeting_schedule": meetingSchedule != null ? {"time": meetingSchedule} : null,
      "startline": startDate?.toIso8601String().split('T')[0] ??
          DateTime.now().toIso8601String().split('T')[0],
      "deadline": endDate?.toIso8601String().split('T')[0] ??
          DateTime.now().add(const Duration(days: 30)).toIso8601String().split('T')[0],
      "max_members": maxMembers,
      "grade": grade ?? 1,
      "project_type": projectType ?? "기타",
      "roles": roles?.map((r) => {
        "role_name": r["name"] ?? "",
        "required_count": r["count"] ?? 1,
      }).toList() ?? [],
    };
  }
}