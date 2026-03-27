import 'package:fitmate_app/model/chat/ChatRoom.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/repository/chat/ChatRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomListProvider =
    AsyncNotifierProvider<ChatRoomListViewModel, List<ChatRoom>>(
        () => ChatRoomListViewModel());

class ChatRoomListViewModel extends AsyncNotifier<List<ChatRoom>> {
  @override
  Future<List<ChatRoom>> build() async {
    final profile = await ref.read(accountRepositoryProvider).getMyProfile();
    return ref.read(chatRepositoryProvider).getMyChatRooms(profile.accountId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final profile = await ref.read(accountRepositoryProvider).getMyProfile();
      return ref.read(chatRepositoryProvider).getMyChatRooms(profile.accountId);
    });
  }
}
