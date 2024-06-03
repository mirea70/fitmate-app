import 'package:fitmate_app/error/CustomException.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/repository/mate/MateRepository.dart';
import 'package:fitmate_app/view_model/BaseViewModel.dart';
import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final mateRegisterViewModelProvider =
    NotifierProvider<MateRegisterViewModel, Mate>(
        () => MateRegisterViewModel());

class MateRegisterViewModel extends Notifier<Mate> implements BaseViewModel {
  @override
  Mate build() {
    return Mate.initial();
  }

  @override
  void reset() {
    state = Mate.initial();
  }

  void resetMateFees() {
    state = state.copyWith(mateFees: []);
  }

  void setFitCategory(FitCategory value) {
    state = state.copyWith(fitCategory: value);
  }

  void setPlace(String name, String address) {
    state = state.copyWith(fitPlaceName: name, fitPlaceAddress: address);
  }

  void setTitle(String value) {
    state = state.copyWith(title: value);
  }

  void validateTitle(String value) {
    String pattern = r'^[가-힣\s?!~]{5,20}$';
    RegExp nameRegex = RegExp(pattern);
    if ((!nameRegex.hasMatch(value)))
      throw CustomException(
        domain: ErrorDomain.MATE,
        type: ErrorType.INVALID_INPUT,
        msg: '제목은 5~20자의 한글 및 특수문자 ?, !, ~ 로 입력해야 합니다.',
      );
  }

  void setIntroduction(String value) {
    state = state.copyWith(introduction: value);
  }

  void setMateAtDate(DateTime date) {
    final selectDate = date;
    final defaultTime = TimeOfDay(hour: 18, minute: 0);
    final selectDateTime = DateTime(selectDate.year, selectDate.month,
        selectDate.day, defaultTime.hour, defaultTime.minute);
    state = state.copyWith(mateAt: selectDateTime);
  }

  void setMateAtTime(TimeOfDay time) {
    final orgDate = state.mateAt;
    final selectTime = time;
    final selectDateTime = DateTime(orgDate!.year, orgDate.month, orgDate.day,
        selectTime.hour, selectTime.minute);
    state = state.copyWith(mateAt: selectDateTime);
  }

  void addMateFee(MateFee mateFee) {
    _validateMateFeeName(mateFee.name);
    state = state.copyWith(mateFees: [...state.mateFees, mateFee], totalFee: state.totalFee! + mateFee.fee);
  }

  void _validateMateFeeName(String value) {
    String pattern = r'^[가-힣]{2,15}$';
    RegExp nameRegex = RegExp(pattern);
    if ((!nameRegex.hasMatch(value)))
      throw CustomException(
        domain: ErrorDomain.MATE,
        type: ErrorType.INVALID_INPUT,
        msg: '참가비 종류는 2~15자의 한글로 입력해야 합니다.',
      );
  }

  void setPermitPeopleCnt(int value) {
    state = state.copyWith(permitPeopleCnt: value);
  }

  void plusPermitPeopleCnt() {
    if(state.permitPeopleCnt! + 1 > 50) return;
    state = state.copyWith(permitPeopleCnt: state.permitPeopleCnt!+1);
  }

  void minusPermitPeopleCnt() {
    if(state.permitPeopleCnt! - 1 < 2) return;
    state = state.copyWith(permitPeopleCnt: state.permitPeopleCnt!-1);
  }

  void validatePermitPeopleCnt(int value) {
    if(value < 2 || value > 50)
      throw CustomException(domain: ErrorDomain.MATE, type: ErrorType.INVALID_INPUT, msg: '최대인원은 2~50명 사이로 설정 가능합니다.');
  }

  void setGatherType(GatherType value) {
    state = state.copyWith(gatherType: value);
  }

  void setPermitMinAge(int value) {
    state = state.copyWith(permitMinAge: value);
  }

  void setPermitMaxAge(int value) {
    state = state.copyWith(permitMaxAge: value);
  }

  void setPermitGender(PermitGender value) {
    state = state.copyWith(permitGender: value);
  }

  void setApplyQuestion(String value) {
    state = state.copyWith(applyQuestion: value);
  }

  void validateApplyQuestion(String value) {
    String pattern = r'^[가-힣\s?!~]{5,20}$';
    RegExp nameRegex = RegExp(pattern);
    if ((!nameRegex.hasMatch(value)))
      throw CustomException(
        domain: ErrorDomain.MATE,
        type: ErrorType.INVALID_INPUT,
        msg: '참여자 질문은 5~20자의 한글 및 특수문자 ?, !, ~ 로 입력해야 합니다.',
      );
  }

  Future<AsyncValue<void>> register() async {
    List<XFile> introImages = ref.read(fileViewModelProvider).files;
    List<String> introImagePaths = List.generate(introImages.length, (index) => introImages[index].path);
    final result = await ref.read(mateRepositoryProvider).requestRegister(state, introImagePaths);
    if(result != null) {
      if(result == "")
        return AsyncValue.error('알수없는 에러가 발생하였습니다.', StackTrace.empty);
      else if(result['error'] != null && result['error'] == 'Unauthorized')
        return AsyncValue.error('로그인이 만료되었습니다.', StackTrace.empty);
      return AsyncValue.error(result['message'] ?? '알수없는 에러가 발생하였습니다.', StackTrace.empty);
    }
    else return AsyncValue.data(null);
  }
}
