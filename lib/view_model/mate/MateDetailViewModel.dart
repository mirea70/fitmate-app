import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/repository/mate/MateRepository.dart';
import 'package:fitmate_app/view_model/account/MyProfileViewModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MateDetailState {
  final Mate mate;
  final int? myAccountId;
  final bool isWished;
  final int currentImage;

  MateDetailState({
    required this.mate,
    this.myAccountId,
    this.isWished = false,
    this.currentImage = 0,
  });

  MateDetailState copyWith({
    Mate? mate,
    int? myAccountId,
    bool? isWished,
    int? currentImage,
  }) {
    return MateDetailState(
      mate: mate ?? this.mate,
      myAccountId: myAccountId ?? this.myAccountId,
      isWished: isWished ?? this.isWished,
      currentImage: currentImage ?? this.currentImage,
    );
  }
}

final mateDetailProvider = FutureProvider.autoDispose.family<MateDetailState, int>((ref, mateId) async {
  final mate = await ref.read(mateRepositoryProvider).getMateOne(mateId);

  int? myAccountId;
  try {
    final profile = await ref.read(myProfileProvider.future);
    myAccountId = profile.accountId;
  } catch (_) {}

  bool isWished = false;
  try {
    final wishList = await ref.read(mateRepositoryProvider).getMyWishList();
    isWished = wishList.any((item) => item.id == mateId);
  } catch (_) {}

  final imageIds = <int?>[...mate.introImageIds, mate.writerImageId];
  await ref.read(imageCacheServiceProvider).preloadAll(imageIds);

  return MateDetailState(
    mate: mate,
    myAccountId: myAccountId,
    isWished: isWished,
  );
});
