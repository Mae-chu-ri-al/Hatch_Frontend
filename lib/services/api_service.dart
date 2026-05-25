// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/study_model.dart';

class ApiService {
  // 실제 연동 시 백엔드 주소로 바꿀 곳 (현재는 로컬 테스트 주소)
  static const String baseUrl = 'http://127.0.0.1:8000';
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService() {
    // 요청을 보낼 때마다 자동으로 토큰(출입증)을 헤더에 붙여주는 설정
    _dio.interceptors.add(InterceptorsWrapper(
      // 최신 dio 버전에 맞춘 타입 명시 및 return 제거
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  // 게시글 목록 불러오기 (연동 준비 상태)
  Future<List<StudyModel>> fetchStudies(String category) async {
    try {
      final response = await _dio.get('/studies/search', queryParameters: {'project_type': category});
      return (response.data as List).map((json) => StudyModel.fromJson(json)).toList();

      /*
      await Future.delayed(const Duration(seconds: 1));
      return [
        StudyModel(id: '1', title: '$category 테스트 1', category: category, desc: 'API 연결 준비 완료', status: '모집중', maxMembers: 4, currentMembers: 1, duration: '1개월'),
        StudyModel(id: '2', title: '$category 테스트 2', category: category, desc: '더미 데이터 대체됨', status: '모집중', maxMembers: 6, currentMembers: 3, duration: '2개월'),
      ];
      */
    } catch (e) {
      print("에러 발생: $e");
      return [];
    }
  }

  // 게시글 작성하기 (연동 준비 상태)
  Future<bool> createStudy(StudyModel study) async {
    try {
      final response = await _dio.post('/studies/post', data: study.toJson());
      return response.statusCode == 200;

      /*
      await Future.delayed(const Duration(seconds: 1));
      return true;
      */
    } catch (e) {
      return false;
    }
  }
}