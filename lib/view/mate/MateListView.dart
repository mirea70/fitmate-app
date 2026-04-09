import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/view_model/account/NoticeViewModel.dart';
import 'package:fitmate_app/view/mate/MateDetailView.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:fitmate_app/view_model/mate/MateAsyncViewModel.dart';
import 'package:fitmate_app/widget/MainViewAppbar.dart';
import 'package:fitmate_app/widget/ShimmerLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class MateListView extends ConsumerStatefulWidget {
  const MateListView({super.key});

  @override
  ConsumerState<MateListView> createState() => _MateListViewState();
}

class _MateListViewState extends ConsumerState<MateListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(unreadNoticeCountProvider.notifier).refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final mates = ref.watch(mateAsyncViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainViewAppbar(
        // deviceSize: deviceSize,
        // devicePadding: devicePadding,
      ),
      body: Container(
        color: Color(0xffF1F1F1),
        child: Column(
          children: [
            SizedBox(height: deviceSize.height * 0.02),
            mates.when(
              data: (items) =>
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.05),
                      child: items.isEmpty
                          ? Center(
                              child: Text(
                                '모집 중인 메이트가 없습니다.',
                                style: TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            )
                          : ListView.separated(
                        padding: EdgeInsets.only(bottom: 16),
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            key: ValueKey(items[index].id),
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MateDetailView(mateId: items[index].id)));
                            },
                            child: Stack(
                              children: [
                                Opacity(
                                  opacity: items[index].closed ? 0.4 : 1.0,
                                  child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: deviceSize.width * 0.03,
                                    ),
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
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
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
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                '${_extractAddress(items[index].fitPlaceAddress)} ∙ ${_formatDate(items[index].mateAt)}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                ),
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
                  ),
              error: (e, stack) => Text('Error: $e'),
              loading: () => Expanded(
                child: MateListSkeleton(deviceSize: deviceSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractAddress(String address) {
    if (address.isEmpty) return '';
    final tokens = address.split(' ');
    // 구 > 시 > 동 순으로 찾기
    final gu = tokens.where((w) => w.endsWith('구')).toList();
    if (gu.isNotEmpty) return gu[0];
    final si = tokens.where((w) => w.endsWith('시')).toList();
    if (si.isNotEmpty) return si[0];
    final dong = tokens.where((w) => w.endsWith('동')).toList();
    if (dong.isNotEmpty) return dong[0];
    // 못 찾으면 첫 번째 토큰 반환
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
    if (thumbnailImageId == null) {
      return _buildThumbnailImageContainer(AssetImage('assets/images/default_intro_image.jpg'), deviceSize);
    }
    final cached = ref.read(imageCacheServiceProvider).get(thumbnailImageId);
    if (cached != null) {
      return _buildThumbnailImageContainer(MemoryImage(cached), deviceSize);
    }
    return _buildThumbnailImageContainer(AssetImage('assets/images/default_intro_image.jpg'), deviceSize);
  }

  Widget _buildThumbnailImageContainer(ImageProvider imageProvider, Size deviceSize) {
    final thumbWidth = (deviceSize.width * 0.28).clamp(100.0, 180.0);
    return Expanded(
      flex: 0,
      child: Container(
        width: thumbWidth,
        constraints: BoxConstraints(minHeight: 80),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _getProfileImage(int? profileImageId, Size deviceSize) {
    final double size = (deviceSize.width * 0.06).clamp(22.0, 32.0);
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
