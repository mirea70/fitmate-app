import 'package:fitmate_app/view_model/account/join/AccountJoinErrorViewModel.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAppBar.dart';
import 'AccountJoinView3.dart';



class AccountJoinView2 extends ConsumerStatefulWidget {
  const AccountJoinView2({super.key});

  @override
  ConsumerState<AccountJoinView2> createState() => _AccountJoinView2State();
}

class _AccountJoinView2State extends ConsumerState<AccountJoinView2> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModel = ref.watch(accountJoinViewModelProvider);
    final errorViewModel = ref.watch(accountJoinErrorViewModelProvider);

    String? currentPwdError = errorViewModel.getPasswordError();
    String? checkPwdError = errorViewModel.getCheckPasswordError();

    final checkPasswordStateNotifier = ref.read(checkPasswordStateProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 2,
          totalStep: 4,
        ),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: deviceSize.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '비밀번호를 입력해주세요',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: deviceSize.height * 0.01,
                          ),
                          Text(
                            '영문 대문자, 소문자, 숫자, 특수문자를 각각 하나 이상 포함해 8자리 이상으로 입력해주세요.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: deviceSize.height * 0.1,
                          ),
                          CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) => ref.read(accountJoinViewModelProvider.notifier).setPassword(value),
                            hintText: '비밀번호를 입력해 주세요',
                            errorText:
                                errorViewModel.getPasswordError(),
                            maxLength: 20,
                          ),
                          SizedBox(
                            height: deviceSize.height * 0.1,
                          ),
                          CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) {
                                ref.read(accountJoinErrorViewModelProvider.notifier).validateCheckPassword(
                                    viewModel.password, value);
                                checkPasswordStateNotifier.state = value;
                            },
                            hintText: '비밀번호를 한 번 더 입력해 주세요',
                            errorText:
                                errorViewModel.getCheckPasswordError(),
                            maxLength: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Center(
                      child: CustomButton(
                        deviceSize: deviceSize,
                        onTapMethod: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountJoinView3())),
                        title: '다음',
                        isEnabled: viewModel.password != '' && ref.watch(checkPasswordStateProvider) != '' &&
                            currentPwdError == null &&
                            checkPwdError == null,
                      ),
                    ),
                    SizedBox(
                      height: devicePadding.bottom + deviceSize.height * 0.03,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
