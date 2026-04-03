import 'package:fitmate_app/view/account/AccountFindView.dart';
import 'package:fitmate_app/view/account/AccountJoinView1.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinErrorViewModel.dart';
import 'package:fitmate_app/view_model/account/login/LoginViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:fitmate_app/widget/CustomInputTitle.dart';
import 'package:fitmate_app/widget/CustomTextButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAlert.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.sizeOf(context);
    final viewModelNotifier = ref.read(loginViewModelProvider.notifier);

    final canPop = Navigator.of(context).canPop();

    return PopScope(
      canPop: canPop,
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: canPop
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              )
            : null,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: deviceSize.height * 0.1,
              ),
              Container(
                padding: EdgeInsets.only(left: deviceSize.width * 0.05),
                child: const Text(
                  'FitMate',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 30,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: deviceSize.height * 0.05,
              ),
              Center(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: deviceSize.width * 0.03),
                          child: CustomInputTitle('아이디'),
                        ),
                        const SizedBox(height: 7),
                        CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) =>
                                viewModelNotifier.setLoginName(value),
                            hintText: '아이디를 입력해주세요.',
                          text: '',
                        )
                      ],
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: deviceSize.width * 0.03),
                          child: CustomInputTitle('비밀번호'),
                        ),
                        const SizedBox(height: 7),
                        CustomInput(
                          deviceSize: deviceSize,
                          onChangeMethod: (value) =>
                              viewModelNotifier.setPassword(value),
                          hintText: '비밀번호를 입력해주세요',
                          text: '',
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceSize.height * 0.03,
              ),
              // 로그인 버튼만 상태 변화를 감시
              Center(child: _LoginButton(deviceSize: deviceSize)),
              SizedBox(
                height: deviceSize.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextButton(
                    title: '계정정보를 잊으셨나요?',
                    onPressed: () {
                      ref.read(accountJoinErrorViewModelProvider.notifier).reset();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountFindView()),
                      );
                    },
                  ),
                  CustomTextButton(
                      title: '회원가입하기',
                      onPressed: () {
                        ref.read(accountJoinErrorViewModelProvider.notifier).reset();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountJoinView1()),
                        );
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    ),
    );
  }
}

/// 로그인 버튼만 독립적으로 상태를 감시하여 리빌드
class _LoginButton extends ConsumerWidget {
  final Size deviceSize;
  const _LoginButton({required this.deviceSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(loginViewModelProvider);
    final errorViewModel = ref.watch(accountJoinErrorViewModelProvider);
    final viewModelNotifier = ref.read(loginViewModelProvider.notifier);

    return CustomButton(
      deviceSize: deviceSize,
      onTapMethod: () async {
        final result = await viewModelNotifier.login(context);
        result.when(
          data: (_){},
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) =>
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomAlert(
                      title: '$error',
                      deviceSize: deviceSize);
                }),
        );
      },
      title: '로그인',
      isEnabled: viewModel.loginName != '' &&
          viewModel.password != '' &&
          errorViewModel.loginNameError == null &&
          errorViewModel.passwordError == null,
    );
  }
}
