import 'dart:typed_data';

import 'package:fitmate_app/repository/file/FileRepository.dart';
import 'package:fitmate_app/view/mate/MateDetailView.dart';
import 'package:fitmate_app/view_model/mate/MateAsyncViewModel.dart';
import 'package:fitmate_app/widget/MainViewAppbar.dart';
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
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final mates = ref.watch(mateAsyncViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainViewAppbar(
        deviceSize: deviceSize,
        devicePadding: devicePadding,
      ),
      body: Container(
        width: deviceSize.width,
        height: deviceSize.height,
        color: Color(0xffF1F1F1),
        child: Column(
          children: [
            SizedBox(
              height: deviceSize.height * 0.02,
            ),
            mates.when(
              data: (items) =>
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(deviceSize.width * 0.05, 0, deviceSize.width * 0.05, 0),
                      child: ListView.separated(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MateDetailView(mateId: items[index].id)));
                            },
                            child: Container(
                              height: deviceSize.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: deviceSize.width * 0.03,
                                  ),
                                  _getThumbnailImage(items[index].thumbnailImageId, deviceSize),
                                  SizedBox(
                                    width: deviceSize.width * 0.03,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: deviceSize.height * 0.015,
                                      ),
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
                                          Text(
                                            '${_extractAddress(items[index].fitPlaceAddress)} ∙ ${_formatDate(items[index].mateAt)}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
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
                                          Text(
                                            '${items[index].writerNickName} ∙ ${items[index].gatherType!.label}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
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
                                            '${items[index].approvedAccountCnt}/${items[index].permitPeopleCnt}',
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
                                ],
                              ),
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
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractAddress(String address) {
    List<String> tokens = address.split(' ')
        .where((word) => word.endsWith('구')).toList();
    String response = (tokens != null && tokens.isNotEmpty) ? tokens[0] : '알수없음';
    return response;
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
    } else {
      return FutureBuilder<Uint8List>(
        future: ref.read(fileRepositoryProvider).downloadFile(thumbnailImageId),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return _buildThumbnailImageContainer(MemoryImage(snapshot.data!), deviceSize);
            } else if (snapshot.hasError) {
              return _buildThumbnailImageContainer(AssetImage('assets/images/default_intro_image.jpg'), deviceSize);
            }
          }
          return _buildThumbnailImageContainer(AssetImage('assets/images/default_intro_image.jpg'), deviceSize);
        },
      );
    }
  }

  Widget _buildThumbnailImageContainer(ImageProvider imageProvider, Size deviceSize) {
    return Container(
      width: deviceSize.width * 0.28,
      height: deviceSize.height * 0.12,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _getProfileImage(int? profileImageId, Size deviceSize) {
    if (profileImageId == null) {
      return _buildProfileImageContainer(AssetImage('assets/images/default_profile.jpeg'), deviceSize);
    } else {
      return FutureBuilder<Uint8List>(
        future: ref.read(fileRepositoryProvider).downloadFile(profileImageId),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return _buildProfileImageContainer(MemoryImage(snapshot.data!), deviceSize);
            } else if (snapshot.hasError) {
              return _buildProfileImageContainer(AssetImage('assets/images/default_profile.jpeg'), deviceSize);
            }
          }
          return _buildProfileImageContainer(AssetImage('assets/images/default_profile.jpeg'), deviceSize);
        },
      );
    }
  }

  Widget _buildProfileImageContainer(ImageProvider imageProvider, Size deviceSize) {
    return Container(
      height: deviceSize.height * 0.04,
      width: deviceSize.width * 0.06,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
