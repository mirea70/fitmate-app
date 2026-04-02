import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unreadNoticeCountProvider = NotifierProvider<UnreadNoticeCountNotifier, int>(
    () => UnreadNoticeCountNotifier());

class UnreadNoticeCountNotifier extends Notifier<int> {
  @override
  int build() {
    _fetch();
    return 0;
  }

  Future<void> _fetch() async {
    try {
      final count = await ref.read(accountRepositoryProvider).getUnreadNoticeCount();
      state = count;
    } catch (_) {}
  }

  Future<void> refresh() async {
    await _fetch();
  }
}
