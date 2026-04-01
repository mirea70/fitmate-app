import 'package:dio/dio.dart';
import 'package:fitmate_app/config/Dio.dart';
import 'package:fitmate_app/model/chat/ChatMessage.dart';
import 'package:fitmate_app/model/chat/ChatRoom.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRepository(dio);
});

class ChatRepository {
  final Dio dio;

  ChatRepository(this.dio);

  Future<List<ChatRoom>> getMyChatRooms() async {
    final response = await dio.get(
      '/api/chat/my/rooms',
      options: Options(headers: {'accessToken': true}),
    );
    return List<Map<String, dynamic>>.from(response.data)
        .map((item) => ChatRoom.fromJson(item))
        .toList();
  }

  Future<List<ChatMessage>> getMessages(String roomId) async {
    final response = await dio.get(
      '/api/chat/$roomId/messages',
      options: Options(headers: {'accessToken': true}),
    );
    return List<Map<String, dynamic>>.from(response.data)
        .map((item) => ChatMessage.fromJson(item))
        .toList();
  }

  Future<void> leaveChatRoom(String roomId) async {
    await dio.delete(
      '/api/chat/$roomId/leave',
      options: Options(headers: {'accessToken': true}),
    );
  }

  Future<ChatRoom> createGroupRoom(Map<String, dynamic> body) async {
    final response = await dio.post(
      '/api/chat/room/group',
      options: Options(
        headers: {'accessToken': true},
        contentType: Headers.jsonContentType,
      ),
      data: body,
    );
    return ChatRoom.fromJson(response.data);
  }

  Future<ChatRoom> createDmRoom(Map<String, dynamic> body) async {
    final response = await dio.post(
      '/api/chat/room/dm',
      options: Options(
        headers: {'accessToken': true},
        contentType: Headers.jsonContentType,
      ),
      data: body,
    );
    return ChatRoom.fromJson(response.data);
  }
}
