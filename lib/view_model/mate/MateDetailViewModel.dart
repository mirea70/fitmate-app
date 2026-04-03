import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/model/mate/MateListItem.dart';
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

final mateDetailProvider = FutureProvider.family<MateDetailState, int>((ref, mateId) async {
  // 3개 API를 병렬로 호출
  final mateFuture = ref.read(mateRepositoryProvider).getMateOne(mateId);
  final profileFuture = ref.read(myProfileProvider.future).catchError((_) => null);
  final wishFuture = ref.read(mateRepositoryProvider).getMyWishList().catchError((_) => <MateListItem>[]);

  final mate = await mateFuture;
  final profile = await profileFuture;
  final wishList = await wishFuture;

  final myAccountId = profile?.accountId;
  final isWished = wishList.any((item) => item.id == mateId);

  final imageIds = <int?>[...mate.introImageIds, mate.writerImageId];
  await ref.read(imageCacheServiceProvider).ensureLoaded(imageIds);

  return MateDetailState(
    mate: mate,
    myAccountId: myAccountId,
    isWished: isWished,
  );
});
