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

  StudyModel({
    this.id,
    required this.title,
    required this.category,
    required this.desc,
    required this.status,
    required this.maxMembers,
    required this.currentMembers,
    required this.duration,
  });

  // 1. 백엔드(JSON) -> 플러터 앱으로 변환할 때 사용 (연동 대비용)
  factory StudyModel.fromJson(Map<String, dynamic> json) {
    return StudyModel(
      id: json['id']?.toString(),
      title: json['title'] ?? '제목 없음',
      // 백엔드의 project_details 안의 project_type을 category로 매핑
      category: json['project_details']?['project_type'] ?? '스터디',
      desc: json['description'] ?? '내용 없음',
      status: json['status'] == 'recruiting' ? '모집중' : '마감',
      maxMembers: json['max_members'] ?? 4,
      currentMembers: json['current_members'] ?? 1,
      duration: "시간협의", // 임시 (백엔드의 deadline 활용 가능)
    );
  }

  // 2. 플러터 앱 -> 백엔드(JSON)로 보낼 때 사용 (작성하기 대비용)
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": desc,
      "max_members": maxMembers,
      "project_type": category,
      // 백엔드 schemas.py (StudyCreate) 규격에 맞춰 필요한 데이터 추가
    };
  }
}