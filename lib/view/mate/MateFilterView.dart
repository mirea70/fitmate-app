import 'package:fitmate_app/error/CustomException.dart';
import 'package:fitmate_app/model/common/Region.dart';
import 'package:fitmate_app/model/mate/MateListRequestModel.dart';
import 'package:fitmate_app/view_model/mate/MateListRequestViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
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
  List<Region> _defaultRegions = [];
  int selectRegionIdx = -1;
  List<String> _expandRegions = [];
  int _expandStartIdx = -1;
  int _expandEndIdx = -1;

  @override
  void initState() {
    super.initState();

    // 지역 초기화
    Region seoul = Region('서울',
      ['서울 전체', '강남', '강동', '강북',
      '강서', '관악', '광진', '구로',
      '금천', '노원', '도봉', '동대문',
      '동작', '마포', '서대문', '서초',
      '성동', '성북', '성북', '송파',
      '양천', '영등포', '용산', '은평',
      '종로', '중구', '중랑']
    );
    _defaultRegions.add(seoul);

    Region geongi = Region('경기',
        ['경기 전체', '수원', '성남', '고양',
          '용인', '부천', '안산', '안양',
          '남양주', '화성', '의정부', '시흥',
          '평택', '광명', '파주', '군포',
          '광주', '김포', '이천', '양주',
          '구리', '오산', '안성', '의왕',
          '하남', '포천', '동두천', '과천',
          '여주', '양평', '가평', '연천']
    );
    _defaultRegions.add(geongi);

    Region inchon = Region('인천',
        ['인천 전체', '중구', '동구', '미추홀',
          '연수', '남동', '부평', '계양',
          '서구', '강화', '웅진']
    );
    _defaultRegions.add(inchon);

    Region gangwon = Region('강원',
        ['강원 전체', '춘천', '인제', '양구',
          '고성', '양양', '강릉', '속초',
          '삼척', '정선', '평창', '영월',
          '원주', '횡성', '홍천', '화천',
          '철원', '동해', '태백']
    );
    _defaultRegions.add(gangwon);

    Region choongbook = Region('충북',
        ['충북 전체', '청주', '충주', '제천',
          '보은', '옥천', '영동', '증평',
          '진천', '괴산', '음성', '단양']
    );
    _defaultRegions.add(choongbook);

    Region choongnam = Region('충남',
        ['충남 전체', '천안', '공주', '보령',
          '아산', '서산', '논산', '계룡',
          '당진', '금산', '부여', '서천',
          '청양', '홍성', '예산', '태안']
    );
    _defaultRegions.add(choongnam);

    Region sezong = Region('세종',
        ['세종 전체', '조치원', '연기', '연동',
          '부강', '금남', '장군', '연서',
          '전의', '전동', '소정', '한솔',
          '새롬', '도담', '아름', '종촌',
          '고운', '소담', '보람', '대평',
          '다정', '해밀', '반곡']
    );
    _defaultRegions.add(sezong);

    Region daejeon = Region('대전',
        ['대전 전체', '동구', '중구', '서구',
          '유성', '대덕']
    );
    _defaultRegions.add(daejeon);

    Region gwangjoo = Region('광주',
        ['광주 전체', '동구', '서구', '남구',
          '북구', '광산']
    );
    _defaultRegions.add(gwangjoo);

    Region jeonbook = Region('전북',
        ['전북 전체', '전주', '익산', '군산',
          '정읍', '남원', '김제', '완주',
          '고창', '부안', '임실', '순창',
          '진안', '무주', '장수']
    );
    _defaultRegions.add(jeonbook);

    Region geongbook = Region('경북',
        ['경북 전체', '포항', '경주', '김천',
          '안동', '구미', '영주', '영천',
          '상주', '문경', '경산', '군위',
          '의성', '청송', '영양', '영덕',
          '청도', '고령', '성주', '칠곡',
          '예천', '봉화', '울진', '울릉']
    );
    _defaultRegions.add(geongbook);

    Region daeggoo = Region('대구',
        ['대구 전체', '중구', '동구', '서구',
          '남구', '북구', '수성', '달서',
          '달성']
    );
    _defaultRegions.add(daeggoo);

    Region zezoo = Region('제주',
        ['제주 전체', '제주', '한림', '애월',
          '구좌', '조천', '한경', '추자',
          '우도', '서귀포', '대정', '남원',
          '성산', '안덕', '표선']
    );
    _defaultRegions.add(zezoo);

    Region jeonnam = Region('전남',
        ['전남 전체', '목포', '여수', '순천',
          '나주', '광양', '담양', '곡성',
          '구례', '고흥', '보성', '화순',
          '장흥', '강진', '해남', '영암',
          '무안', '함평', '영광', '장성',
          '완도', '진도', '신안']
    );
    _defaultRegions.add(jeonnam);

    Region geongnamUlsan = Region('경남/울산',
        ['경남 전체', '울산 전체', '울산 중구', '울산 남구',
          '울산 동구', '울산 북구', '울산 울주군', '창원',
          '김해', '양산', '진주', '거제',
          '통영', '사천', '밀양', '함안',
          '거창', '창녕', '고성', '하동',
          '합천', '남해', '함양', '산청',
          '의령']
    );
    _defaultRegions.add(geongnamUlsan);

    Region boosan = Region('부산',
        ['부산 전체', '중구', '서구', '동구',
          '영도', '부산진구', '동래', '남구',
          '북구', '강서', '해운대', '사하',
          '금정', '연제', '수영', '사상',
          '기장']
    );
    _defaultRegions.add(boosan);
  }

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
              height: deviceSize.height * 0.07,
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
                    // padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // 4개의 열로 나누기
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 2.0, // 각 항목의 가로세로 비율을 1:1로 설정
                        ),
                        itemCount: _defaultRegions.length + _getExpandGridItemCnt(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                // 인덱스 재정의
                                if(index > _expandEndIdx) index = index - (_expandEndIdx - _expandStartIdx + 1);
                                // 이미 클릭했던 도시를 눌렀을 때
                                if(selectRegionIdx == index) {
                                  selectRegionIdx = -1;
                                  _expandStartIdx = -1;
                                  _expandEndIdx = -1;
                                  _expandRegions.clear();
                                }
                                // 클릭했던 도시는 아니지만, 다른 도시가 이미 클릭 상태일 때
                                else if(selectRegionIdx != -1) {
                                  // 확장인 놈을 클릭했을 경우
                                  if(index >= _expandStartIdx && index <= _expandEndIdx) {
                                    int i = index - _expandStartIdx;
                                    String value = _expandRegions[i];
                                    // 이미 클릭했던 놈일 경우
                                    if(viewModel.fitPlaceRegions.contains(value)) {
                                      viewModelNotifier.removeFitPlaceRegion(value);
                                    }
                                    // 아니지만, 확장의 첫번째 놈을 누른 경우
                                    else if(index == _expandStartIdx) {
                                      // 지역 초기화
                                      viewModelNotifier.initFitPlaceRegion(value);
                                    }
                                    // 아니지만, 경남/울산인 경우
                                    else if(_defaultRegions[selectRegionIdx].name == "경남/울산") {
                                      // start 인덱스 + 1일 경우에만 지역 초기화
                                      if(index == _expandStartIdx+1)
                                        viewModelNotifier.initFitPlaceRegion(value);
                                    }
                                    // 아닐 경우
                                    else {
                                    // 지역 추가
                                    try {
                                      viewModelNotifier.addFitPlaceRegion(_expandRegions[i]);
                                    } on CustomException catch (e) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomAlert(
                                                title: 'e',
                                                deviceSize: deviceSize
                                            );
                                          }
                                      );
                                    }
                                    }
                                  }
                                  // 디폴트 도시 놈을 클릭했을 경우
                                  else {
                                    // 선택 도시 바꾸기
                                    // subRegions 바꾸기
                                    // 확장 시작, 끝 인덱스 바꾸기
                                    selectRegionIdx = index;
                                    _expandRegions = _defaultRegions[index].subRegions;
                                    _expandStartIdx = index + (4 - index % 4);
                                    _expandEndIdx = _expandStartIdx + _getExpandGridItemCnt() - 1;
                                  }
                                }
                                // 처음 눌렀을 때
                                else {
                                  // 선택 도시 바꾸기
                                  // subRegions 바꾸기
                                  // 확장 시작, 끝 인덱스 바꾸기
                                  selectRegionIdx = index;
                                  _expandRegions = _defaultRegions[index].subRegions;
                                  _expandStartIdx = index + (4 - index % 4);
                                  _expandEndIdx = _expandStartIdx + _getExpandGridItemCnt() - 1;
                                }
                              });
                            },
                            child: _getGridContainer(index),
                          );
                        }
                    )
                  ),
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

  // Widget _buildGridItem(BuildContext context, int index) {
  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         if(selectRegionIdx == index) {
  //           selectRegionIdx = -1;
  //           _expandStartIdx = -1;
  //           _expandEndIdx = -1;
  //           _expandRegions.clear();
  //         }
  //         else if(selectRegionIdx != -1) {
  //           // 확장인 놈을 클릭했을 경우
  //           if(index >= _expandStartIdx && index <= _expandEndIdx) {
  //             int i = index - _expandStartIdx;
  //             // 이미 클릭했던 놈일 경우
  //             // 아닐 경우
  //             ref.read(mateListRequestViewModelProvider.notifier).addFitPlaceRegions(_expandRegions[i]);
  //           }
  //           else {
  //             // 디폴트 도시 놈을 클릭했을 경우
  //           }
  //         }
  //         else {
  //           selectRegionIdx = index;
  //           _expandRegions = _defaultRegions[index].subRegions;
  //           _expandStartIdx = index + (4 - index % 4);
  //           _expandEndIdx = _expandStartIdx + _getExpandGridItemCnt() - 1;
  //         }
  //       });
  //     },
  //     child: Container(
  //       child: Center(
  //         child: Text(
  //           _defaultRegions[index].name,
  //           style: TextStyle(
  //             fontSize: 15,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _getGridContainer(int index) {

    // 확장 되었을 때
    if(_expandStartIdx != -1) {
      // 확장 범위 안의 경우
      if(index >= _expandStartIdx && index <= _expandEndIdx) {
        // 하위 지역 개수 넘은 경우
        if(index - _expandStartIdx >= _expandRegions.length) {
          return Container(
            child: Center(
              child: Text(
                '',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          );
        }
        return Container(
          color: Color(0xffE8E8E8),
          child: Center(
            child: Text(
              _defaultRegions[index].name,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        );
      }
      // 확장 외부의 경우
      else {
        int idx = index;
        if(idx > _expandEndIdx) idx = index - (_expandEndIdx - _expandStartIdx + 1);
        // 상위 선택 도시였을 경우
        return Container(
          color: idx == selectRegionIdx ? Color(0xffE8E8E8) : Colors.white,
          child: Center(
            child: Text(
              _defaultRegions[idx].name,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        );
      }
    }
    // 평소에
    else {
      return Container(
        child: Center(
          child: Text(
            _defaultRegions[index].name,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      );
    }


  }

  int _getExpandGridItemCnt() {
    int remain = _expandRegions.length % 4;
    return _expandRegions.length + remain;
  }

  bool _isPaintGrid(int index) {
    if(index == selectRegionIdx ||
        (index >= _expandStartIdx && index <= _expandEndIdx))
      return true;
    else return false;
  }
}

enum RangePeople {
  ALL,
  THREE_TEN,
  ELEVEN_THIRTY,
  THIRTY_FIFTEEN,
}
