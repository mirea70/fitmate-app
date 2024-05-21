import 'package:fitmate_app/model/account/Account.dart';
import 'package:fitmate_app/view/mate/MainView.dart';
import 'package:fitmate_app/view_model/AccountJoinViewModel.dart';
import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:fitmate_app/widget/CustomAppBar.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:fitmate_app/widget/CustomInputMiddle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view_model/AccountJoinErrorViewModel.dart';
import '../../widget/CustomAlert.dart';

class AccountJoinView4 extends ConsumerStatefulWidget {
  const AccountJoinView4({super.key});

  @override
  ConsumerState<AccountJoinView4> createState() => _AccountJoinView1State();
}

class _AccountJoinView1State extends ConsumerState<AccountJoinView4> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;

    final viewModelNotifier = ref.read(accountJoinViewModelProvider.notifier);
    final viewModel = ref.watch(accountJoinViewModelProvider);
    final errorViewModel = ref.watch(accountJoinErrorViewModelProvider);
    final fileViewModel = ref.watch(fileViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 4,
        ),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: constraint.maxHeight,
                    minWidth: constraint.maxWidth),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: deviceSize.width * 0.8,
                          height: deviceSize.height * 0.05,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orangeAccent,
                          ),
                          child: Text(
                            '이제, 프로필만 작성하면 가입 완료!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: deviceSize.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: deviceSize.height * 0.07,
                            ),
                            Text(
                              '이름',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.01,
                            ),
                            CustomInput(
                              deviceSize: deviceSize,
                              onChangeMethod: (value) =>
                                  viewModelNotifier.setName(value),
                              hintText: '홍길동',
                              errorText: errorViewModel.getNameError(),
                              maxLength: 5,
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.07,
                            ),
                            Text(
                              '성별',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: deviceSize.width * 0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    value: Gender.MALE,
                                    activeColor: Colors.orangeAccent,
                                    groupValue: viewModel.gender,
                                    onChanged: (value) {
                                      viewModelNotifier.setGender(value);
                                    },
                                  ),
                                  Text(
                                    '남성',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: deviceSize.width * 0.2,
                                  ),
                                  Radio(
                                    value: Gender.FEMALE,
                                    activeColor: Colors.orangeAccent,
                                    groupValue: viewModel.gender,
                                    onChanged: (value) {
                                      viewModelNotifier.setGender(value);
                                    },
                                  ),
                                  Text(
                                    '여성',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.07,
                            ),
                            Text(
                              '이메일',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.01,
                            ),
                            CustomInput(
                              deviceSize: deviceSize,
                              onChangeMethod: (value) =>
                                  viewModelNotifier.setEmail(value),
                              hintText: 'abc@naver.com',
                              errorText: errorViewModel.getEmailError(),
                              maxLength: 30,
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.07,
                            ),
                            Text(
                              '닉네임',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.01,
                            ),
                            CustomInput(
                              deviceSize: deviceSize,
                              onChangeMethod: (value) =>
                                  viewModelNotifier.setNickName(value),
                              hintText: '가지',
                              errorText: errorViewModel.getNickNameError(),
                              maxLength: 10,
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.07,
                            ),
                            Text(
                              '간단 자기소개',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.01,
                            ),
                            CustomInputMiddle(
                              deviceSize: deviceSize,
                              onChangeMethod: (value) =>
                                  viewModelNotifier.setIntroduction(value),
                              hintText: '안녕하세요...',
                              maxLength: 50,
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.02,
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Center(
                        child: CustomButton(
                          deviceSize: deviceSize,
                          onTapMethod: () async {
                            final joinResult = await viewModelNotifier.join();
                            joinResult.when(
                              data: (_) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => MainView(),
                                  ),
                                  (route) => false,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.orangeAccent,
                                    content: Column(
                                      children: [
                                        Text(
                                            '환영합니다!',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: deviceSize.height*0.02,
                                        ),
                                        Text(
                                          '지금 바로 운동 메이트를 만나보세요!',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              error: (error, stackTrace) => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlert(
                                        title: '$error',
                                        deviceSize: deviceSize);
                                  }),
                              loading: () => CircularProgressIndicator(),
                            );
                          },
                          title: '가입하기',
                          isEnabled: hasNotError(),
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
          },
        ),
      ),
    );
  }

  bool hasNotError() {
    final viewModel = ref.watch(accountJoinViewModelProvider);
    final errorViewModel = ref.watch(accountJoinErrorViewModelProvider);
    // 비어있는지 체크
    if (viewModel.loginName == '' ||
        viewModel.password == '' ||
        viewModel.nickName == '' ||
        viewModel.name == '' ||
        viewModel.phone == '' ||
        viewModel.email == '' ||
        viewModel.gender == '') {
      return false;
    }
    // 에러 체크
    if (errorViewModel.getLoginNameError() != null ||
        errorViewModel.getPasswordError() != null ||
        errorViewModel.getNickNameError() != null ||
        errorViewModel.getNameError() != null ||
        errorViewModel.getPhoneError() != null ||
        errorViewModel.getEmailError() != null) {
      return false;
    }
    return true;
  }
}
