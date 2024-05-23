
import 'dart:async';

import 'package:fitmate_app/repository/naver/NaverApiRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchViewModelProvider = AsyncNotifierProvider<SearchViewModel, List<Map<String, dynamic>>>(
    () => SearchViewModel());

class SearchViewModel extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  FutureOr<List<Map<String, dynamic>>> build() {
    return [];
  }

  Future<void> searchPlace(String keyword) async {
    if(keyword == '') return;
    state = const AsyncValue.loading();
    // state = await AsyncValue.guard(() async {
    //   return ref.read(naverApiRepositoryProvider).searchPlace(keyword);
    // });
    state = AsyncValue.data(await ref.read(naverApiRepositoryProvider).searchPlace(keyword));
  }

  void reset() {
    state = AsyncValue.data([]);
  }
}