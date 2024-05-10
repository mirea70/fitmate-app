import 'package:fitmate_app/view/mate/MainView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
        () => LoginViewModel());

class LoginState {
  String loginName;
  String password;
  bool isLoading;

  LoginState({
    required this.loginName,
    required this.password,
    required this.isLoading,
  });

  factory LoginState.initial() {
    return LoginState(
      loginName: '',
      password: '',
      isLoading: false,
    );
  }

  LoginState copyWith({String? loginName, String? password, bool? isLoading}) {
    return LoginState(
      loginName: loginName ?? this.loginName,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {

  @override
  LoginState build() {
    return LoginState.initial();
  }

  void setLoginName(String value) {
    state = state.copyWith(loginName: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  Future<void> login(BuildContext context) async {
    //TODO 로그인 로직 구현
    await Future.delayed(Duration(seconds: 2));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainView(),
      ),
    );
  }
}
