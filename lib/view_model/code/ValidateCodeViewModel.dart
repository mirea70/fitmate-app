import 'package:fitmate_app/model/code/ValidateCode.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final validateCodeViewModelProvider = NotifierProvider<ValidateCodeViewModel, ValidateCode>(
        () => ValidateCodeViewModel());

class ValidateCodeViewModel extends Notifier<ValidateCode> {

  @override
  ValidateCode build() {
    return const ValidateCode();
  }

  bool getIsVisibleCheckView() {
    return state.isVisibleCheckView;
  }

  bool getIsChecked() {
    return state.isChecked;
  }

  void setIsChecked(bool value) {
    state = state.copyWith(isChecked: true);
  }

  String? getCode() {
    return state.code;
  }

  void setCode(String value) {
    state = state.copyWith(code: () => value);
  }

  void requestValidateCode(String phone) async {
    final result = await ref.read(accountRepositoryProvider).requestSmsCode(phone);
    if(result == true) state = state.copyWith(isVisibleCheckView: true);
    else throw 'UnKnown Exception';
  }

  Future<AsyncValue<void>> checkValidateCode(String inputCode) async {
    final result = await ref.read(accountRepositoryProvider).checkValidateCode(inputCode);
    if(result == false) {
      String errorTitle = '유효하지 않은 인증번호입니다.';
      String errorContent = '인증번호를 확인하고 다시 입력해주세요.';
      return AsyncValue.error(errorTitle + '||' + errorContent, StackTrace.empty);
    }
    else return AsyncValue.data(null);
  }
}
