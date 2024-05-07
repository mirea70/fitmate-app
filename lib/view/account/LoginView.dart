import 'package:fitmate_app/view/account/AccountFindView.dart';
import 'package:fitmate_app/view/account/AccountJoinView1.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: deviceSize.height * 0.1,
          ),
          Container(
            padding: EdgeInsets.only(left: deviceSize.width * 0.05),
            child: Text(
              'FITMATE',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 25,
                fontWeight: FontWeight.bold,
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
                        padding: EdgeInsets.only(left: deviceSize.width * 0.03),
                        child: CustomInputTitle('아이디'),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final viewModel =
                              ref.watch(loginViewModelProvider.notifier);
                          return CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) =>
                                viewModel.setLoginName(value),
                          );
                        },
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
                        padding: EdgeInsets.only(left: deviceSize.width * 0.03),
                        child: CustomInputTitle('비밀번호'),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final viewModel =
                              ref.watch(loginViewModelProvider.notifier);
                          return CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) =>
                                viewModel.setPassword(value),
                          );
                        },
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
          Consumer(
            builder: (context, ref, child) {
              final viewModel = ref.watch(loginViewModelProvider.notifier);
              return Center(
                child: CustomButton(
                  deviceSize: deviceSize,
                  onTapMethod: () => viewModel.login(context),
                ),
              );
            },
          ),
          SizedBox(
            height: deviceSize.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextButton('계정정보를 잊으셨나요?', AccountFindView()),
              CustomTextButton('회원가입하기', AccountJoinView1()),
            ],
          )
        ],
      ),
    );
  }
}
