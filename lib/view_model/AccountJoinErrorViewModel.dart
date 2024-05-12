import 'package:fitmate_app/model/account/AccountJoinError.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountJoinErrorViewModelProvider = ChangeNotifierProvider<AccountJoinErrorViewModel>((ref) => AccountJoinErrorViewModel());

class AccountJoinErrorViewModel extends ChangeNotifier {

  AccountJoinError _errorModel = new AccountJoinError();

  AccountJoinError get accountJoinError => _errorModel;

  void reset() {
    _errorModel = new AccountJoinError();
  }

  String? getLoginNameError() {
    return _errorModel.loginNameError;
  }

  String? getPasswordError() {
    return _errorModel.passwordError;
  }

  String? getCheckPasswordError() {
    return _errorModel.checkPasswordError;
  }

  String? getPhoneError() {
    return _errorModel.phoneError;
  }

  String? getNameError() {
    return _errorModel.nameError;
  }

  String? getEmailError() {
    return _errorModel.emailError;
  }

  String? getNickNameError() {
    return _errorModel.nickNameError;
  }


  void validateLoginName(String value) {
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{1,20}$';
    RegExp loginNameRegex = RegExp(pattern);
    if(!loginNameRegex.hasMatch(value) && value != '') {
      _errorModel.loginNameError = '로그인 아이디는 영문, 숫자를 포함하여 최대 20자까지 가능합니다.';
    }
    else {
      _errorModel.loginNameError = null;
    }
    notifyListeners();
  }

  void validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$';
    RegExp passwordRegex = RegExp(pattern);
    if(!passwordRegex.hasMatch(value) && value != '') {
      _errorModel.passwordError = '비밀번호는 영문 대문자, 소문자, 숫자, 특수문자를 각각 하나 이상 포함하여 8자리 이상이어야 합니다.';
    }
    else {
      _errorModel.passwordError = null;
    }
    notifyListeners();
  }

  void validateCheckPassword(String current, String check) {
    if((current != check) && check != '')
      _errorModel.checkPasswordError = '비밀번호가 일치하지 않습니다.';
    else
      _errorModel.checkPasswordError = null;
    notifyListeners();
  }

  void validateNickName(String value) {
    String pattern = r'^[a-zA-Zㄱ-힣\d|s]*$';
    RegExp nickNameRegex = RegExp(pattern);
    if((value.length < 2 || value.length > 10 || !nickNameRegex.hasMatch(value)) && value != '')
      _errorModel.nickNameError = '닉네임은 2~10자리의 문자이어야 합니다.';
    else
      _errorModel.nickNameError = null;
    notifyListeners();
  }

  void validateName(String value) {
    String pattern = r'^[가-힣]{2,5}$';
    RegExp nameRegex = RegExp(pattern);
    if((!nameRegex.hasMatch(value)) && value != '')
      _errorModel.nameError = '이름은 2~5자의 한글이어야 합니다.';
    else
      _errorModel.nameError = null;
    notifyListeners();
  }

  void validatePhone(String value) {
    String pattern = r'^010\d{4}\d{4}$';
    RegExp nameRegex = RegExp(pattern);
    if(!nameRegex.hasMatch(value) && value != '')
      _errorModel.phoneError = '휴대폰번호는 010으로 시작한 총 11자리의 숫자이어야 합니다.';
    else
      _errorModel.phoneError = null;
    notifyListeners();
  }

  void validateEmail(String value) {
    String pattern = r'[a-z0-9]+@[a-z]+\.[a-z]{2,3}';
    RegExp emailRegex = RegExp(pattern);
    if(!emailRegex.hasMatch(value) && value != '')
      _errorModel.emailError = '올바른 이메일 형식이어야 합니다.';
    else
      _errorModel.emailError = null;
    notifyListeners();
  }
}