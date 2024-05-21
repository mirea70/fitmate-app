import 'package:fitmate_app/model/code/ValidateCode.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final validateCodeViewModelProvider = ChangeNotifierProvider<ValidateCodeViewModel>(
        (ref) => ValidateCodeViewModel(ref.read(accountRepositoryProvider)));

class ValidateCodeViewModel extends ChangeNotifier {
  ValidateCodeViewModel(this.accountRepository);

  ValidateCode validateCode = new ValidateCode();
  final AccountRepository accountRepository;

  bool getIsVisibleCheckView() {
    return validateCode.isVisibleCheckView;
  }

  bool getIsChecked() {
    return validateCode.isChecked;
  }

  void setIsChecked(bool value) {
    validateCode.isChecked = true;
    notifyListeners();
  }

  String? getCode() {
    return validateCode.code;
  }

  void setCode(String value) {
    validateCode.code = value;
    notifyListeners();
  }

  void requestValidateCode(String phone) async {
    final result = await accountRepository.requestSmsCode(phone);
    if(result == true) _setVisibleCheckView(true);
    else throw 'UnKnown Exception';
    notifyListeners();
  }

  void _setVisibleCheckView(bool value) {
    validateCode.isVisibleCheckView = value;
    notifyListeners();
  }

  Future<AsyncValue<void>> checkValidateCode(String inputCode) async {
    final result = await accountRepository.checkValidateCode(inputCode);
    if(result == false) {
      String errorTitle = '유효하지 않은 인증번호입니다.';
      String errorContent = '인증번호를 확인하고 다시 입력해주세요.';
      return AsyncValue.error(errorTitle + '||' + errorContent, StackTrace.empty);
    }
    else return AsyncValue.data(null);
  }
}