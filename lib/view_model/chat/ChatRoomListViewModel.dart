import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/model/account/AccountProfile.dart';
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
  final Map<int, AccountProfile> profileCache;

  ChatRoomListState({
    required this.rooms,
    required this.myAccountId,
    required this.profileCache,
  });
}

class ChatRoomListViewModel extends AsyncNotifier<ChatRoomListState> {
  @override
  Future<ChatRoomListState> build() async {
    return _loadAll();
  }

  Future<ChatRoomListState> _loadAll() async {
    final profile = await ref.read(accountRepositoryProvider).getMyProfile();
    final rooms = await ref.read(chatRepositoryProvider).getMyChatRooms();

    final otherIds = <int>{};
    for (final room in rooms) {
      for (final id in room.memberAccountIds) {
        if (id != profile.accountId) otherIds.add(id);
      }
    }

    final profileCache = <int, AccountProfile>{};
    final imageIds = <int?>[];
    await Future.wait(otherIds.map((id) async {
      try {
        final p = await ref.read(accountRepositoryProvider).getProfileByAccountId(id);
        profileCache[id] = p;
        imageIds.add(p.profileImageId);
      } catch (_) {}
    }));

    await ref.read(imageCacheServiceProvider).preloadAll(imageIds);

    return ChatRoomListState(
      rooms: rooms,
      myAccountId: profile.accountId,
      profileCache: profileCache,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadAll());
  }
}
