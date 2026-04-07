import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/model/account/NoticeResponse.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noticeListProvider = AsyncNotifierProvider<NoticeListViewModel, List<NoticeResponse>>(
  () => NoticeListViewModel(),
);

class NoticeListViewModel extends AsyncNotifier<List<NoticeResponse>> {
  @override
  Future<List<NoticeResponse>> build() async {
    return _loadNotices();
  }

  Future<List<NoticeResponse>> _loadNotices() async {
    final repo = ref.read(accountRepositoryProvider);

    // 읽음 처리 (실패해도 무시)
    repo.markNoticesAsRead().catchError((_) {});

    // 알림 목록 조회
    final notices = await repo.getMyNotices();

    // 발신자 프로필 이미지 사전 로드 (실패해도 무시)
    try {
      final senderIds = notices
          .map((n) => n.senderAccountId)
          .where((id) => id != null)
          .toSet();

      final imageIds = <int?>[];
      if (senderIds.isNotEmpty) {
        for (final id in senderIds) {
          try {
            final profile = await repo.getProfileByAccountId(id!);
            imageIds.add(profile.profileImageId);
          } catch (_) {}
        }
      }
      await ref.read(imageCacheServiceProvider).ensureLoaded(imageIds);
    } catch (_) {}

    return notices;
  }

  Future<void> refresh() async {
    if (!state.hasValue) {
      state = const AsyncValue.loading();
    }
    state = await AsyncValue.guard(() => _loadNotices());
  }
}
