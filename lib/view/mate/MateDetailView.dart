import 'dart:typed_data';

import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/widget/AppSnackBar.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/repository/mate/MateRepository.dart';
import 'package:fitmate_app/widget/CachedProfileImage.dart';
import 'package:fitmate_app/view/account/UserProfileView.dart';
import 'package:fitmate_app/view/mate/MateApproveView.dart';
import 'package:fitmate_app/view/mate/MateRegisterView1.dart';
import 'package:fitmate_app/view/mate/MateRequestView.dart';
import 'package:fitmate_app/view_model/mate/MateAsyncViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateDetailViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:fitmate_app/view/mate/MateRegisterView5.dart';
import 'package:fitmate_app/repository/chat/ChatRepository.dart';
import 'package:fitmate_app/view/chat/ChatRoomView.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/ShimmerLoading.dart';
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
  bool? _wishedOverride;

  Future<void> _toggleWish() async {
    try {
      final wished = await ref.read(mateRepositoryProvider).toggleWish(widget.mateId);
      if (mounted) {
        setState(() => _wishedOverride = wished);
        AppSnackBar.show(context,
            message: wished ? '찜 목록에 추가되었습니다.' : '찜 목록에서 제거되었습니다.',
            type: SnackBarType.success);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, message: '찜 요청에 실패했습니다.', type: SnackBarType.error);
      }
    }
  }

  void _navigateToEdit(Mate mate) {
    // Set edit mode with mateId
    ref.read(mateEditModeProvider.notifier).state = widget.mateId;

    // Load existing data into register view model
    ref.read(mateRegisterViewModelProvider.notifier).loadFromMate(mate);

    // Set category selection state
    if (mate.fitCategory != null && mate.fitCategory != FitCategory.undefined) {
      final categories = FitCategory.values.where((c) => c != FitCategory.undefined).toList();
      final index = categories.indexOf(mate.fitCategory!) + 1;
      if (index > 0) {
        ref.read(selectNumProvider.notifier).setSelectNum(index);
      }
    }

    // Set fee state
    if (mate.mateFees.isNotEmpty) {
      ref.read(hasMateFeeProvider.notifier).setHasMateFee(true);
    }

    ref.read(fileViewModelProvider).reset();
    ref.read(keepImageIdsProvider.notifier).state = List<int>.from(mate.introImageIds);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MateRegisterView1(),
      ),
    );
  }

  Future<void> _closeMate(Mate mate) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('모집 마감', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Text('모집을 마감하시겠습니까?\n마감 후에는 새로운 신청을 받을 수 없습니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('취소', style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('마감하기', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(mateRepositoryProvider).closeMate(widget.mateId);
      ref.invalidate(mateDetailProvider(widget.mateId));
      ref.read(mateAsyncViewModelProvider.notifier).refresh();
      if (mounted) {
        AppSnackBar.show(context, message: '모집이 마감되었습니다.', type: SnackBarType.success);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, message: '마감에 실패했습니다.', type: SnackBarType.error);
      }
    }
  }

  Future<void> _navigateToChatRoom(Mate mate) async {
    try {
      final chatRooms = await ref.read(chatRepositoryProvider).getMyChatRooms();
      final room = chatRooms.where((r) => r.matingId == widget.mateId).firstOrNull;
      if (room != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomView(
              roomId: room.roomId,
              roomName: mate.title,
              memberAccountIds: room.memberAccountIds,
              matingId: room.matingId,
            ),
          ),
        );
      } else if (mounted) {
        AppSnackBar.show(context, message: '채팅방을 찾을 수 없습니다.', type: SnackBarType.error);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, message: '채팅방 입장에 실패했습니다.', type: SnackBarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final double imageHeight = (deviceSize.height * 0.38).clamp(250.0, 400.0);
    final detailState = ref.watch(mateDetailProvider(widget.mateId));

    return detailState.when(
      loading: () => Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(backgroundColor: Color(0xffF5F5F5), elevation: 0),
        body: DetailViewSkeleton(deviceSize: deviceSize),
      ),
      error: (error, __) => Scaffold(
        body: CustomAlert(
          title: error.toString(),
          deviceSize: deviceSize,
        ),
      ),
      data: (detail) {
        final mate = detail.mate;
        final myAccountId = detail.myAccountId;
        final isWished = _wishedOverride ?? detail.isWished;
        final currentImage = _currentImage;
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
            actions: [
              if (myAccountId != null)
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.black),
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == 'edit') _navigateToEdit(mate);
                    if (value == 'cancel') _showCancelDialog(mate);
                    if (value == 'close') _closeMate(mate);
                  },
                  itemBuilder: (context) {
                    final items = <PopupMenuEntry<String>>[];
                    final isWriter = mate.writerAccountId == myAccountId;
                    if (isWriter) {
                      if (!mate.closed) {
                        items.add(PopupMenuItem(
                          value: 'edit',
                          child: Row(children: [Icon(Icons.edit, size: 20, color: Colors.grey[700]), SizedBox(width: 10), Text('글 수정')]),
                        ));
                        items.add(PopupMenuItem(
                          value: 'close',
                          child: Row(children: [Icon(Icons.block, size: 20, color: Colors.red[400]), SizedBox(width: 10), Text('모집 마감', style: TextStyle(color: Colors.red[400]))]),
                        ));
                      }
                    }
                    if (!isWriter) {
                      final isApproved = mate.approvedAccountIds.contains(myAccountId);
                      final isWaiting = mate.waitingAccountIds.contains(myAccountId);
                      if (isApproved) {
                        items.add(PopupMenuItem(
                          value: 'cancel',
                          child: Row(children: [Icon(Icons.exit_to_app, size: 20, color: Colors.red[400]), SizedBox(width: 10), Text('참여 취소', style: TextStyle(color: Colors.red[400]))]),
                        ));
                      } else if (isWaiting) {
                        items.add(PopupMenuItem(
                          value: 'cancel',
                          child: Row(children: [Icon(Icons.cancel_outlined, size: 20, color: Colors.red[400]), SizedBox(width: 10), Text('신청 취소', style: TextStyle(color: Colors.red[400]))]),
                        ));
                      }
                    }
                    return items;
                  },
                ),
            ],
          ),
          body: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              children: [
                // --- Image + card overlay + profile ---
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: mate.introImageIds.isEmpty
                              ? Image.asset('assets/images/default_intro_image.jpg', fit: BoxFit.cover)
                              : _getIntroImage(mate.introImageIds[currentImage]),
                        ),
                        SizedBox(height: 80),
                      ],
                    ),
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
                          '${currentImage + 1}/$imageCount',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                    if (imageCount > 1) ...[
                      Positioned(
                        left: 8,
                        top: imageHeight / 2 - 18,
                        child: _buildArrowButton(Icons.chevron_left, () {
                          setState(() => _currentImage =
                            currentImage > 0 ? currentImage - 1 : imageCount - 1,
                          );
                        }),
                      ),
                      Positioned(
                        right: 8,
                        top: imageHeight / 2 - 18,
                        child: _buildArrowButton(Icons.chevron_right, () {
                          setState(() => _currentImage =
                            currentImage < imageCount - 1 ? currentImage + 1 : 0,
                          );
                        }),
                      ),
                    ],
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
                // --- Summary info ---
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
                // --- Info section ---
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
                      _buildInfoRow(
                        Icons.wc_rounded,
                        _getTextPermitGender(mate.permitGender),
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
                // --- Introduction ---
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
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                children: [
                  GestureDetector(
                    onTap: _toggleWish,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isWished ? Icons.favorite : Icons.favorite_border,
                          color: isWished ? Colors.orangeAccent : Colors.grey,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildBottomButton(mate, myAccountId, deviceSize)),
                ],
              ),
            ),
          ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButton(Mate mate, int? myAccountId, Size deviceSize) {
    final bool isWriter = myAccountId != null && mate.writerAccountId == myAccountId;
    final bool isApproved = myAccountId != null && mate.approvedAccountIds.contains(myAccountId);
    final bool isWaiting = myAccountId != null && mate.waitingAccountIds.contains(myAccountId);
    final bool isFull = mate.approvedAccountIds.length >= (mate.permitPeopleCnt ?? 0);

    String title;
    bool isEnabled;
    VoidCallback? onTap;

    if (mate.closed) {
      title = '모집 마감';
      isEnabled = false;
      onTap = null;
    } else if (isWriter) {
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
        ref.invalidate(mateDetailProvider(widget.mateId));
        ref.read(mateAsyncViewModelProvider.notifier).refresh();
      };
    } else if (isApproved) {
      title = '채팅방 입장';
      isEnabled = true;
      onTap = () => _navigateToChatRoom(mate);
    } else if (isWaiting) {
      title = '승인 대기중';
      isEnabled = false;
      onTap = null;
    } else if (isFull) {
      title = '모집 마감';
      isEnabled = false;
      onTap = null;
    } else {
      title = '참여 신청하기';
      isEnabled = true;
      onTap = () async {
        await Navigator.push(context, MaterialPageRoute(
          builder: (context) => MateRequestView(mateId: widget.mateId),
        ));
        ref.invalidate(mateDetailProvider(widget.mateId));
        ref.read(mateAsyncViewModelProvider.notifier).refresh();
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
                ref.invalidate(mateDetailProvider(widget.mateId));
                ref.read(mateAsyncViewModelProvider.notifier).refresh();
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
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
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

  String _getTextPermitGender(PermitGender? permitGender) {
    if (permitGender == null) return '누구나';
    switch (permitGender) {
      case PermitGender.ALL: return '누구나 참여 가능';
      case PermitGender.MALE: return '남성만 참여 가능';
      case PermitGender.FEMALE: return '여성만 참여 가능';
    }
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
