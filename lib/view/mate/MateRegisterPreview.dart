import 'dart:io';

import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/view/mate/MainView.dart';
import 'package:fitmate_app/view/mate/MateRegisterView1.dart';
import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomIconButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MateRegisterPreview extends ConsumerStatefulWidget {
  const MateRegisterPreview({super.key});

  @override
  ConsumerState<MateRegisterPreview> createState() =>
      _MateRegisterPreviewState();
}

class _MateRegisterPreviewState extends ConsumerState<MateRegisterPreview> {
  int _currentImage = 0;

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    final viewModel = ref.watch(mateRegisterViewModelProvider);
    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);
    final fileViewModel = ref.watch(fileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF1F1F1),
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Color(0xffF1F1F1),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height * 1.2,
          width: double.maxFinite,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: deviceSize.height * 0.35,
                  width: deviceSize.width,
                  child: fileViewModel.files.isEmpty
                      ? Image.asset(
                          'assets/images/default_intro_image.jpg',
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(fileViewModel.files[_currentImage].path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                left: 10,
                top: deviceSize.height * 0.16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          if (fileViewModel.files.isNotEmpty) {
                            if (_currentImage > 0) {
                              _currentImage--;
                            } else {
                              // 이미지가 첫 번째일 때 이전 버튼을 누르면 마지막 이미지로 이동
                              _currentImage = fileViewModel.files.length - 1;
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: deviceSize.height * 0.16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          if (fileViewModel.files.isNotEmpty) {
                            if (_currentImage < fileViewModel.files.length - 1) {
                              _currentImage++;
                            } else {
                              // 이미지가 마지막일 때 다음 버튼을 누르면 첫 번째 이미지로 이동
                              _currentImage = 0;
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: deviceSize.height * 0.3,
                left: deviceSize.width * 0.04,
                child: Card(
                  elevation: 4,
                  child: Container(
                    height: deviceSize.height * 0.17,
                    width: deviceSize.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: deviceSize.height * 0.04),
                        child: Text(
                          viewModel.title,
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: deviceSize.height * 0.26,
                left: deviceSize.width * 0.44,
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/default_profile.jpeg',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, deviceSize.height * 0.01,
                            0, deviceSize.height * 0.01),
                        child: Text('하루'),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: deviceSize.height * 0.52,
                left: deviceSize.width * 0.17,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 20,
                    ),
                    SizedBox(
                      width: deviceSize.width * 0.02,
                    ),
                    Text(
                      formatDate(viewModel.mateAt!),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: deviceSize.width * 0.02,
                    ),
                    Icon(
                      Icons.group,
                      size: 20,
                    ),
                    SizedBox(
                      width: deviceSize.width * 0.02,
                    ),
                    Text(
                      '${viewModel.approvedAccountIds.length + 1}/${viewModel.permitPeopleCnt}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: deviceSize.height * 0.67,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.only(left: deviceSize.width * 0.05),
                  // child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '안내사항',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.01,
                        ),
                        Text(
                          '자세한 정보를 알려드릴게요',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.03,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.category_rounded,
                              size: 20,
                            ),
                            SizedBox(
                              width: deviceSize.width * 0.02,
                            ),
                            Text(
                              viewModel.fitCategory != null ? viewModel.fitCategory!.label : '미지정',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.group,
                              size: 20,
                            ),
                            SizedBox(
                              width: deviceSize.width * 0.02,
                            ),
                            Text(
                              '최대 ${viewModel.permitPeopleCnt}명 => ${viewModel.gatherType!.label}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money_rounded,
                              size: 20,
                            ),
                            SizedBox(
                              width: deviceSize.width * 0.02,
                            ),
                            Text(
                              viewModel.mateFees.isEmpty
                                  ? '무료'
                                  : '${viewModel.totalFee}원',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.compare_arrows_rounded,
                              size: 20,
                            ),
                            SizedBox(
                              width: deviceSize.width * 0.02,
                            ),
                            Text(
                              getTextPermitAges(viewModel.permitMinAge!,
                                  viewModel.permitMaxAge!),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 20,
                            ),
                            SizedBox(
                              width: deviceSize.width * 0.02,
                            ),
                            Text(
                              formatDate(viewModel.mateAt!),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: deviceSize.height * 0.003),
                              child: Icon(
                                Icons.place_rounded,
                                size: 20,
                              ),
                            ),
                            SizedBox(
                              width: deviceSize.width * 0.02,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${viewModel.fitPlaceName}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: deviceSize.width * 0.05),
                                    child: Text(
                                      '${viewModel.fitPlaceAddress}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      // overflow: TextOverflow.ellipsis,
                                      // maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xffF1F1F1),
        elevation: 0,
        child: Column(
          children: [
            Center(
              child: CustomButton(
                  deviceSize: deviceSize,
                  onTapMethod: () async {
                    final registerResult = await viewModelNotifier.register();

                    registerResult.when(
                        data: (_){
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MainView(),
                            ),
                                (route) => false,
                          );
                          viewModelNotifier.reset();
                          fileViewModel.reset();
                          ref.read(selectNumProvider.notifier).reset();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.orangeAccent,
                              content: Column(
                                children: [
                                  Text(
                                    '메이트 모집 등록이 완료되었습니다.',
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
                                    '운동 메이트와 함께하세요!',
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
                  title: '메이트 모집하기',
                  isEnabled: hasNotEmpty()),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    // 년, 월, 일 형식 지정
    String datePart = DateFormat('yy.M.d').format(dateTime);

    // 요일 형식 지정
    String weekdayPart = getKoreanWeekday(dateTime.weekday);

    // 오후/오전 형식 지정
    String amPmPart = dateTime.hour >= 12 ? '오후' : '오전';

    // 시간 형식 지정
    int hour = dateTime.hour % 12;
    if (hour == 0) hour = 12; // 0시를 12시로 변환
    String timePart = '$hour:${dateTime.minute.toString().padLeft(2, '0')}';

    // 최종 형식
    return '$datePart($weekdayPart) $amPmPart $timePart';
  }

  String getKoreanWeekday(int weekday) {
    const List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }

  String getTextPermitAges(int min, int max) {
    String result = '';
    if (min == 20) {
      if (max == 50)
        result = '모든 연령';
      else
        result = max.toString() + '세 이하';
    } else {
      if (max == 50)
        result = min.toString() + '세 이상';
      else
        result = min.toString() + ' ~ ' + max.toString() + '세';
    }
    return result;
  }

  bool hasNotEmpty() {
    final viewModel = ref.watch(mateRegisterViewModelProvider);
    // 비어있는지 체크
    if (viewModel.fitCategory == null || viewModel.fitCategory == FitCategory.undefined ||
        viewModel.title == '' ||
        viewModel.mateAt == null ||
        viewModel.fitPlaceName == '' ||
        viewModel.fitPlaceAddress == '' ||
        viewModel.gatherType == null || viewModel.gatherType == GatherType.undefined ||
        viewModel.permitGender == null ||
        viewModel.permitMaxAge == null ||
        viewModel.permitMinAge == null ||
        viewModel.permitPeopleCnt == null ||
        viewModel.applyQuestion == '') {
      return false;
    }
    return true;
  }
}
