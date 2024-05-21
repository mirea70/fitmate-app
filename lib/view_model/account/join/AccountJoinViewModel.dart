import 'package:fitmate_app/model/account/Account.dart';

import 'package:fitmate_app/view_model/BaseViewModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../repository/account/AccountRepository.dart';
import 'AccountJoinErrorViewModel.dart';

final accountJoinViewModelProvider = NotifierProvider<AccountJoinViewModel, Account>(
    () => AccountJoinViewModel());

final checkPasswordStateProvider = StateProvider<String>((ref) => '');

class AccountJoinViewModel extends Notifier<Account> implements BaseViewModel {
  late AccountJoinErrorViewModel _errorViewModel;

  @override
  Account build() {
    _errorViewModel = ref.watch(accountJoinErrorViewModelProvider.notifier);
    return Account.initial();
  }

  @override
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

  void setGender(Gender? value) {
    state = state.copyWith(gender: value);
  }

  void setProfileImageId(int value) {
    state = state.copyWith(profileImageId: value);
  }

  Future<AsyncValue<void>> validateDuplicatedLoginName() async {
      final result = await ref.read(accountRepositoryProvider).validateDuplicatedLoginName(state.loginName);
      if(result == false) {
        String errorTitle = '이미 가입한 로그인ID 입니다.';
        String errorContent = '다른 로그인ID를 입력해주세요.';
        return AsyncValue.error(errorTitle + '||' + errorContent, StackTrace.empty);
      }
      else return AsyncValue.data(null);
  }

  Future<AsyncValue<void>> validateDuplicatedPhone() async {
    final result = await ref.read(accountRepositoryProvider).validateDuplicatedPhone(state.phone);
    if(result == false) {
      String errorTitle = '이미 가입한 휴대폰번호 입니다.';
      String errorContent = '가입한 계정을 찾거나 다른 휴대폰번호를 입력해주세요.';
      return AsyncValue.error(errorTitle + '||' + errorContent, StackTrace.empty);
    }
    else return AsyncValue.data(null);
  }

  Future<AsyncValue<void>> join() async {
    final result = await ref.read(accountRepositoryProvider).requestJoin(state);
    if(result != null) {
      return AsyncValue.error(result['message'], StackTrace.empty);
    }
    else return AsyncValue.data(null);
  }
}