import 'package:fitmate_app/model/account/Account.dart';
import 'package:fitmate_app/view_model/AccountJoinErrorViewModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountJoinViewModelProvider = NotifierProvider<AccountJoinViewModel, Account>(
    () => AccountJoinViewModel());

final checkPasswordStateProvider = StateProvider<String>((ref) => '');

class AccountJoinViewModel extends Notifier<Account> {
  late AccountJoinErrorViewModel _errorViewModel;

  @override
  Account build() {
    _errorViewModel = ref.watch(accountJoinErrorViewModelProvider.notifier);
    return Account.initial();
  }

  void reset() {
    state = new Account.initial();
  }

  String getLoginName() {
    return state.loginName;
  }

  void setLoginName(String value) {
    state = state.copyWith(loginName: value);
    _errorViewModel.validateLoginName(value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
    _errorViewModel.validatePassword(value);
  }

  String getPassword() {
    return state.password;
  }

  void setNickName(String value) {
    state = state.copyWith(nickName: value);
    _errorViewModel.validateNickName(value);
  }

  void setIntroduction(String value) {
    state = state.copyWith(introduction: value);
  }

  void setName(String value) {
    state = state.copyWith(name: value);
    _errorViewModel.validateName(value);
  }

  void setPhone(String value) {
    state = state.copyWith(phone: value);
    _errorViewModel.validatePhone(value);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
    _errorViewModel.validateEmail(value);
  }

  void setGender(String value) {
    state = state.copyWith(gender: value);
  }

  void setProfileImageId(int value) {
    state = state.copyWith(profileImageId: value);
  }

  void validatePhoneWithAPI() {
    //TODO: 휴대번호 사용중인 회원 체크 API 연동
  }
}