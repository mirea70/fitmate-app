import 'package:fitmate_app/model/account/AccountJoinError.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountJoinErrorViewModelProvider = NotifierProvider<AccountJoinErrorViewModel, AccountJoinError>(
    () => AccountJoinErrorViewModel());

class AccountJoinErrorViewModel extends Notifier<AccountJoinError> {

  @override
  AccountJoinError build() {
    return const AccountJoinError();
  }

  void reset() {
    state = const AccountJoinError();
  }

  void validateLoginName(String value) {
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{1,20}$';
    RegExp loginNameRegex = RegExp(pattern);
    if(!loginNameRegex.hasMatch(value) && value != '') {
      state = state.copyWith(loginNameError: () => '로그인 아이디는 영문, 숫자를 포함하여 최대 20자까지 가능합니다.');
    }
    else {
      state = state.copyWith(loginNameError: () => null);
    }
  }

  void validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$';
    RegExp passwordRegex = RegExp(pattern);
    if(!passwordRegex.hasMatch(value) && value != '') {
      state = state.copyWith(passwordError: () => '비밀번호는 영문 대문자, 소문자, 숫자, 특수문자를 각각 하나 이상 포함하여 8자리 이상이어야 합니다.');
    }
    else {
      state = state.copyWith(passwordError: () => null);
    }
  }

  void validateCheckPassword(String current, String check) {
    if((current != check) && check != '')
      state = state.copyWith(checkPasswordError: () => '비밀번호가 일치하지 않습니다.');
    else
      state = state.copyWith(checkPasswordError: () => null);
  }

  void validateNickName(String value) {
    String pattern = r'^[a-zA-Zㄱ-힣\d|s]*$';
    RegExp nickNameRegex = RegExp(pattern);
    if((value.length < 2 || value.length > 10 || !nickNameRegex.hasMatch(value)) && value != '')
      state = state.copyWith(nickNameError: () => '닉네임은 2~10자리의 문자이어야 합니다.');
    else
      state = state.copyWith(nickNameError: () => null);
  }

  void validateName(String value) {
    String pattern = r'^[가-힣]{2,5}$';
    RegExp nameRegex = RegExp(pattern);
    if((!nameRegex.hasMatch(value)) && value != '')
      state = state.copyWith(nameError: () => '이름은 2~5자의 한글이어야 합니다.');
    else
      state = state.copyWith(nameError: () => null);
  }

  void validatePhone(String value) {
    String pattern = r'^010\d{4}\d{4}$';
    RegExp nameRegex = RegExp(pattern);
    if(!nameRegex.hasMatch(value) && value != '')
      state = state.copyWith(phoneError: () => '휴대폰번호는 010으로 시작한 총 11자리의 숫자이어야 합니다.');
    else
      state = state.copyWith(phoneError: () => null);
  }

  void validateEmail(String value) {
    String pattern = r'[a-z0-9]+@[a-z]+\.[a-z]{2,3}';
    RegExp emailRegex = RegExp(pattern);
    if(!emailRegex.hasMatch(value) && value != '')
      state = state.copyWith(emailError: () => '올바른 이메일 형식이어야 합니다.');
    else
      state = state.copyWith(emailError: () => null);
  }
}
