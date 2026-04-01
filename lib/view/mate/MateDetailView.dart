import 'dart:typed_data';

import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/widget/AppSnackBar.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/repository/mate/MateRepository.dart';
import 'package:fitmate_app/widget/CachedProfileImage.dart';
import 'package:fitmate_app/view/account/UserProfileView.dart';
import 'package:fitmate_app/view/mate/MateApproveView.dart';
import 'package:fitmate_app/view/mate/MateRequestView.dart';
import 'package:fitmate_app/view_model/account/MyProfileViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MateDetailView extends ConsumerStatefulWidget {
  const MateDetailView({required this.mateId});
  final int mateId;

  @override
  ConsumerState<MateDetailView> createState() => _MateDetailViewState();
}

class _MateDetailViewState extends ConsumerState<MateDetailView> {
  int _currentImage = 0;
  int? _myAccountId;
  late Future<Mate> _mateFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _mateFuture = ref.read(mateRepositoryProvider).getMateOne(widget.mateId);
    ref.read(myProfileProvider.future).then((profile) {
      if (mounted) setState(() => _myAccountId = profile.accountId);
    }).catchError((_) {});
  }

  void _refreshData() {
    setState(() {
      _mateFuture = ref.read(mateRepositoryProvider).getMateOne(widget.mateId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final double imageHeight = deviceSize.height * 0.38;

    return FutureBuilder(
      future: _mateFuture,
      builder: (BuildContext context, AsyncSnapshot<Mate> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final mate = snapshot.data!;
            final int imageCount = mate.introImageIds.isEmpty ? 1 : mate.introImageIds.length;

            return Scaffold(
              backgroundColor: Color(0xffF5F5F5),
              appBar: AppBar(
                backgroundColor: Color(0xffF5F5F5),
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              body: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  children: [
                    // --- 이미지 + 카드(이미지 위에 겹침) + 프로필 ---
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 1층: 소개 이미지 (하단에 카드 겹침 공간 확보)
                        Column(
                          children: [
                            SizedBox(
                              height: imageHeight,
                              width: double.infinity,
                              child: mate.introImageIds.isEmpty
                                  ? Image.asset('assets/images/default_intro_image.jpg', fit: BoxFit.cover)
                                  : _getIntroImage(mate.introImageIds[_currentImage]),
                            ),
                            // 카드 높이만큼 아래 여백 (카드가 Positioned로 올라오므로)
                            SizedBox(height: 80),
                          ],
                        ),
                        // 2층: 카테고리 뱃지 (좌상단)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              mate.fitCategory?.label ?? '',
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        // 2층: 이미지 카운터 (우상단)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_currentImage + 1}/$imageCount',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                        // 2층: 좌우 화살표
                        if (imageCount > 1) ...[
                          Positioned(
                            left: 8,
                            top: imageHeight / 2 - 18,
                            child: _buildArrowButton(Icons.chevron_left, () {
                              setState(() {
                                _currentImage = _currentImage > 0 ? _currentImage - 1 : imageCount - 1;
                              });
                            }),
                          ),
                          Positioned(
                            right: 8,
                            top: imageHeight / 2 - 18,
                            child: _buildArrowButton(Icons.chevron_right, () {
                              setState(() {
                                _currentImage = _currentImage < imageCount - 1 ? _currentImage + 1 : 0;
                              });
                            }),
                          ),
                        ],
                        // 3층: 닉네임 + 제목 카드 (이미지 하단을 덮음)
                        Positioned(
                          top: imageHeight - 40,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (mate.writerAccountId != null) {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => UserProfileView(accountId: mate.writerAccountId!),
                                      ));
                                    }
                                  },
                                  child: Text(
                                    mate.writerNickName ?? '',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  mate.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 4층(최상위): 프로필 이미지 (카드 상단 중앙에 겹침)
                        Positioned(
                          top: imageHeight - 68,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (mate.writerAccountId != null) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => UserProfileView(accountId: mate.writerAccountId!),
                                  ));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1),
                                ),
                                child: _getWriterProfileImage(mate.writerImageId, 52),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // --- 요약 정보 (장소, 날짜, 인원) ---
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month_rounded, size: 18, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            _extractAddress(mate.fitPlaceAddress),
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          Text(' \u00b7 ', style: TextStyle(color: Colors.grey[400])),
                          Text(
                            formatDate(mate.mateAt!),
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.group, size: 18, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            '${mate.approvedAccountIds.length}/${mate.permitPeopleCnt}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    // --- 안내사항 섹션 ---
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '안내사항',
                            style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '자세한 정보를 알려드릴게요',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 24),
                          _buildInfoRow(Icons.category_rounded, mate.fitCategory?.label ?? '미지정'),
                          _buildInfoRow(Icons.group, '최대 ${mate.permitPeopleCnt}명 \u00b7 ${mate.gatherType?.label ?? ''}'),
                          _buildInfoRow(
                            Icons.attach_money_rounded,
                            mate.mateFees.isEmpty ? '무료' : '${mate.totalFee}원',
                          ),
                          _buildInfoRow(
                            Icons.person_outline,
                            getTextPermitAges(mate.permitMinAge!, mate.permitMaxAge!),
                          ),
                          _buildInfoRow(Icons.calendar_month_rounded, formatDate(mate.mateAt!)),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.place_rounded, size: 22, color: Colors.grey[700]),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mate.fitPlaceName,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        '(${mate.fitPlaceAddress})',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // --- 소개글 ---
                    if (mate.introduction.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(16, 12, 16, 0),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '소개글',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 10),
                            Text(
                              mate.introduction,
                              style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: _buildBottomButton(mate, deviceSize),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: CustomAlert(
                title: snapshot.error.toString(),
                deviceSize: deviceSize,
              ),
            );
          }
        }
        return Scaffold(
          backgroundColor: Color(0xffF5F5F5),
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildBottomButton(Mate mate, Size deviceSize) {
    final myAccountId = _myAccountId;

    final bool isWriter = myAccountId != null && mate.writerAccountId == myAccountId;
    final bool isApproved = myAccountId != null && mate.approvedAccountIds.contains(myAccountId);
    final bool isWaiting = myAccountId != null && mate.waitingAccountIds.contains(myAccountId);
    final bool isFull = mate.approvedAccountIds.length >= (mate.permitPeopleCnt ?? 0);

    String title;
    bool isEnabled;
    VoidCallback? onTap;

    if (isWriter) {
      final waitingCount = mate.waitingAccountIds.length;
      title = waitingCount > 0 ? '신청 관리 (${waitingCount}건 대기중)' : '신청 관리';
      isEnabled = true;
      onTap = () async {
        await Navigator.push(context, MaterialPageRoute(
          builder: (context) => MateApproveView(
            mateId: widget.mateId,
            waitingAccountIds: mate.waitingAccountIds,
            approvedAccountIds: mate.approvedAccountIds,
          ),
        ));
        _refreshData();
      };
    } else if (isApproved) {
      title = '참여 취소';
      isEnabled = true;
      onTap = () => _showCancelDialog(mate);
    } else if (isWaiting) {
      title = '신청 취소';
      isEnabled = true;
      onTap = () => _showCancelDialog(mate);
    } else if (isFull) {
      title = '모집 마감';
      isEnabled = false;
      onTap = null;
    } else {
      title = '참여 신청하기';
      isEnabled = true;
      onTap = () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => MateRequestView(mateId: widget.mateId),
        ));
      };
    }

    return CustomButton(
      deviceSize: deviceSize,
      onTapMethod: onTap ?? () {},
      title: title,
      isEnabled: isEnabled,
    );
  }

  void _showCancelDialog(Mate mate) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          '신청 취소',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '메이트 신청을 취소하시겠습니까?',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '취소 사유 (선택)',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orangeAccent, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('닫기', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(mateRepositoryProvider).cancelMateApply(
                      widget.mateId,
                      reasonController.text.trim(),
                    );
                _refreshData();
                if (mounted) {
                  AppSnackBar.show(context, message: '신청이 취소되었습니다.', type: SnackBarType.success);
                }
              } catch (e) {
                if (mounted) {
                  AppSnackBar.show(context, message: '신청 취소에 실패했습니다.', type: SnackBarType.error);
                }
              }
            },
            child: const Text(
              '취소하기',
              style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[700]),
          SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  String _extractAddress(String address) {
    List<String> tokens = address.split(' ').where((w) => w.endsWith('구')).toList();
    return tokens.isNotEmpty ? tokens[0] : '';
  }

  String formatDate(DateTime dateTime) {
    String datePart = DateFormat('yy.M.d').format(dateTime);
    String weekdayPart = getKoreanWeekday(dateTime.weekday);
    String amPmPart = dateTime.hour >= 12 ? '오후' : '오전';
    int hour = dateTime.hour % 12;
    if (hour == 0) hour = 12;
    String timePart = '$hour:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$datePart($weekdayPart) $amPmPart $timePart';
  }

  String getKoreanWeekday(int weekday) {
    const List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }

  String getTextPermitAges(int min, int max) {
    if (min == 20 && max == 50) return '모든 연령';
    if (min == 20) return '${max}세 이하';
    if (max == 50) return '${min}세 이상';
    return '$min ~ ${max}세';
  }

  Widget _getWriterProfileImage(int? writerImageId, double size) {
    return CachedProfileImage(imageId: writerImageId, size: size);
  }

  Widget _getIntroImage(int introImageId) {
    final data = ref.read(imageCacheServiceProvider).get(introImageId);
    if (data != null) {
      return Image.memory(data, fit: BoxFit.cover);
    }
    return FutureBuilder<Uint8List?>(
      future: ref.read(imageCacheServiceProvider).load(introImageId),
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
}
