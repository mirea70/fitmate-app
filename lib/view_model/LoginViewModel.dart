import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fitmate_app/config/Const.dart';
import 'package:fitmate_app/config/SecureStorage.dart';
import 'package:fitmate_app/repository/auth/AuthRepository.dart';
import 'package:fitmate_app/view/mate/MainView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'AccountJoinErrorViewModel.dart';

final loginViewModelProvider =
    NotifierProvider<LoginViewModel, LoginState>(() => LoginViewModel());

final loginAsyncProvider =
    AsyncNotifierProvider<LoginAsync, void>(() {
      return LoginAsync();
    });

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
  late AccountJoinErrorViewModel _errorViewModel;

  @override
  LoginState build() {
    _errorViewModel = ref.watch(accountJoinErrorViewModelProvider.notifier);
    return LoginState.initial();
  }

  void setLoginName(String value) {
    state = state.copyWith(loginName: value);
    _errorViewModel.validateLoginName(value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
    _errorViewModel.validatePassword(value);
  }

  Future<AsyncValue<void>> login(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ref.read(authRepositoryProvider).login(
            loginName: state.loginName,
            password: state.password,
          );

      final FlutterSecureStorage storage = ref.read(secureStorageProvider);
      await storage.write(key: accessTokenKey, value: response.accessToken);
      await storage.write(key: refreshTokenKey, value: response.refreshToken);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MainView(),
        ),
        (route) => false,
      );
      state = state.copyWith(isLoading: false);
      return AsyncValue.data(null);
    } on DioException catch (e) {
      return AsyncValue.error(e.response!.data['message'], StackTrace.empty);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    final FlutterSecureStorage storage = ref.read(secureStorageProvider);
    await Future.wait([
      storage.delete(key: accessTokenKey),
      storage.delete(key: refreshTokenKey),
    ]);
    state = state.copyWith(isLoading: false);
  }
}

class LoginAsync extends AsyncNotifier<void> {
  @override
  FutureOr<LoginState> build() {
    LoginState state = ref.watch(loginViewModelProvider);
    return state;
  }
}
