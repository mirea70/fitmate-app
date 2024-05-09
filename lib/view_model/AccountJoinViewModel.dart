import 'package:fitmate_app/model/account/Account.dart';
import 'package:fitmate_app/view_model/AccountJoinErrorViewModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountJoinViewModelProvider = StateNotifierProvider<AccountJoinViewModel, Account>(
        (ref) {
          return AccountJoinViewModel(errorViewModelProvider: ref.watch(accountJoinErrorViewModelProvider));
        });

class AccountJoinViewModel extends StateNotifier<Account> {
  AccountJoinViewModel({required this.errorViewModelProvider}) : super((Account.initial()));
  final AccountJoinErrorViewModel errorViewModelProvider;

  void setLoginName(String value) {
    state = state.copyWith(loginName: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
    errorViewModelProvider.validatePassword(value);
  }

  String getPassword() {
    return state.password;
  }

  void setNickName(String value) {
    state = state.copyWith(nickName: value);
    errorViewModelProvider.validateNickName(value);
  }

  void setIntroduction(String value) {
    state = state.copyWith(introduction: value);
  }

  void setName(String value) {
    state = state.copyWith(name: value);
    errorViewModelProvider.validateName(value);
  }

  void setPhone(String value) {
    state = state.copyWith(phone: value);
    errorViewModelProvider.validatePhone(value);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
    errorViewModelProvider.validateEmail(value);
  }

  void setGender(String value) {
    state = state.copyWith(gender: value);
  }

  void setProfileImageId(int value) {
    state = state.copyWith(profileImageId: value);
  }
}