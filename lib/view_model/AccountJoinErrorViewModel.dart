import 'package:fitmate_app/model/account/AccountJoinError.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountJoinErrorViewModelProvider = ChangeNotifierProvider<AccountJoinErrorViewModel>((ref) => AccountJoinErrorViewModel());

class AccountJoinErrorViewModel extends ChangeNotifier {
  AccountJoinError _accountJoinError = new AccountJoinError();

  AccountJoinError get accountJoinError => _accountJoinError;

  void validatePassword(String value) {
    // String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$';
    // RegExp passwordRegex = RegExp(pattern);
    // if(!passwordRegex.hasMatch(value))
    //   _accountJoinError.passwordError = '비밀번호는 영문, 숫자, 특수문자를 포함하여 8자리 이상이어야 합니다.';
    // else
    //   _accountJoinError.passwordError = null;
    // notifyListeners();
  }

  void validateCheckPassword(String current, String check) {
    // if(current != check)
    //   _accountJoinError.checkPasswordError = '비밀번호가 일치하지 않습니다.';
    // else
    //   _accountJoinError.checkPasswordError = null;
  }

  void validateNickName(String value) {
    String pattern = r'^[a-zA-Zㄱ-힣\d|s]*$';
    RegExp nickNameRegex = RegExp(pattern);
    if(value.length < 2 || value.length > 10 || !nickNameRegex.hasMatch(value))
      _accountJoinError.nickNameError = '닉네임은 2~10자리의 문자이어야 합니다.';
    else
      _accountJoinError.nickNameError = null;
    notifyListeners();
  }

  void validateName(String value) {
    String pattern = r'[가-힣]*';
    RegExp nameRegex = RegExp(pattern);
    if(value.length < 2 || value.length > 5 || !nameRegex.hasMatch(value))
    _accountJoinError.nameError = '이름은 2~5자의 한글이어야 합니다.';
    else
      _accountJoinError.nameError = null;
    notifyListeners();
  }

  void validatePhone(String value) {
    String pattern = r'^010\d{4}\d{4}$';
    RegExp nameRegex = RegExp(pattern);
    if(!nameRegex.hasMatch(value))
      _accountJoinError.phoneError = '휴대폰번호는 010으로 시작한 총 11자리의 숫자이어야 합니다.';
    else
      _accountJoinError.phoneError = null;
    notifyListeners();
  }

  void validateEmail(String value) {
    String pattern = r'[a-z0-9]+@[a-z]+\.[a-z]{2,3}';
    RegExp emailRegex = RegExp(pattern);
    if(!emailRegex.hasMatch(pattern))
      _accountJoinError.emailError = '올바른 이메일 형식이어야 합니다.';
    else
      _accountJoinError.emailError = null;
    notifyListeners();
  }
}