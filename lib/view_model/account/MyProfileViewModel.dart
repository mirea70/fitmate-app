import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myProfileProvider = FutureProvider.autoDispose<AccountProfile>((ref) async {
  return ref.read(accountRepositoryProvider).getMyProfile();
});
