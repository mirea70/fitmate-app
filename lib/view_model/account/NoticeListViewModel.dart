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

    return notices;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadNotices());
  }
}
