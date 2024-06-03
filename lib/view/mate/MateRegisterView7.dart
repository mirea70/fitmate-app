import 'package:fitmate_app/error/CustomException.dart';
import 'package:fitmate_app/view/account/AccountJoinView2.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinErrorViewModel.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAppBar.dart';
import 'MateRegisterPreview.dart';
import 'MateRegisterView3.dart';

class MateRegisterView7 extends ConsumerStatefulWidget {
  const MateRegisterView7({super.key});

  @override
  ConsumerState<MateRegisterView7> createState() => _MateRegisterView7State();
}

class _MateRegisterView7State extends ConsumerState<MateRegisterView7> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);
    final viewModel = ref.watch(mateRegisterViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 7,
          totalStep: 7,
        ),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraint) {
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
                              '참여자에게 궁금한 점을 질문해봐요',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.01,
                            ),
                            Text(
                              '5~20자의 한글 및 특수문자 ?, !, ~ 만 입력 가능합니다.',
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
                              onChangeMethod: (value) {
                                viewModelNotifier.setApplyQuestion(value);
                              },
                              hintText: '주 운동루틴은?',
                              maxLength: 20,
                              text: viewModel.applyQuestion,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          child: Column(
            children: [
              Center(
                child: CustomButton(
                    deviceSize: deviceSize,
                    onTapMethod: () {
                      try {
                        viewModelNotifier.validateApplyQuestion(viewModel.applyQuestion);
                      } on CustomException catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlert(
                              title: e.msg,
                              deviceSize: deviceSize,
                            );
                          },
                        );
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MateRegisterPreview()));
                    },
                    title: '미리보기',
                    isEnabled: viewModel.applyQuestion.length >= 5),
              ),
              // SizedBox(
              //   height:
              //   devicePadding.bottom + deviceSize.height * 0.03,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
