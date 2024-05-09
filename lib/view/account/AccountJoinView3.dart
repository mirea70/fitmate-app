import 'package:fitmate_app/view/account/AccountJoinView2.dart';
import 'package:fitmate_app/view_model/AccountJoinViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:fitmate_app/widget/CustomInputWithButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountJoinView3 extends StatelessWidget {
  const AccountJoinView3({super.key});

  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final isCheckPhoneInputProvider = StateProvider((ref) => false);

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
                    width: deviceSize.width / 4 * 3,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 6,
                    width: deviceSize.width / 4 * 1,
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
                      '휴대 전화번호를 인증해 주세요',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.01,
                    ),
                    Text(
                      '신뢰할 수 있는 커뮤니티를 위해 전화번호 인증이 필요해요.',
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
                        return CustomInputWithButton(
                          deviceSize: deviceSize,
                          onChangeMethod: (value) =>
                              viewModel.setPhone(value),
                          hintText: '010-0000-0000',
                          onPressMethod: (){},
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final viewModel =
                        ref.watch(accountJoinViewModelProvider.notifier);
                        return CustomInputWithButton(
                          deviceSize: deviceSize,
                          onChangeMethod: (value) =>
                              viewModel.setPhone(value),
                          hintText: '인증번호 6자리를 입력해주세요.',
                          onPressMethod: (){},
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceSize.height * 0.35,
              ),
              Center(
                child: Consumer(
                  builder: (context, ref, child) {
                    final viewModel = ref.watch(accountJoinViewModelProvider);
                    return CustomButton(
                      deviceSize: deviceSize,
                      onTapMethod: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountJoinView2())),
                      title: '다음',
                      isEnabled: viewModel.loginName != '',
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
