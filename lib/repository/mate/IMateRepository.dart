import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/model/mate/MateListItem.dart';
import 'package:fitmate_app/model/mate/MateListRequestModel.dart';

abstract class IMateRepository {
  Future<void> requestRegister(Mate mate, List<String> introImagePaths);
  Future<void> requestModify(int mateId, Mate mate);
  Future<List<MateListItem>> findAll(int page, {bool includeClosed = false});
  Future<List<MateListItem>> findAllWithCondition(MateListRequestModel requestModel, int page, String? keyword);
  Future<Mate> getMateOne(int mateId);
  Future<List<MateListItem>> getMyMates();
  Future<Map<String, dynamic>> getMateQuestion(int mateId);
  Future<void> approveMate(int mateId, int applierId);
  Future<bool> toggleWish(int mateId);
  Future<List<MateListItem>> getMyWishList();
  Future<void> cancelMateApply(int mateId, String cancelReason);
  Future<void> closeMate(int mateId);
  Future<void> applyMate(int mateId, String comeAnswer);
}
