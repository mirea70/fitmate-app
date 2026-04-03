import 'package:fitmate_app/model/chat/ChatMessage.dart';
import 'package:fitmate_app/model/chat/ChatRoom.dart';

abstract class IChatRepository {
  Future<List<ChatRoom>> getMyChatRooms();
  Future<List<ChatMessage>> getMessages(String roomId);
  Future<void> markAsRead(String roomId);
  Future<void> leaveChatRoom(String roomId);
  Future<ChatRoom> createGroupRoom(Map<String, dynamic> body);
  Future<ChatRoom> createDmRoom(Map<String, dynamic> body);
}
