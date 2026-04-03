import 'dart:typed_data';

import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/model/chat/ChatRoom.dart';
import 'package:fitmate_app/view/chat/ChatRoomView.dart';
import 'package:fitmate_app/view_model/chat/ChatRoomListViewModel.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:fitmate_app/widget/ShimmerLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatListView extends ConsumerStatefulWidget {
  const ChatListView({super.key});

  @override
  ConsumerState<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends ConsumerState<ChatListView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !ref.read(chatRoomListProvider).hasValue) {
        ref.read(chatRoomListProvider.notifier).refresh();
      }
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
                return KeyedSubtree(
                    key: ValueKey(data.rooms[index].roomId),
                    child: _buildChatRoomItem(
                      data.rooms[index], data.myAccountId, deviceSize),
                );
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
        loading: () => const ChatListSkeleton(),
      ),
    );
  }

  Map<int, AccountProfile> _getProfileCache() {
    return ref.read(chatRoomListProvider).value?.profileCache ?? {};
  }

  String _getOtherNickNameSync(ChatRoom room, int myAccountId) {
    final otherIds = room.memberAccountIds.where((id) => id != myAccountId);
    if (otherIds.isEmpty) return room.roomName;
    final cache = _getProfileCache();
    return cache[otherIds.first]?.nickName ?? room.roomName;
  }

  Widget _buildChatRoomItem(ChatRoom room, int myAccountId, Size deviceSize) {
    final bool isDm = room.roomType == 'DM';

    return InkWell(
      onTap: () async {
        String displayName = isDm
            ? _getOtherNickNameSync(room, myAccountId)
            : room.roomName;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomView(
              roomId: room.roomId,
              roomName: displayName,
              memberAccountIds: room.memberAccountIds,
              matingId: room.matingId,
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
            _buildRoomThumbnail(room, myAccountId, deviceSize.width * 0.13),
            SizedBox(width: deviceSize.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isDm
                              ? _getOtherNickNameSync(room, myAccountId)
                              : room.roomName,
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
            SizedBox(width: deviceSize.width * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (room.lastMessageAt != null)
                  Text(
                    _formatTime(room.lastMessageAt!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                if (room.unreadCount > 0) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      room.unreadCount > 99 ? '99+' : '${room.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomThumbnail(ChatRoom room, int myAccountId, double size) {
    final otherIds = room.memberAccountIds
        .where((id) => id != myAccountId)
        .take(4)
        .toList();

    if (otherIds.isEmpty) {
      return DefaultProfileImage(size: size);
    }

    if (otherIds.length == 1) {
      return _buildSingleProfile(otherIds[0], size);
    }

    if (otherIds.length == 2) {
      return _buildDiagonalProfile(otherIds, size);
    }

    if (otherIds.length == 3) {
      return _buildTriangleProfile(otherIds, size);
    }

    return _buildQuadProfile(otherIds, size);
  }

  Widget _buildDiagonalProfile(List<int> accountIds, double size) {
    final smallSize = size * 0.65;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: _buildSmallCircleProfile(accountIds[0], smallSize),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildSmallCircleProfile(accountIds[1], smallSize),
          ),
        ],
      ),
    );
  }

  Widget _buildTriangleProfile(List<int> accountIds, double size) {
    final smallSize = size * 0.55;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: (size - smallSize) / 2,
            child: _buildSmallCircleProfile(accountIds[0], smallSize),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildSmallCircleProfile(accountIds[1], smallSize),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildSmallCircleProfile(accountIds[2], smallSize),
          ),
        ],
      ),
    );
  }

  Widget _buildQuadProfile(List<int> accountIds, double size) {
    final gap = 2.0;
    final cellSize = (size - gap) / 2;
    final radius = cellSize * 0.25;

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        children: [
          Row(
            children: [
              _buildRoundedCell(accountIds[0], cellSize, radius),
              SizedBox(width: gap),
              _buildRoundedCell(accountIds[1], cellSize, radius),
            ],
          ),
          SizedBox(height: gap),
          Row(
            children: [
              _buildRoundedCell(accountIds[2], cellSize, radius),
              SizedBox(width: gap),
              _buildRoundedCell(accountIds[3], cellSize, radius),
            ],
          ),
        ],
      ),
    );
  }

  Uint8List? _getCachedImage(int accountId) {
    final cache = _getProfileCache();
    final profileImageId = cache[accountId]?.profileImageId;
    if (profileImageId == null) return null;
    return ref.read(imageCacheServiceProvider).get(profileImageId);
  }

  Widget _buildRoundedCell(int accountId, double size, double radius) {
    final imageData = _getCachedImage(accountId);
    if (imageData != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(image: MemoryImage(imageData), fit: BoxFit.cover),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xffE0E0E0),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(Icons.person, size: size * 0.55, color: Colors.grey.shade400),
    );
  }

  Widget _buildSmallCircleProfile(int accountId, double size) {
    final imageData = _getCachedImage(accountId);
    if (imageData != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: MemoryImage(imageData), fit: BoxFit.cover),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      );
    }
    return _wrapWithBorder(DefaultProfileImage(size: size - 3), size);
  }

  Widget _wrapWithBorder(Widget child, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Center(child: child),
    );
  }

  Widget _buildSingleProfile(int accountId, double size) {
    final imageData = _getCachedImage(accountId);
    if (imageData != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: MemoryImage(imageData), fit: BoxFit.cover),
        ),
      );
    }
    return DefaultProfileImage(size: size);
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
