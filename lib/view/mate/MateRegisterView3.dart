import 'package:fitmate_app/error/CustomException.dart';
import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:fitmate_app/widget/CustomInputLarge.dart';
import 'package:fitmate_app/widget/CustomInputMultiImage.dart';
import 'package:fitmate_app/widget/CustomViewImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAppBar.dart';
import 'MateRegisterView4.dart';

class MateRegisterView3 extends ConsumerStatefulWidget {
  const MateRegisterView3({super.key});

  @override
  ConsumerState<MateRegisterView3> createState() => _MateRegisterView3State();
}

class _MateRegisterView3State extends ConsumerState<MateRegisterView3> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);
    final viewModel = ref.watch(mateRegisterViewModelProvider);
    final fileViewModel = ref.watch(fileViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 3,
          totalStep: 7,
        ),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                ),
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
                              '일정에 대해 소개해봐요!',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.05,
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomInputMultiImage(
                                    deviceSize: deviceSize,
                                  ),
                                  SizedBox(
                                    width: deviceSize.width * 0.02,
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: fileViewModel.files.length,
                                      itemBuilder: (context, index) {
                                        return CustomViewImage(
                                          deviceSize: deviceSize,
                                          index: index,
                                          fileViewModel: fileViewModel,
                                        );
                                      },
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          width: deviceSize.width * 0.02,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.02,
                            ),
                            CustomInput(
                              deviceSize: deviceSize,
                              onChangeMethod: (value) {
                                viewModelNotifier.setTitle(value);
                              },
                              hintText: '제목을 입력해 주세요',
                              text: viewModel.title,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: deviceSize.width * 0.02),
                              child: Text(
                                '예시 : 아침헬스 함께 가실 분!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.02,
                            ),
                            CustomInputLarge(
                              deviceSize: deviceSize,
                              onChangeMethod: (value) {
                                viewModelNotifier.setIntroduction(value);
                              },
                              hintText: '소개글을 입력해 주세요 (선택)',
                              text: viewModel.introduction,
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
                        viewModelNotifier.validateTitle(viewModel.title);
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
                              builder: (context) =>
                                  MateRegisterView4()));
                    },
                    title: '다음',
                    isEnabled: viewModel.title.length >= 5),
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
