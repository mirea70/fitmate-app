import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/model/account/NoticeResponse.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/view/account/UserProfileView.dart';
import 'package:fitmate_app/view/mate/MateDetailView.dart';
import 'package:fitmate_app/widget/CachedProfileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoticeListView extends ConsumerStatefulWidget {
  const NoticeListView({super.key});

  @override
  ConsumerState<NoticeListView> createState() => _NoticeListViewState();
}

class _NoticeListViewState extends ConsumerState<NoticeListView> {
  List<NoticeResponse> _notices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    try {
      final repo = ref.read(accountRepositoryProvider);
      await repo.markNoticesAsRead();
      final notices = await repo.getMyNotices();

      final senderIds = notices
          .map((n) => n.senderAccountId)
          .where((id) => id != null)
          .toSet();

      final imageIds = <int?>[];
      for (final id in senderIds) {
        try {
          final profile = await ref
              .read(accountRepositoryProvider)
              .getProfileByAccountId(id!);
          imageIds.add(profile.profileImageId);
        } catch (_) {}
      }
      await ref.read(imageCacheServiceProvider).preloadAll(imageIds);

      if (mounted) {
        setState(() {
          _notices = notices;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          '알림',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notices.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 50, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text(
                        '알림이 없습니다.',
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotices,
                  child: ListView.separated(
                    itemCount: _notices.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
                    itemBuilder: (context, index) {
                      return _buildNoticeItem(_notices[index]);
                    },
                  ),
                ),
    );
  }

  Widget _buildNoticeItem(NoticeResponse notice) {
    final config = _getNoticeConfig(notice.noticeType);

    return InkWell(
      onTap: () => _onNoticeTap(notice),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: config.bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(config.icon, color: config.iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: config.iconColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notice.content,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTimeAgo(notice.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 20),
          ],
        ),
      ),
    );
  }

  void _onNoticeTap(NoticeResponse notice) {
    if (notice.noticeType == 'FOLLOWED' && notice.senderAccountId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileView(accountId: notice.senderAccountId!),
        ),
      );
    } else if (notice.matingId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MateDetailView(mateId: notice.matingId!),
        ),
      );
    }
  }

  _NoticeConfig _getNoticeConfig(String noticeType) {
    switch (noticeType) {
      case 'MATE_APPROVED':
        return _NoticeConfig(
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          bgColor: Colors.green.shade50,
          label: '참여 승인',
        );
      case 'MATE_REQUESTED':
        return _NoticeConfig(
          icon: Icons.person_add_outlined,
          iconColor: Colors.orangeAccent,
          bgColor: const Color(0xFFFFF3E0),
          label: '새 신청',
        );
      case 'MATE_MODIFIED':
        return _NoticeConfig(
          icon: Icons.edit_outlined,
          iconColor: Colors.blue,
          bgColor: Colors.blue.shade50,
          label: '모임 수정',
        );
      case 'MATE_REGISTERED':
        return _NoticeConfig(
          icon: Icons.fiber_new_outlined,
          iconColor: Colors.cyan,
          bgColor: Colors.cyan.shade50,
          label: '새 모집',
        );
      case 'FOLLOWED':
        return _NoticeConfig(
          icon: Icons.favorite_border,
          iconColor: Colors.pinkAccent,
          bgColor: Colors.pink.shade50,
          label: '팔로우',
        );
      case 'MATE_CANCELLED':
        return _NoticeConfig(
          icon: Icons.cancel_outlined,
          iconColor: Colors.amber.shade700,
          bgColor: Colors.amber.shade50,
          label: '신청 취소',
        );
      case 'MATE_REMINDER':
        return _NoticeConfig(
          icon: Icons.schedule,
          iconColor: Colors.redAccent,
          bgColor: Colors.red.shade50,
          label: '일정 알림',
        );
      default:
        return _NoticeConfig(
          icon: Icons.notifications_outlined,
          iconColor: Colors.grey,
          bgColor: Colors.grey.shade100,
          label: '알림',
        );
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}주 전';
    return '${dateTime.month}월 ${dateTime.day}일';
  }
}

class _NoticeConfig {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;

  _NoticeConfig({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
  });
}
