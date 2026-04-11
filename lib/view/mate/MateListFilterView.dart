import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/widget/CachedProfileImage.dart';
import 'package:fitmate_app/model/mate/MateListItem.dart';
import 'package:fitmate_app/view/mate/MateDetailView.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:fitmate_app/view_model/mate/MateListRequestViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/MateListFilterViewAppbar.dart';
import 'package:fitmate_app/widget/ShimmerLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class MateListFilterView extends ConsumerStatefulWidget {
  const MateListFilterView();

  @override
  ConsumerState<MateListFilterView> createState() => _MateListFilterViewState();
}

class _MateListFilterViewState extends ConsumerState<MateListFilterView> {
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MateListFilterViewAppbar(),
      body: Container(
        width: deviceSize.width,
        color: Color(0xffF1F1F1),
        child: Column(
          children: [
            SizedBox(
              height: deviceSize.height * 0.02,
            ),
            FutureBuilder(
                future: ref.read(mateListRequestViewModelProvider.notifier).requestFilter(page: 0),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData == false) {
                    return Expanded(
                      child: MateListSkeleton(deviceSize: deviceSize),
                    );
                  }
                  else if(snapshot.hasError) {
                    return CustomAlert(
                        title: snapshot.error.toString(),
                        deviceSize: deviceSize,
                    );
                  }
                  else {
                    final List<MateListItem> items = snapshot.data;
                    if(items.length != 0)
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(deviceSize.width * 0.05, 0, deviceSize.width * 0.05, 0),
                          child: ListView.separated(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                key: ValueKey(items[index].id),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MateDetailView(mateId: items[index].id),
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: Stack(
                                  children: [
                                    Opacity(
                                      opacity: items[index].closed ? 0.4 : 1.0,
                                      child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: deviceSize.width * 0.03),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                  children: [
                                    _getThumbnailImage(items[index].thumbnailImageId, deviceSize),
                                    SizedBox(
                                      width: deviceSize.width * 0.03,
                                    ),
                                    Expanded(
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              items[index].fitCategory.label,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xffF1F1F1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        SizedBox(
                                          height: deviceSize.height * 0.003,
                                        ),
                                        Text(
                                          items[index].title,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: deviceSize.height * 0.003,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_pin,
                                              size: 15,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: deviceSize.width * 0.01,
                                            ),
                                            Flexible(
                                              child: Text(
                                                '${_extractAddress(items[index].fitPlaceAddress)} ∙ ${_formatDate(items[index].mateAt)}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            _getProfileImage(items[index].writerImageId, deviceSize),
                                            SizedBox(
                                              width: deviceSize.width * 0.01,
                                            ),
                                            Flexible(
                                              child: Text(
                                                '${items[index].writerNickName} ∙ ${items[index].gatherType?.label ?? ''}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              width: deviceSize.width * 0.03,
                                            ),
                                            Icon(
                                              Icons.group,
                                              size: 15,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: deviceSize.width * 0.01,
                                            ),
                                            Text(
                                              '${items[index].approvedAccountCnt + 1}/${items[index].permitPeopleCnt}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    ),
                                  ],
                                ),
                                ),
                                      ),
                                    ),
                                    if (items[index].closed)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[700],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '마감',
                                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: deviceSize.height * 0.02,
                              );
                            },
                          ),
                        ),
                      );
                    else return Padding(
                      padding: EdgeInsets.fromLTRB(deviceSize.width * 0.05, 0, deviceSize.width * 0.05, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: deviceSize.height * 0.3,
                          ),
                          Icon(
                            Icons.search_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: deviceSize.height * 0.03,
                          ),
                          Text(
                            '필터 검색 결과가 없어요!',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: deviceSize.height * 0.01,
                          ),
                          Text(
                            '필터 조건을 변경해서 다시 검색해보세요',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
            )
          ],
        ),
      ),
    );
  }

  String _extractAddress(String address) {
    if (address.isEmpty) return '';
    final tokens = address.split(' ');
    final gu = tokens.where((w) => w.endsWith('구')).toList();
    if (gu.isNotEmpty) return gu[0];
    final si = tokens.where((w) => w.endsWith('시')).toList();
    if (si.isNotEmpty) return si[0];
    final dong = tokens.where((w) => w.endsWith('동')).toList();
    if (dong.isNotEmpty) return dong[0];
    return tokens[0];
  }

  String _formatDate(DateTime dateTime) {
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

  Widget _getThumbnailImage(int? thumbnailImageId, Size deviceSize) {
    final thumbWidth = (deviceSize.width * 0.28).clamp(100.0, 180.0);
    return CachedThumbnailImage(
      imageId: thumbnailImageId,
      width: thumbWidth,
      height: thumbWidth * 0.8,
      borderRadius: 10,
    );
  }

  Widget _getProfileImage(int? profileImageId, Size deviceSize) {
    final double size = deviceSize.width * 0.06;
    if (profileImageId == null) {
      return DefaultProfileImage(size: size);
    }
    final cached = ref.read(imageCacheServiceProvider).get(profileImageId);
    if (cached != null) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: MemoryImage(cached), fit: BoxFit.cover),
        ),
      );
    }
    return DefaultProfileImage(size: size);
  }
}
