import 'package:fitmate_app/view_model/AccountJoinErrorViewModel.dart';
import 'package:fitmate_app/view_model/AccountJoinViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'AccountJoinView3.dart';

class AccountJoinView2 extends StatelessWidget {
  const AccountJoinView2({super.key});

  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: devicePadding.top,
              ),
              Row(
                children: [
                  Container(
                    color: Colors.orangeAccent,
                    height: 6,
                    width: deviceSize.width / 4 * 2,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 6,
                    width: deviceSize.width / 4 * 2,
                  ),
                ],
              ),
              SizedBox(
                height: deviceSize.height * 0.01,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
              ),
              SizedBox(
                height: deviceSize.height * 0.1,
              ),
              Container(
                padding: EdgeInsets.only(left: deviceSize.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '비밀번호를 입력해주세요',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.01,
                    ),
                    Text(
                      '영문, 숫자, 특수문자를 포함해 8자리 이상으로 입력해주세요.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.1,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final viewModel =
                            ref.watch(accountJoinViewModelProvider.notifier);
                        final errorViewModel =
                            ref.watch(accountJoinErrorViewModelProvider);
                        return CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) => viewModel.setPassword(value),
                            hintText: '비밀번호를 입력해 주세요',
                            errorText: errorViewModel.accountJoinError.passwordError,
                        );
                      },
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.1,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final viewModel =
                        ref.watch(accountJoinViewModelProvider.notifier);
                        final errorViewModel =
                        ref.watch(accountJoinErrorViewModelProvider);
                        return CustomInput(
                          deviceSize: deviceSize,
                          onChangeMethod: (value) => errorViewModel.validateCheckPassword(viewModel.getPassword(), value),
                          hintText: '비밀번호를 한 번 더 입력해 주세요',
                          errorText: errorViewModel.accountJoinError.checkPasswordError,
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceSize.height * 0.2,
              ),
              Center(
                child: Consumer(
                  builder: (context, ref, child) {

                    final viewModel = ref.watch(accountJoinViewModelProvider.notifier);
                    final errorViewModel = ref.watch(accountJoinErrorViewModelProvider);
                    String pwd = viewModel.getPassword();
                    String? currentPwdError = errorViewModel.accountJoinError.passwordError;
                    String? checkPwdError = errorViewModel.accountJoinError.checkPasswordError;
                    return CustomButton(
                      deviceSize: deviceSize,
                      onTapMethod: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountJoinView3())),
                      title: '다음',

                      isEnabled: pwd != '' && currentPwdError == null && checkPwdError == null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
