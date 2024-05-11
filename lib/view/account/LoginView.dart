import 'package:fitmate_app/view/account/AccountFindView.dart';
import 'package:fitmate_app/view/account/AccountJoinView1.dart';
import 'package:fitmate_app/view_model/AccountJoinErrorViewModel.dart';
import 'package:fitmate_app/view_model/LoginViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:fitmate_app/widget/CustomInputTitle.dart';
import 'package:fitmate_app/widget/CustomTextButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(loginViewModelProvider.notifier);
    final errorViewModel = ref.watch(accountJoinErrorViewModelProvider);
    final viewModel = ref.watch(loginViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
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
                child: Text(
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
                child: Container(
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
                          SizedBox(
                            height: 7,
                          ),
                          CustomInput(
                              deviceSize: deviceSize,
                              onChangeMethod: (value) =>
                                  viewModelNotifier.setLoginName(value),
                              hintText: '아이디를 입력해주세요.')
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
                          SizedBox(
                            height: 7,
                          ),
                          CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) =>
                                viewModelNotifier.setPassword(value),
                            hintText: '비밀번호를 입력해주세요',
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: deviceSize.height * 0.03,
              ),
              Center(
                child: CustomButton(
                  deviceSize: deviceSize,
                  onTapMethod: () => viewModelNotifier.login(context),
                  title: '로그인',
                  isEnabled: viewModel.loginName != '' && viewModel.password != '' &&
                  errorViewModel.getLoginNameError() == null && errorViewModel.getPasswordError() == null,
                ),
              ),
              SizedBox(
                height: deviceSize.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextButton(
                      title: '계정정보를 잊으셨나요?',
                      onPressed: () {
                        errorViewModel.reset();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AccountFindView()),
                        );
                      },
                  ),
                  CustomTextButton(
                      title: '회원가입하기',
                      onPressed: () {
                        errorViewModel.reset();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AccountJoinView1()),
                        );
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
