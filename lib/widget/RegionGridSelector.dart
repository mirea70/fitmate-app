import 'package:fitmate_app/error/CustomException.dart';
import 'package:fitmate_app/model/common/Region.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:flutter/material.dart';

class RegionGridSelector extends StatefulWidget {
  final List<Region> regions;
  final Map<String, List<String>> selectRegionMap;
  final void Function(String region) onAddRegion;
  final void Function(String region) onRemoveRegion;
  final void Function(String parentName, List<String> regions, String value)
      onRemoveAllAndAddRegion;
  final void Function(String parentName, String removeValue, String addValue)
      onRemoveAndAddRegion;

  const RegionGridSelector({
    super.key,
    required this.regions,
    required this.selectRegionMap,
    required this.onAddRegion,
    required this.onRemoveRegion,
    required this.onRemoveAllAndAddRegion,
    required this.onRemoveAndAddRegion,
  });

  @override
  State<RegionGridSelector> createState() => RegionGridSelectorState();
}

class RegionGridSelectorState extends State<RegionGridSelector> {
  int selectRegionIdx = -1;
  List<String> _expandRegions = [];
  int _expandStartIdx = -1;
  int _expandEndIdx = -1;

  void reset() {
    setState(() {
      selectRegionIdx = -1;
      _expandRegions = [];
      _expandStartIdx = -1;
      _expandEndIdx = -1;
    });
  }

  int _getExpandSize() {
    if (_expandRegions.isNotEmpty && _expandRegions.length % 4 != 0) {
      int remain = 4 - (_expandRegions.length % 4);
      return _expandRegions.length + remain;
    }
    return _expandRegions.length;
  }

  Widget _getGridContainer(int index) {
    // 확장 되었을 때
    if (_expandStartIdx != -1) {
      // 확장 범위 안의 경우
      if (index >= _expandStartIdx && index <= _expandEndIdx) {
        int childIdx = index - _expandStartIdx;
        String parentName = widget.regions[selectRegionIdx].name;
        // 하위 지역 개수 넘은 경우
        if (childIdx >= _expandRegions.length) {
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

        String value = _expandRegions[childIdx];

        // 현재 선택된 하위지역일 경우
        if (widget.selectRegionMap.containsKey(parentName)) {
          List<String> regions = widget.selectRegionMap[parentName]!;

          if (regions.contains(value))
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Center(
                child: Text(
                  childIdx == 0 ? parentName + " " + value : value,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            );
        }
        // 그냥 확장 그리드
        return Container(
          color: Color(0xffE8E8E8),
          child: Center(
            child: Text(
              childIdx == 0 ? parentName + " " + value : value,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        );
      }
      // 확장 외부의 경우
      else {
        if (index > _expandEndIdx)
          index = index - (_expandEndIdx - _expandStartIdx + 1);

        if (selectRegionIdx == 16 &&
            index > selectRegionIdx &&
            index < _expandStartIdx) {
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
        // 상위 선택 도시였을 경우
        return Container(
          color: index == selectRegionIdx ? Color(0xffE8E8E8) : Colors.white,
          child: Center(
            child: Text(
              widget.regions[index].name,
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
            widget.regions[index].name,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          deviceSize.width * 0.03, 0, deviceSize.width * 0.03, 0),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: GridView.builder(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 2.0,
              ),
              itemCount: widget.regions.length + _getExpandSize(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      // 확장 상태아닐 때
                      if (selectRegionIdx == -1) {
                        selectRegionIdx = index;
                        _expandRegions = [
                          ...widget.regions[index].subRegions
                        ];
                        _expandStartIdx = index + (4 - index % 4);
                        _expandEndIdx =
                            _expandStartIdx + _getExpandSize() - 1;
                      }
                      // 확장 상태일 때
                      else {
                        // 상위 지역 인덱스
                        int parentIdx = index;
                        if (index > _expandStartIdx)
                          parentIdx =
                              index - (_expandEndIdx - _expandStartIdx + 1);
                        // 하위 지역 인덱스
                        int childIdx = index - _expandStartIdx;
                        // 선택 상위 지역 이름
                        String parentName =
                            widget.regions[selectRegionIdx].name;

                        // 확장인 놈을 클릭했을 경우
                        if (index >= _expandStartIdx &&
                            index <= _expandEndIdx) {
                          String value = _expandRegions[childIdx];

                          // 현재 부모를 갖고 있을 때
                          if (widget.selectRegionMap
                              .containsKey(parentName)) {
                            List<String> regions =
                                widget.selectRegionMap[parentName]!;
                            // 이미 클릭했던 놈일 경우
                            if (regions.contains(value)) {
                              widget.onRemoveRegion(
                                  parentName + " " + value);
                              regions.remove(value);
                              widget.selectRegionMap[parentName] = regions;
                            }
                            // 아니지만, 확장의 첫번째 놈을 누른 경우
                            else if (childIdx == 0) {
                              widget.onRemoveAllAndAddRegion(
                                  parentName, regions, value);
                              regions = [value];
                              widget.selectRegionMap[parentName] = regions;
                            }
                            // 확장의 첫번째 놈 아닌 다른 놈 눌렀지만, 첫번째 놈을 가지고 있던 경우
                            else if (regions.contains(widget
                                .regions[selectRegionIdx].subRegions[0])) {
                              widget.onRemoveAndAddRegion(
                                  parentName,
                                  widget.regions[selectRegionIdx]
                                      .subRegions[0],
                                  value);
                              regions.remove(regions[0]);
                              regions.add(value);
                              widget.selectRegionMap[parentName] = regions;
                            }
                            // 확장인 놈 중 첫번째도 아니고, 첫번째를 가지고 있지도 않은 경우
                            else {
                              try {
                                widget.onAddRegion(
                                    parentName + " " + value);
                                regions.add(value);
                                widget.selectRegionMap[parentName] =
                                    regions;
                              } on CustomException catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlert(
                                          title: e.msg,
                                          deviceSize: deviceSize);
                                    });
                              }
                            }
                          }
                          // 현재 부모가 없을 경우
                          else {
                            // 지역 추가
                            try {
                              widget.onAddRegion(
                                  parentName + " " + value);
                              widget.selectRegionMap[parentName] = [value];
                            } on CustomException catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlert(
                                        title: e.msg,
                                        deviceSize: deviceSize);
                                  });
                            }
                          }
                        }
                        // 확장 외부의 경우
                        else {
                          // 이미 클릭했던 도시를 눌렀을 때
                          if (selectRegionIdx == parentIdx) {
                            selectRegionIdx = -1;
                            _expandStartIdx = -1;
                            _expandEndIdx = -1;
                            _expandRegions.clear();
                          } else {
                            selectRegionIdx = parentIdx;
                            _expandRegions = [
                              ...widget.regions[parentIdx].subRegions
                            ];
                            _expandStartIdx =
                                parentIdx + (4 - parentIdx % 4);
                            _expandEndIdx =
                                _expandStartIdx + _getExpandSize() - 1;
                          }
                        }
                      }
                    });
                  },
                  child: _getGridContainer(index),
                );
              })),
    );
  }
}
