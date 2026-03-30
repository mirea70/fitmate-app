import 'dart:async';

import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/model/mate/MateListItem.dart';
import 'package:fitmate_app/repository/mate/MateRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mateAsyncViewModelProvider =
    AsyncNotifierProvider<MateAsyncViewModel, List<MateListItem>>(() {
  return MateAsyncViewModel();
});

class MateAsyncViewModel extends AsyncNotifier<List<MateListItem>> {
  @override
  Future<List<MateListItem>> build() async {
    return _fetchMates(0);
  }

  Future<List<MateListItem>> _fetchMates(int page) async {
    final items = await ref.read(mateRepositoryProvider).findAll(page);
    final imageIds = <int?>[];
    for (final item in items) {
      imageIds.add(item.thumbnailImageId);
      imageIds.add(item.writerImageId);
    }
    await ref.read(imageCacheServiceProvider).preloadAll(imageIds);
    return items;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchMates(0));
  }

  Future<void> addMate(Mate mate, List<String> introImagePaths) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(mateRepositoryProvider).requestRegister(mate, introImagePaths);
      return _fetchMates(0);
    });
  }
}
