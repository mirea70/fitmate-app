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
  final Map<int, AccountProfile> _profileCache = {};

  @override
  Future<ChatRoomListState> build() async {
    return _loadAll();
  }

  Future<ChatRoomListState> _loadAll() async {
    // 내 프로필과 채팅방 목록을 병렬 조회
    final results = await Future.wait([
      ref.read(accountRepositoryProvider).getMyProfile(),
      ref.read(chatRepositoryProvider).getMyChatRooms(),
    ]);
    final profile = results[0] as AccountProfile;
    final rooms = results[1] as List<ChatRoom>;

    final newIds = <int>{};
    for (final room in rooms) {
      for (final id in room.memberAccountIds) {
        if (id != profile.accountId && !_profileCache.containsKey(id)) {
          newIds.add(id);
        }
      }
    }

    if (newIds.isNotEmpty) {
      final imageIds = <int?>[];
      await Future.wait(newIds.map((id) async {
        try {
          final p = await ref.read(accountRepositoryProvider).getProfileByAccountId(id);
          _profileCache[id] = p;
          imageIds.add(p.profileImageId);
        } catch (_) {}
      }));
      ref.read(imageCacheServiceProvider).preloadInBackground(imageIds);
    }

    return ChatRoomListState(
      rooms: rooms,
      myAccountId: profile.accountId,
      profileCache: Map.from(_profileCache),
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadAll());
  }
}
