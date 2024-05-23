import 'package:fitmate_app/view/account/AccountJoinView2.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinErrorViewModel.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:fitmate_app/widget/CustomInputBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAppBar.dart';
import 'MateRegisterView2.dart';

class MateRegisterView1 extends ConsumerStatefulWidget {
  const MateRegisterView1({super.key});

  @override
  ConsumerState<MateRegisterView1> createState() => _MateRegisterView1State();
}

class _MateRegisterView1State extends ConsumerState<MateRegisterView1> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(accountJoinViewModelProvider.notifier);
    final viewModel = ref.watch(accountJoinViewModelProvider);
    final errorViewModel = ref.watch(accountJoinErrorViewModelProvider);
    final selectNumNotifier = ref.read(selectNumProvider.notifier);
    final selectNum = ref.watch(selectNumProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          resetViewModel: viewModelNotifier,
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 1,
          totalStep: 6,
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
                        padding: EdgeInsets.fromLTRB(deviceSize.width * 0.05, 0,
                            deviceSize.width * 0.05, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '운동 카테고리를 골라주세요',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.05,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  CustomInputBox(
                                    onTap: () {
                                      selectNumNotifier.setSelectNum(1);
                                    },
                                    index: 1,
                                    title: '헬스',
                                    imagePath: 'assets/images/fit_category1.png',
                                    deviceSize: deviceSize,
                                    selectNum: selectNum,
                                  ),
                                  SizedBox(
                                    height: deviceSize.height*0.02,
                                  ),
                                  CustomInputBox(
                                    onTap: () {
                                      selectNumNotifier.setSelectNum(2);
                                    },
                                    index: 2,
                                    title: '크로스핏',
                                    imagePath: 'assets/images/fit_category2.png',
                                    deviceSize: deviceSize,
                                    selectNum: selectNum,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Center(
                        child: CustomButton(
                          deviceSize: deviceSize,
                          onTapMethod: () async {
                            final validateResult = await viewModelNotifier
                                .validateDuplicatedLoginName();
                            validateResult.when(
                              data: (_) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MateRegisterView2())),
                              error: (error, stackTrace) => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    List<String> errorArr =
                                        '$error'.split('||');
                                    return CustomAlert(
                                        title: errorArr[0],
                                        content: errorArr[1],
                                        deviceSize: deviceSize);
                                  }),
                              loading: () => CircularProgressIndicator(),
                            );
                          },
                          title: '다음',
                          isEnabled: true,
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
}

final selectNumProvider =
    NotifierProvider<SelectNumNotifier, int>(() => SelectNumNotifier());

class SelectNumNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setSelectNum(int num) {
    state = num;
  }
}
