import 'package:fitmate_app/model/chat/ChatRoom.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/view/chat/ChatRoomView.dart';
import 'package:fitmate_app/view_model/chat/ChatRoomListViewModel.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatListView extends ConsumerStatefulWidget {
  const ChatListView({super.key});

  @override
  ConsumerState<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends ConsumerState<ChatListView> {
  final Map<int, String> _nickNameCache = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatRoomListProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final chatRoomsAsync = ref.watch(chatRoomListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '채팅',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: chatRoomsAsync.when(
        data: (data) {
          if (data.rooms.isEmpty) {
            return const Center(
              child: Text(
                '참여 중인 채팅방이 없습니다.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(chatRoomListProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: data.rooms.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade200,
                indent: deviceSize.width * 0.2,
              ),
              itemBuilder: (context, index) {
                return _buildChatRoomItem(
                    data.rooms[index], data.myAccountId, deviceSize);
              },
            ),
          );
        },
        error: (e, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('채팅방 목록을 불러올 수 없습니다.'),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () =>
                    ref.read(chatRoomListProvider.notifier).refresh(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<String> _getOtherNickName(ChatRoom room, int myAccountId) async {
    final otherIds = room.memberAccountIds.where((id) => id != myAccountId);
    if (otherIds.isEmpty) return room.roomName;

    final otherId = otherIds.first;
    if (_nickNameCache.containsKey(otherId)) return _nickNameCache[otherId]!;

    try {
      final profile = await ref
          .read(accountRepositoryProvider)
          .getProfileByAccountId(otherId);
      _nickNameCache[otherId] = profile.nickName;
      return profile.nickName;
    } catch (_) {
      return room.roomName;
    }
  }

  Widget _buildChatRoomItem(ChatRoom room, int myAccountId, Size deviceSize) {
    final bool isDm = room.roomType == 'DM';

    return InkWell(
      onTap: () async {
        String displayName = room.roomName;
        if (isDm) {
          displayName = await _getOtherNickName(room, myAccountId);
        }
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomView(
              roomId: room.roomId,
              roomName: displayName,
            ),
          ),
        );
        ref.read(chatRoomListProvider.notifier).refresh();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: deviceSize.width * 0.04,
          vertical: deviceSize.height * 0.015,
        ),
        child: Row(
          children: [
            DefaultProfileImage(size: deviceSize.width * 0.13),
            SizedBox(width: deviceSize.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: isDm
                            ? FutureBuilder<String>(
                                future: _getOtherNickName(room, myAccountId),
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data ?? room.roomName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              )
                            : Text(
                                room.roomName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      if (!isDm && room.memberAccountIds.length > 2)
                        Text(
                          ' ${room.memberAccountIds.length}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.lastMessage ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (room.lastMessageAt != null) ...[
              SizedBox(width: deviceSize.width * 0.02),
              Text(
                _formatTime(room.lastMessageAt!),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays == 0) {
      return DateFormat('a h:mm', 'ko_KR').format(dateTime);
    } else if (diff.inDays == 1) {
      return '어제';
    } else if (diff.inDays < 7) {
      const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      return weekdays[dateTime.weekday - 1];
    } else {
      return DateFormat('M월 d일').format(dateTime);
    }
  }
}
