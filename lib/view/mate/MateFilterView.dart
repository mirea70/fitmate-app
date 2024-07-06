import 'package:fitmate_app/model/mate/MateListRequestModel.dart';
import 'package:fitmate_app/view_model/mate/MateListRequestViewModel.dart';
import 'package:fitmate_app/widget/CustomInputCalendar.dart';
import 'package:fitmate_app/widget/CustomMultiInputCalendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MateFilterView extends ConsumerStatefulWidget {
  const MateFilterView({super.key});

  @override
  ConsumerState<MateFilterView> createState() => _MateFilterViewState();
}

class _MateFilterViewState extends ConsumerState<MateFilterView> {
  int dayInputIdx = 0;
  int dayOfWeekIdx = -1;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   initializeDateFormatting('ko_KR', '');
  // }

@override
  Widget build(BuildContext context) {
  final Size deviceSize = MediaQuery.of(context).size;
  final viewModel = ref.watch(mateListRequestViewModelProvider);
  final viewModelNotifier = ref.read(mateListRequestViewModelProvider.notifier);
  
    return SingleChildScrollView(
      child: Container(
        height: deviceSize.height * 1.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: deviceSize.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {

                  },
                  child: Row(
                    children: [
                      Text(
                        '재설정',
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                      Icon(
                        Icons.refresh,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: deviceSize.width * 0.26,
                ),
                Text(
                  '필터',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                Expanded(child: SizedBox()),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                )
              ],
            ),
            SizedBox(
              height: deviceSize.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(left: deviceSize.width * 0.03),
              child: Text(
                '날짜',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: deviceSize.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      dayInputIdx != 1 ? dayInputIdx = 1 : dayInputIdx = 0;
                    });
                  },
                  child: Container(
                    height: deviceSize.height * 0.05,
                    width: deviceSize.width * 0.47,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: dayInputIdx != 1 ? Color(0xffE8E8E8) : Colors.orangeAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '요일 선택',
                        style: TextStyle(
                          fontSize: 18,
                          color: dayInputIdx != 1 ? Colors.black : Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      dayInputIdx != 2 ? dayInputIdx = 2 : dayInputIdx = 0;
                      dayOfWeekIdx = -1;
                    });
                  },
                  child: Container(
                    height: deviceSize.height * 0.05,
                    width: deviceSize.width * 0.47,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: dayInputIdx != 2 ? Color(0xffE8E8E8) : Colors.orangeAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '날짜 선택',
                        style: TextStyle(
                          fontSize: 18,
                          color: dayInputIdx != 2 ? Colors.black : Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if(dayInputIdx == 1)
              Padding(
                padding: EdgeInsets.fromLTRB(deviceSize.width * 0.03,0,deviceSize.width * 0.03,0),
                child: Column(
                  children: [
                    SizedBox(
                      height: deviceSize.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              dayOfWeekIdx != 0 ? dayOfWeekIdx = 0 : dayOfWeekIdx = -1;
                            });
                            viewModelNotifier.setDayOfWeek(0);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (dayOfWeekIdx != 0) ? Colors.white : Colors.orangeAccent,
                              shape: BoxShape.circle,
                              border: (dayOfWeekIdx != 0)
                                  ? Border.all(color: Color(0xffE8E8E8), width: 1.5,)
                                  : null,
                            ),
                            child: Text(
                              '일',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: (dayOfWeekIdx != 0) ? Colors.grey : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              dayOfWeekIdx != 1 ? dayOfWeekIdx = 1 : dayOfWeekIdx = -1;
                            });
                            viewModelNotifier.setDayOfWeek(1);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (dayOfWeekIdx != 1) ? Colors.white : Colors.orangeAccent,
                              shape: BoxShape.circle,
                              border: (dayOfWeekIdx != 1)
                                  ? Border.all(color: Color(0xffE8E8E8), width: 1.5,)
                                  : null,
                            ),
                            child: Text(
                              '월',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: (dayOfWeekIdx != 1) ? Colors.grey : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              dayOfWeekIdx != 2 ? dayOfWeekIdx = 2 : dayOfWeekIdx = -1;
                            });
                            viewModelNotifier.setDayOfWeek(2);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (dayOfWeekIdx != 2) ? Colors.white : Colors.orangeAccent,
                              shape: BoxShape.circle,
                              border: (dayOfWeekIdx != 2)
                                  ? Border.all(color: Color(0xffE8E8E8), width: 1.5,)
                                  : null,
                            ),
                            child: Text(
                              '화',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: (dayOfWeekIdx != 2) ? Colors.grey : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              dayOfWeekIdx != 3 ? dayOfWeekIdx = 3 : dayOfWeekIdx = -1;
                            });
                            viewModelNotifier.setDayOfWeek(3);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (dayOfWeekIdx != 3) ? Colors.white : Colors.orangeAccent,
                              shape: BoxShape.circle,
                              border: (dayOfWeekIdx != 3)
                                  ? Border.all(color: Color(0xffE8E8E8), width: 1.5,)
                                  : null,
                            ),
                            child: Text(
                              '수',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: (dayOfWeekIdx != 3) ? Colors.grey : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              dayOfWeekIdx != 4 ? dayOfWeekIdx = 4 : dayOfWeekIdx = -1;
                            });
                            viewModelNotifier.setDayOfWeek(4);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (dayOfWeekIdx != 4) ? Colors.white : Colors.orangeAccent,
                              shape: BoxShape.circle,
                              border: (dayOfWeekIdx != 4)
                                  ? Border.all(color: Color(0xffE8E8E8), width: 1.5,)
                                  : null,
                            ),
                            child: Text(
                              '목',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: (dayOfWeekIdx != 4) ? Colors.grey : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              dayOfWeekIdx != 5 ? dayOfWeekIdx = 5 : dayOfWeekIdx = -1;
                            });
                            viewModelNotifier.setDayOfWeek(5);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (dayOfWeekIdx != 5) ? Colors.white : Colors.orangeAccent,
                              shape: BoxShape.circle,
                              border: (dayOfWeekIdx != 5)
                                  ? Border.all(color: Color(0xffE8E8E8), width: 1.5,)
                                  : null,
                            ),
                            child: Text(
                              '금',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: (dayOfWeekIdx != 5) ? Colors.grey : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              dayOfWeekIdx != 6 ? dayOfWeekIdx = 6 : dayOfWeekIdx = -1;
                            });
                            viewModelNotifier.setDayOfWeek(6);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (dayOfWeekIdx != 6) ? Colors.white : Colors.orangeAccent,
                              shape: BoxShape.circle,
                              border: (dayOfWeekIdx != 6)
                                  ? Border.all(color: Color(0xffE8E8E8), width: 1.5,)
                                  : null,
                            ),
                            child: Text(
                              '토',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: (dayOfWeekIdx != 6) ? Colors.grey : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            if(dayInputIdx == 2)
              Column(
                children: [
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  Container(
                    child: CustomMultiInputCalendar(
                      initDay: DateTime.now(),
                      onRangeSelected: (startAt, endAt) {
                        viewModelNotifier.setMateAt(startAt, endAt);
                      },
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: deviceSize.height * 0.08,
            ),
            Padding(
              padding: EdgeInsets.only(left: deviceSize.width * 0.03),
              child: Text(
                '지역',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: deviceSize.height * 0.03,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(deviceSize.width * 0.03, 0, deviceSize.width * 0.03, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [

                        ],
                      ),
                    ],
                  ),
                )
            ),
            SizedBox(
              height: deviceSize.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.only(left: deviceSize.width * 0.03),
              child: Text(
                '나이',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  RangeSlider(
                    values: RangeValues(viewModel.permitMinAge!.toDouble(), viewModel.permitMaxAge!.toDouble()),
                    min: 20,
                    max: 50,
                    divisions: 6,
                    onChanged: (value) {
                      viewModelNotifier.setPermitMinAge(value.start.toInt());
                      viewModelNotifier.setPermitMaxAge(value.end.toInt());
                    },
                    activeColor: Colors.orangeAccent,
                    inactiveColor: Color(0xffE8E8E8),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(deviceSize.width * 0.02, 0, deviceSize.width * 0.02, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('~20'),
                        Text('25'),
                        Text('30'),
                        Text('35'),
                        Text('40'),
                        Text('45'),
                        Text('50~'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceSize.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.only(left: deviceSize.width * 0.03),
              child: Text(
                '정원',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: deviceSize.height * 0.02,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Radio(
                            value: 3 + 50,
                            groupValue: viewModel.startLimitPeopleCnt! + viewModel.endLimitPeopleCnt!,
                            onChanged: (value) {
                              viewModelNotifier.setLimitPeopleCnt(3, 50);
                            },
                            activeColor: Colors.orangeAccent,
                        ),
                      ),
                      Text(
                        '전체',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: deviceSize.width * 0.25,
                      ),
                      Transform.scale(
                        scale: 1.3,
                        child: Radio(
                          value: 3 + 10,
                          groupValue: viewModel.startLimitPeopleCnt! + viewModel.endLimitPeopleCnt!,
                          onChanged: (value) {
                            viewModelNotifier.setLimitPeopleCnt(3, 10);
                          },
                          activeColor: Colors.orangeAccent,
                        ),
                      ),
                      Text(
                        '3~10명',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Radio(
                          value: 11 + 30,
                          groupValue: viewModel.startLimitPeopleCnt! + viewModel.endLimitPeopleCnt!,
                          onChanged: (value) {
                            viewModelNotifier.setLimitPeopleCnt(11, 30);
                          },
                          activeColor: Colors.orangeAccent,
                        ),
                      ),
                      Text(
                        '11~30명',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: deviceSize.width * 0.16,
                      ),
                      Transform.scale(
                        scale: 1.3,
                        child: Radio(
                          value: 31 + 50,
                          groupValue: viewModel.startLimitPeopleCnt! + viewModel.endLimitPeopleCnt!,
                          onChanged: (value) {
                            viewModelNotifier.setLimitPeopleCnt(31, 50);
                          },
                          activeColor: Colors.orangeAccent,
                        ),
                      ),
                      Text(
                        '31~50명',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceSize.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.only(left: deviceSize.width * 0.03),
              child: Text(
                '카테고리',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: deviceSize.height * 0.02,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Radio(
                          value: FitCategory.undefined,
                          groupValue: viewModel.fitCategory,
                          onChanged: (value) {
                            viewModelNotifier.setFitCategory(value!);
                          },
                          activeColor: Colors.orangeAccent,
                        ),
                      ),
                      Text(
                        '전체',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: deviceSize.width * 0.25,
                      ),
                      Transform.scale(
                        scale: 1.3,
                        child: Radio(
                          value: FitCategory.FITNESS,
                          groupValue: viewModel.fitCategory,
                          onChanged: (value) {
                            viewModelNotifier.setFitCategory(value!);
                          },
                          activeColor: Colors.orangeAccent,
                        ),
                      ),
                      Text(
                        '헬스',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Radio(
                          value: FitCategory.CROSSFIT,
                          groupValue: viewModel.fitCategory,
                          onChanged: (value) {
                            viewModelNotifier.setFitCategory(value!);
                          },
                          activeColor: Colors.orangeAccent,
                        ),
                      ),
                      Text(
                        '크로스핏',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: deviceSize.width * 0.16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum RangePeople {
  ALL,
  THREE_TEN,
  ELEVEN_THIRTY,
  THIRTY_FIFTEEN,
}
