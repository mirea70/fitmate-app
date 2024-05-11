import 'package:fitmate_app/model/code/ValidateCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final validateCodeViewModelProvider = ChangeNotifierProvider<ValidateCodeViewModel>((ref) => ValidateCodeViewModel());

class ValidateCodeViewModel extends ChangeNotifier {

  ValidateCode validateCode = new ValidateCode();

  bool getIsVisibleCheckView() {
    return validateCode.isVisibleCheckView;
  }

  bool getIsChecked() {
    return validateCode.isChecked;
  }

  String? getCode() {
    return validateCode.code;
  }

  void checkValidateCode() {
    //TODO: 인증번호 체크 API 연동
    validateCode.isChecked = true;
    notifyListeners();
  }

  void setVisibleCheckView(bool value) {
    validateCode.isVisibleCheckView = value;
    notifyListeners();
  }

  void setCode(String value) {
    validateCode.code = value;
    notifyListeners();
  }
}