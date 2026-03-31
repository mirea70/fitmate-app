import 'package:fitmate_app/config/StompService.dart';
import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/model/chat/ChatMessage.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/view/account/UserProfileView.dart';
import 'package:fitmate_app/view_model/account/MyProfileViewModel.dart';
import 'package:fitmate_app/view_model/chat/ChatMessageViewModel.dart';
import 'package:fitmate_app/widget/CachedProfileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatRoomView extends ConsumerStatefulWidget {
  final String roomId;
  final String roomName;
  final List<int> memberAccountIds;
  const ChatRoomView({
    super.key,
    required this.roomId,
    required this.roomName,
    this.memberAccountIds = const [],
  });

  @override
  ConsumerState<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends ConsumerState<ChatRoomView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<int, AccountProfile> _profileCache = {};
  bool _stompConnected = false;
  late final StompService _stompService;

  @override
  void initState() {
    super.initState();
    _stompService = ref.read(stompServiceProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(currentRoomIdProvider.notifier).set(widget.roomId);
      _connectStomp();
    });
  }

  void _connectStomp() {
    final stompService = ref.read(stompServiceProvider);
    stompService.connect(
      onConnected: () {
        if (mounted) {
          setState(() => _stompConnected = true);
          ref.invalidate(chatMessagesProvider);
        }
      },
      onError: (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _stompService.disconnect();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || !_stompConnected) return;

    ref.read(chatMessagesProvider.notifier).sendMessage(text);
    _messageController.clear();
  }

  void _showMemberList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '참여자 ${widget.memberAccountIds.length}명',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Divider(height: 1),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.memberAccountIds.length,
                  itemBuilder: (context, index) {
                    final accountId = widget.memberAccountIds[index];
                    return FutureBuilder<AccountProfile>(
                      future: _getProfile(accountId),
                      builder: (context, snapshot) {
                        final profile = snapshot.data;
                        return ListTile(
                          leading: _buildMemberProfileImage(
                              profile?.profileImageId, 40),
                          title: Text(
                            profile?.nickName ?? '...',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _navigateToProfile(accountId);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMemberProfileImage(int? profileImageId, double size) {
    return CachedProfileImage(imageId: profileImageId, size: size);
  }

  void _navigateToProfile(int accountId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileView(accountId: accountId),
      ),
    );
  }

  Future<AccountProfile> _getProfile(int accountId) async {
    if (_profileCache.containsKey(accountId)) {
      return _profileCache[accountId]!;
    }
    final profile = await ref
        .read(accountRepositoryProvider)
        .getProfileByAccountId(accountId);
    _profileCache[accountId] = profile;
    return profile;
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final messagesAsync = ref.watch(chatMessagesProvider);
    final myProfile = ref.watch(myProfileProvider);

    return Scaffold(
      backgroundColor: Color(0xffF1F1F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.roomName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (widget.memberAccountIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.people_outline, color: Colors.black),
              onPressed: () => _showMemberList(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isNotEmpty) _scrollToBottom();
                return myProfile.when(
                  data: (profile) =>
                      _buildMessageList(messages, profile.accountId, deviceSize),
                  error: (e, s) => const Center(child: Text('프로필 로드 실패')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
              error: (e, stack) => Center(
                child: Text('메시지를 불러올 수 없습니다.'),
              ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
          _buildMessageInput(deviceSize),
        ],
      ),
    );
  }

  Widget _buildMessageList(
      List<ChatMessage> messages, int myAccountId, Size deviceSize) {
    if (messages.isEmpty) {
      return const Center(
        child: Text(
          '아직 메시지가 없습니다.\n첫 메시지를 보내보세요!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: deviceSize.width * 0.03,
        vertical: 10,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];

        if (msg.isSystem) {
          return _buildSystemMessage(msg);
        }

        final isMe = msg.senderId == myAccountId;
        final prevMsg = index > 0 ? messages[index - 1] : null;
        final nextMsg = index < messages.length - 1 ? messages[index + 1] : null;
        final showProfile = !isMe &&
            (prevMsg == null || prevMsg.isSystem || prevMsg.senderId != msg.senderId);
        final showTime = nextMsg == null ||
            nextMsg.isSystem ||
            nextMsg.senderId != msg.senderId ||
            _isDifferentMinute(msg.createdAt, nextMsg.createdAt);

        return _buildMessageBubble(msg, isMe, showProfile, showTime, deviceSize);
      },
    );
  }

  Widget _buildSystemMessage(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            msg.message,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isMe, bool showProfile,
      bool showTime, Size deviceSize) {
    final timeText = DateFormat('a h:mm', 'ko_KR').format(msg.createdAt);

    if (isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showTime)
              Padding(
                padding: const EdgeInsets.only(right: 6, bottom: 2),
                child: Text(
                  timeText,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ),
            Container(
              constraints: BoxConstraints(maxWidth: deviceSize.width * 0.65),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xffFFAA5C),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                msg.message,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 4, top: showProfile ? 8 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showProfile)
            GestureDetector(
              onTap: () => _navigateToProfile(msg.senderId),
              child: _buildSenderProfile(msg.senderId, msg.senderProfileImageId,
                  deviceSize.width * 0.09),
            )
          else
            SizedBox(width: deviceSize.width * 0.09),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showProfile)
                  GestureDetector(
                    onTap: () => _navigateToProfile(msg.senderId),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _buildSenderName(msg),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: deviceSize.width * 0.6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        msg.message,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    if (showTime)
                      Padding(
                        padding: const EdgeInsets.only(left: 6, bottom: 2),
                        child: Text(
                          timeText,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderProfile(
      int senderId, int? profileImageId, double size) {
    return CachedProfileImage(imageId: profileImageId, size: size);
  }

  Widget _buildSenderName(ChatMessage msg) {
    if (msg.senderNickName != null) {
      return Text(
        msg.senderNickName!,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      );
    }
    return FutureBuilder<AccountProfile>(
      future: _getProfile(msg.senderId),
      builder: (context, snapshot) {
        return Text(
          snapshot.data?.nickName ?? '',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(Size deviceSize) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF1F1F1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: '메시지를 입력하세요',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isDifferentMinute(DateTime a, DateTime b) {
    return a.hour != b.hour || a.minute != b.minute;
  }
}
