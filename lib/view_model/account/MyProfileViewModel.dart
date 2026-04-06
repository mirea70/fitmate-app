import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myProfileProvider = FutureProvider<AccountProfile>((ref) async {
  final profile = await ref.read(accountRepositoryProvider).getMyProfile();
  if (profile.profileImageId != null) {
    await ref.read(imageCacheServiceProvider).ensureLoaded([profile.profileImageId]);
  }
  return profile;
});
