import 'package:fitmate_app/model/account/Account.dart';
import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/model/account/FollowDetail.dart';
import 'package:fitmate_app/model/account/MateRequestResponse.dart';
import 'package:fitmate_app/model/account/NoticeResponse.dart';

abstract class IAccountRepository {
  Future<bool> validateDuplicatedLoginName(String loginName);
  Future<bool> validateDuplicatedPhone(String phone);
  Future<bool> requestSmsCode(String phone);
  Future<bool> checkValidateCode(String phone, String code);
  Future<AccountProfile> getMyProfile();
  Future<AccountProfile> getProfileByAccountId(int accountId);
  Future<void> updateProfile({
    required String nickName,
    required String introduction,
    required String name,
    required String phone,
    required String email,
    int? profileImageId,
  });
  Future<List<NoticeResponse>> getMyNotices();
  Future<int> getUnreadNoticeCount();
  Future<void> markNoticesAsRead();
  Future<List<MateRequestResponse>> getMyMateRequests(String approveStatus);
  Future<void> deleteAccount(int accountId);
  Future<List<FollowDetail>> getMyFollowers();
  Future<List<FollowDetail>> getMyFollowings();
  Future<void> followUser(int targetAccountId);
  Future<dynamic> requestJoin(Account account);
  Future<String> findLoginName(String phone);
  Future<void> requestRecoveryCode(String phone);
  Future<void> verifyRecoveryCode(String phone, String code);
  Future<void> resetPassword(String phone, String newPassword);
}
