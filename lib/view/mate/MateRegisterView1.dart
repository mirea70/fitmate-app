import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
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
    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);
    final viewModel = ref.watch(mateRegisterViewModelProvider);
    final selectNumNotifier = ref.read(selectNumProvider.notifier);
    final selectNum = ref.watch(selectNumProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          resetViewModel: viewModelNotifier,
          onPressed: () {
            viewModelNotifier.reset();
            selectNumNotifier.reset();
            Navigator.pop(context);
          },
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 1,
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
                                      viewModelNotifier.setFitCategory(FitCategory.FITNESS);
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
                                      viewModelNotifier.setFitCategory(FitCategory.CROSSFIT);
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
                  onTapMethod: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MateRegisterView2()));
                  },
                  title: '다음',
                  isEnabled: viewModel.fitCategory != null,
                ),
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

  void reset() {
    state = 0;
  }
}
