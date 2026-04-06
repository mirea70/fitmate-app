import 'package:fitmate_app/model/common/Region.dart';
import 'package:fitmate_app/model/common/RegionData.dart';
import 'package:fitmate_app/model/mate/MateListRequestModel.dart';
import 'package:fitmate_app/view/mate/MateListFilterView.dart';
import 'package:fitmate_app/view_model/mate/MateListRequestViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomMultiInputCalendar.dart';
import 'package:fitmate_app/widget/DayOfWeekPicker.dart';
import 'package:fitmate_app/widget/FilterSectionHeader.dart';
import 'package:fitmate_app/widget/RegionGridSelector.dart';
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
  final List<Region> _defaultRegions = RegionData.defaultRegions;
  Map<String,List<String>> _selectRegionMap = {};
  final GlobalKey<RegionGridSelectorState> _regionGridKey = GlobalKey<RegionGridSelectorState>();

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModel = ref.watch(mateListRequestViewModelProvider);
    final viewModelNotifier = ref.read(mateListRequestViewModelProvider.notifier);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                      viewModelNotifier.reset();
                      dayInputIdx = 0;
                      dayOfWeekIdx = -1;
                      _selectRegionMap = {};
                      _regionGridKey.currentState?.reset();
                    },
                    child: Row(
                      children: [
                        Text(
                          '재설정',
                          style: TextStyle(color: Colors.grey),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
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
              FilterSectionHeader(title: '날짜'),
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
                          color: dayInputIdx != 1
                              ? Color(0xffE8E8E8)
                              : Colors.orangeAccent,
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
                            color: dayInputIdx != 1
                                ? Colors.black
                                : Colors.orangeAccent,
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
                          color: dayInputIdx != 2
                              ? Color(0xffE8E8E8)
                              : Colors.orangeAccent,
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
                            color: dayInputIdx != 2
                                ? Colors.black
                                : Colors.orangeAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (dayInputIdx == 1)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      deviceSize.width * 0.03, 0, deviceSize.width * 0.03, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: deviceSize.height * 0.02,
                      ),
                      DayOfWeekPicker(
                        selectedIndex: dayOfWeekIdx,
                        onSelected: (index) {
                          setState(() {
                            dayOfWeekIdx != index
                                ? dayOfWeekIdx = index
                                : dayOfWeekIdx = -1;
                          });
                          viewModelNotifier.setDayOfWeek(index);
                        },
                      ),
                    ],
                  ),
                ),
              if (dayInputIdx == 2)
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
              FilterSectionHeader(title: '지역'),
              SizedBox(
                height: deviceSize.height * 0.01,
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: deviceSize.width * 0.03),
              //   child: SizedBox(
              //     height: deviceSize.height * 0.05,
              //       child: ListView.separated(
              //             scrollDirection: Axis.horizontal,
              //             shrinkWrap: true,
              //             itemCount: viewModel.fitPlaceRegions.length,
              //             itemBuilder: (context, index) {
              //               return Container(
              //                 decoration: BoxDecoration(
              //                   color: Color(0xffE8E8E8),
              //                   borderRadius: BorderRadius.circular(15),
              //                 ),
              //                 alignment: Alignment.center,
              //                 padding: EdgeInsets.all(9),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: [
              //                     Text(
              //                       viewModel.fitPlaceRegions[index],
              //                       style: TextStyle(
              //                         fontSize: 15,
              //                       ),
              //                     ),
              //                   SizedBox(
              //                     width: deviceSize.width * 0.01,
              //                   ),
              //                   CustomIconButton(
              //                       onPressed: () {
              //                         String target = viewModel.fitPlaceRegions[index];
              //                         List<String> arr = target.split(" ");
              //                         viewModelNotifier.removeFitPlaceRegion(target);
              //                         List<String> regions = _selectRegionMap[arr[0]]!;
              //                         regions.remove(arr[1]);
              //                         setState(() {
              //                           _selectRegionMap[arr[0]] = regions;
              //                         });
              //                       },
              //                       icon: Icon(
              //                         Icons.cancel,
              //                         size: 15,
              //                         color: Colors.grey,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             }, separatorBuilder: (BuildContext context, int index) {
              //               return SizedBox(
              //                 width: deviceSize.width * 0.03,
              //               );
              //         },
              //       ),
              //   ),
              // ),
              SizedBox(
                height: deviceSize.height * 0.02,
              ),
              RegionGridSelector(
                key: _regionGridKey,
                regions: _defaultRegions,
                selectRegionMap: _selectRegionMap,
                onAddRegion: (region) {
                  viewModelNotifier.addFitPlaceRegion(region);
                },
                onRemoveRegion: (region) {
                  viewModelNotifier.removeFitPlaceRegion(region);
                },
                onRemoveAllAndAddRegion: (parentName, regions, value) {
                  viewModelNotifier.removeAllAndAddFitPlaceRegion(parentName, regions, value);
                },
                onRemoveAndAddRegion: (parentName, removeValue, addValue) {
                  viewModelNotifier.removeAndAddFitPlaceRegion(parentName, removeValue, addValue);
                },
              ),
              SizedBox(
                height: deviceSize.height * 0.05,
              ),
              FilterSectionHeader(title: '나이'),
              Container(
                child: Column(
                  children: [
                    RangeSlider(
                      values: RangeValues(viewModel.permitMinAge!.toDouble(),
                          viewModel.permitMaxAge!.toDouble()),
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
                      padding: EdgeInsets.fromLTRB(
                          deviceSize.width * 0.02, 0, deviceSize.width * 0.02, 0),
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
              FilterSectionHeader(title: '정원'),
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
                            groupValue: viewModel.startLimitPeopleCnt! +
                                viewModel.endLimitPeopleCnt!,
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
                            groupValue: viewModel.startLimitPeopleCnt! +
                                viewModel.endLimitPeopleCnt!,
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
                            groupValue: viewModel.startLimitPeopleCnt! +
                                viewModel.endLimitPeopleCnt!,
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
                            groupValue: viewModel.startLimitPeopleCnt! +
                                viewModel.endLimitPeopleCnt!,
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
              FilterSectionHeader(title: '카테고리'),
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
              SizedBox(
                height: deviceSize.height * 0.1,
              ),
            ],
          ),
        ),
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
                              MateListFilterView()));
                },
                title: '적용하기',
                isEnabled: true,
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
