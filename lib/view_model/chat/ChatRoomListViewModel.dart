import 'package:fitmate_app/model/chat/ChatRoom.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/repository/chat/ChatRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomListProvider =
    AsyncNotifierProvider<ChatRoomListViewModel, ChatRoomListState>(
        () => ChatRoomListViewModel());

class ChatRoomListState {
  final List<ChatRoom> rooms;
  final int myAccountId;

  ChatRoomListState({required this.rooms, required this.myAccountId});
}

class ChatRoomListViewModel extends AsyncNotifier<ChatRoomListState> {
  @override
  Future<ChatRoomListState> build() async {
    final profile = await ref.read(accountRepositoryProvider).getMyProfile();
    final rooms = await ref.read(chatRepositoryProvider).getMyChatRooms(profile.accountId);
    return ChatRoomListState(rooms: rooms, myAccountId: profile.accountId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final profile = await ref.read(accountRepositoryProvider).getMyProfile();
      final rooms = await ref.read(chatRepositoryProvider).getMyChatRooms(profile.accountId);
      return ChatRoomListState(rooms: rooms, myAccountId: profile.accountId);
    });
  }
}
