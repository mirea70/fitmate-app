import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/view/mate/MainView.dart';
import 'package:fitmate_app/widget/AppSnackBar.dart';
import 'package:fitmate_app/view/mate/MateRegisterView1.dart';
import 'package:fitmate_app/view_model/account/MyProfileViewModel.dart';
import 'package:fitmate_app/widget/CachedProfileImage.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:fitmate_app/repository/file/FileRepository.dart';
import 'package:fitmate_app/view_model/mate/MateAsyncViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateDetailViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
    final editMateId = ref.watch(mateEditModeProvider);
    final isEditMode = editMateId != null;
    final keepImageIds = ref.watch(keepImageIdsProvider);
    final totalImageCount = keepImageIds.length + fileViewModel.files.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF1F1F1),
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Color(0xffF1F1F1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image carousel with navigation arrows
            SizedBox(
              height: (deviceSize.height * 0.35).clamp(250.0, 380.0),
              width: double.maxFinite,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _buildPreviewImage(keepImageIds, fileViewModel, _currentImage),
                  ),
                  Positioned(
                    left: 10,
                    top: 0,
                    bottom: 0,
                    child: Center(
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
                                final imageCount = totalImageCount;
                                if (imageCount > 0) {
                                  if (_currentImage > 0) {
                                    _currentImage--;
                                  } else {
                                    _currentImage = imageCount - 1;
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 0,
                    bottom: 0,
                    child: Center(
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
                                final imageCount = totalImageCount;
                                if (imageCount > 0) {
                                  if (_currentImage < imageCount - 1) {
                                    _currentImage++;
                                  } else {
                                    _currentImage = 0;
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Writer profile overlapping image area
            Transform.translate(
              offset: Offset(0, -30),
              child: _buildWriterProfile(deviceSize),
            ),

            // Title card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.04),
              child: Card(
                elevation: 4,
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceSize.width * 0.04,
                    vertical: deviceSize.height * 0.025,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      viewModel.title,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: deviceSize.height * 0.02),

            // Date and group count row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.05),
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
                  Flexible(
                    child: Text(
                      formatDate(viewModel.mateAt!),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
                    '${isEditMode ? viewModel.approvedAccountIds.length : viewModel.approvedAccountIds.length + 1}/${viewModel.permitPeopleCnt}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: deviceSize.height * 0.05),

            // Detail info section
            Padding(
              padding: EdgeInsets.only(
                left: deviceSize.width * 0.05,
                right: deviceSize.width * 0.05,
              ),
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
                  _buildInfoRow(
                    icon: Icons.category_rounded,
                    text: viewModel.fitCategory != null
                        ? viewModel.fitCategory!.label
                        : '미지정',
                    deviceSize: deviceSize,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  _buildInfoRow(
                    icon: Icons.group,
                    text: '최대 ${viewModel.permitPeopleCnt}명 => ${viewModel.gatherType!.label}',
                    deviceSize: deviceSize,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  _buildInfoRow(
                    icon: Icons.attach_money_rounded,
                    text: viewModel.mateFees.isEmpty
                        ? '무료'
                        : '${viewModel.totalFee}원',
                    deviceSize: deviceSize,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  _buildInfoRow(
                    icon: Icons.compare_arrows_rounded,
                    text: getTextPermitAges(viewModel.permitMinAge!,
                        viewModel.permitMaxAge!),
                    deviceSize: deviceSize,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  _buildInfoRow(
                    icon: Icons.wc_rounded,
                    text: _getTextPermitGender(viewModel.permitGender),
                    deviceSize: deviceSize,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  _buildInfoRow(
                    icon: Icons.calendar_month_rounded,
                    text: formatDate(viewModel.mateAt!),
                    deviceSize: deviceSize,
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: deviceSize.height * 0.003),
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
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              '${viewModel.fitPlaceAddress}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceSize.height * 0.03),
                ],
              ),
            ),
          ],
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
                    try {
                      if (isEditMode) {
                        var mateToSubmit = viewModel;
                        // 유지 중인 서버 이미지 ID + 새로 업로드한 이미지 ID 합산
                        List<int> keepIds = List<int>.from(ref.read(keepImageIdsProvider));
                        List<int> newImageIds = [];
                        if (fileViewModel.files.isNotEmpty) {
                          List<String> newImagePaths = fileViewModel.files.map((f) => f.path).toList();
                          List<Map<String, dynamic>> uploaded = await ref.read(fileRepositoryProvider).uploadFiles(newImagePaths);
                          newImageIds = uploaded.map((f) => f['attachFileId'] as int).toList();
                        }
                        mateToSubmit = mateToSubmit.copyWith(introImageIds: [...keepIds, ...newImageIds]);
                        await ref.read(mateAsyncViewModelProvider.notifier).modifyMate(editMateId, mateToSubmit);
                        ref.invalidate(mateDetailProvider(editMateId));
                      } else {
                        List<XFile> introImages =
                            ref.read(fileViewModelProvider).files;
                        List<String> introImagePaths = List.generate(
                            introImages.length, (index) => introImages[index].path);
                        await ref.read(mateAsyncViewModelProvider.notifier).addMate(viewModel, introImagePaths);
                      }

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => MainView(),
                        ),
                            (route) => false,
                      );
                      viewModelNotifier.reset();
                      fileViewModel.reset();
                      ref.read(selectNumProvider.notifier).reset();
                      ref.read(mateEditModeProvider.notifier).state = null;
                      ref.read(keepImageIdsProvider.notifier).state = [];

                      AppSnackBar.show(context,
                          message: isEditMode ? '메이트 모집 글이 수정되었습니다!' : '메이트 모집 등록이 완료되었습니다!',
                          type: SnackBarType.success);
                    } catch (error) {
                      String errorMessage = isEditMode
                          ? '수정 중 문제가 발생했습니다. 다시 시도해주세요.'
                          : '등록 중 문제가 발생했습니다. 다시 시도해주세요.';
                      if (error is DioException && error.response?.data is Map) {
                        final data = error.response?.data as Map;
                        final serverMessage = data['message'] as String?;
                        if (serverMessage != null && serverMessage.isNotEmpty) {
                          errorMessage = serverMessage;
                        }
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlert(
                                title: errorMessage,
                                deviceSize: deviceSize,
                            );
                          });
                    }
                  },
                  title: isEditMode ? '수정하기' : '메이트 모집하기',
                  isEnabled: hasNotEmpty()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewImage(List<int> keepIds, FileViewModel fvm, int index) {
    final totalCount = keepIds.length + fvm.files.length;
    if (totalCount == 0) {
      return Image.asset('assets/images/default_intro_image.jpg', fit: BoxFit.cover);
    }
    if (index < keepIds.length) {
      return _buildCachedImage(keepIds[index]);
    }
    final fileIndex = index - keepIds.length;
    if (fileIndex < fvm.files.length) {
      return Image.file(File(fvm.files[fileIndex].path), fit: BoxFit.cover);
    }
    return Image.asset('assets/images/default_intro_image.jpg', fit: BoxFit.cover);
  }

  Widget _buildCachedImage(int imageId) {
    final data = ref.read(imageCacheServiceProvider).get(imageId);
    if (data != null) {
      return Image.memory(data, fit: BoxFit.cover);
    }
    return FutureBuilder<Uint8List?>(
      future: ref.read(imageCacheServiceProvider).load(imageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        }
        if (snapshot.hasError) {
          return Image.asset('assets/images/default_intro_image.jpg', fit: BoxFit.cover);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildWriterProfile(Size deviceSize) {
    final myProfile = ref.watch(myProfileProvider);
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: myProfile.when(
              data: (profile) => CachedProfileImage(
                imageId: profile.profileImageId,
                size: 45,
              ),
              loading: () => DefaultProfileImage(size: 45),
              error: (_, __) => DefaultProfileImage(size: 45),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: deviceSize.height * 0.01),
            child: Text(
              myProfile.when(
                data: (profile) => profile.nickName,
                loading: () => '',
                error: (_, __) => '',
              ),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Size deviceSize,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        SizedBox(
          width: deviceSize.width * 0.02,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  String _getTextPermitGender(PermitGender? permitGender) {
    if (permitGender == null) return '누구나';
    switch (permitGender) {
      case PermitGender.ALL: return '누구나 참여 가능';
      case PermitGender.MALE: return '남성만 참여 가능';
      case PermitGender.FEMALE: return '여성만 참여 가능';
    }
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
    final checks = {
      'fitCategory': viewModel.fitCategory != null && viewModel.fitCategory != FitCategory.undefined,
      'title': viewModel.title != '',
      'mateAt': viewModel.mateAt != null,
      'fitPlaceName': viewModel.fitPlaceName != '',
      'fitPlaceAddress': viewModel.fitPlaceAddress != '',
      'gatherType': viewModel.gatherType != null && viewModel.gatherType != GatherType.undefined,
      'permitGender': viewModel.permitGender != null,
      'permitMaxAge': viewModel.permitMaxAge != null,
      'permitMinAge': viewModel.permitMinAge != null,
      'permitPeopleCnt': viewModel.permitPeopleCnt != null,
      'applyQuestion': viewModel.applyQuestion != '',
    };
    final failed = checks.entries.where((e) => !e.value).map((e) => e.key).toList();
    if (failed.isNotEmpty) {
      debugPrint('[hasNotEmpty] 비어있는 필드: $failed');
      return false;
    }
    return true;
  }
}
