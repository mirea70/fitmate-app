import 'package:dio/dio.dart';
import 'package:fitmate_app/config/Dio.dart';
import 'package:fitmate_app/model/chat/ChatMessage.dart';
import 'package:fitmate_app/model/chat/ChatRoom.dart';
import 'package:fitmate_app/repository/chat/IChatRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<IChatRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRepository(dio);
});

class ChatRepository implements IChatRepository {
  final Dio dio;

  ChatRepository(this.dio);

  Future<List<ChatRoom>> getMyChatRooms() async {
    try {
      final response = await dio.get(
        '/api/chat/my/rooms',
        options: Options(headers: {'accessToken': true}),
      );
      return List<Map<String, dynamic>>.from(response.data)
          .map((item) => ChatRoom.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('채팅방 목록 조회 중 오류가 발생했습니다.');
    }
  }

  Future<List<ChatMessage>> getMessages(String roomId) async {
    try {
      final response = await dio.get(
        '/api/chat/$roomId/messages',
        options: Options(headers: {'accessToken': true}),
      );
      return List<Map<String, dynamic>>.from(response.data)
          .map((item) => ChatMessage.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('메시지 목록 조회 중 오류가 발생했습니다.');
    }
  }

  Future<void> markAsRead(String roomId) async {
    try {
      await dio.put(
        '/api/chat/$roomId/read',
        options: Options(headers: {'accessToken': true}),
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('메시지 읽음 처리 중 오류가 발생했습니다.');
    }
  }

  Future<void> leaveChatRoom(String roomId) async {
    try {
      await dio.delete(
        '/api/chat/$roomId/leave',
        options: Options(headers: {'accessToken': true}),
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('채팅방 나가기 중 오류가 발생했습니다.');
    }
  }

  Future<ChatRoom> createGroupRoom(Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        '/api/chat/room/group',
        options: Options(
          headers: {'accessToken': true},
          contentType: Headers.jsonContentType,
        ),
        data: body,
      );
      return ChatRoom.fromJson(response.data);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('그룹 채팅방 생성 중 오류가 발생했습니다.');
    }
  }

  Future<ChatRoom> createDmRoom(Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        '/api/chat/room/dm',
        options: Options(
          headers: {'accessToken': true},
          contentType: Headers.jsonContentType,
        ),
        data: body,
      );
      return ChatRoom.fromJson(response.data);
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('DM 채팅방 생성 중 오류가 발생했습니다.');
    }
  }
}
