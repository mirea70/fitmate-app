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

    // 읽음 처리와 알림 목록을 병렬 조회
    final results = await Future.wait([
      repo.markNoticesAsRead(),
      repo.getMyNotices(),
    ]);
    final notices = results[1] as List<NoticeResponse>;

    // 발신자 프로필 이미지도 병렬 조회
    final senderIds = notices
        .map((n) => n.senderAccountId)
        .where((id) => id != null)
        .toSet();

    final imageIds = <int?>[];
    if (senderIds.isNotEmpty) {
      final profiles = await Future.wait(
        senderIds.map((id) => repo.getProfileByAccountId(id!).catchError((_) => null)),
      );
      for (final profile in profiles) {
        if (profile != null) imageIds.add(profile.profileImageId);
      }
    }
    ref.read(imageCacheServiceProvider).preloadInBackground(imageIds);

    return notices;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadNotices());
  }
}
