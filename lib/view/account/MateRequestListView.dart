import 'package:fitmate_app/model/account/MateRequestResponse.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/view/mate/MateDetailView.dart';
import 'package:fitmate_app/widget/CachedProfileImage.dart';
import 'package:fitmate_app/widget/ShimmerLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final mateRequestWaitProvider = FutureProvider.autoDispose<List<MateRequestResponse>>((ref) async {
  return ref.read(accountRepositoryProvider).getMyMateRequests('WAIT');
});

final mateRequestApproveProvider = FutureProvider.autoDispose<List<MateRequestResponse>>((ref) async {
  return ref.read(accountRepositoryProvider).getMyMateRequests('APPROVE');
});

class MateRequestListView extends ConsumerStatefulWidget {
  const MateRequestListView({super.key});

  @override
  ConsumerState<MateRequestListView> createState() => _MateRequestListViewState();
}

class _MateRequestListViewState extends ConsumerState<MateRequestListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '나의 메이트 신청 내역',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(8),
          ),
          dividerColor: Colors.transparent,
          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          tabs: [
            Tab(text: '대기중'),
            Tab(text: '승인됨'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MateRequestTab(provider: mateRequestWaitProvider),
          _MateRequestTab(provider: mateRequestApproveProvider),
        ],
      ),
    );
  }
}

class _MateRequestTab extends ConsumerStatefulWidget {
  final FutureProvider<List<MateRequestResponse>> provider;

  const _MateRequestTab({required this.provider});

  @override
  ConsumerState<_MateRequestTab> createState() => _MateRequestTabState();
}

class _MateRequestTabState extends ConsumerState<_MateRequestTab> {
  List<MateRequestResponse> _requests = [];
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final requests = await ref.read(widget.provider.future);

      if (mounted) {
        setState(() {
          _requests = requests;
          _isReady = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isReady = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    if (!_isReady) {
      return MateListSkeleton(deviceSize: deviceSize);
    }

    if (_requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 50, color: Colors.grey),
            SizedBox(height: deviceSize.height * 0.02),
            Text(
              '신청 내역이 없습니다.',
              style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: deviceSize.width * 0.04,
            vertical: deviceSize.height * 0.02,
          ),
          itemCount: _requests.length,
          separatorBuilder: (context, index) => SizedBox(height: deviceSize.height * 0.015),
          itemBuilder: (context, index) {
            final item = _requests[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MateDetailView(mateId: item.mateId),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xffE8E8E8)),
                ),
                child: IntrinsicHeight(
                  child: Row(
                  children: [
                    _buildThumbnail(item.thumbnailImageId, deviceSize),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              if (item.fitCategory != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xffF1F1F1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.fitCategory!.label,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              const SizedBox(width: 6),
                              if (item.approveStatus != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: item.approveStatus == 'APPROVE'
                                        ? Colors.green.shade50
                                        : Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.approveStatus == 'APPROVE' ? '승인' : '대기중',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: item.approveStatus == 'APPROVE'
                                          ? Colors.green.shade700
                                          : Colors.orange.shade700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.title,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_pin, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${_extractAddress(item.fitPlaceAddress)} ∙ ${_formatDate(item.mateAt)}',
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.group, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${item.approvedAccountCnt + 1}/${item.permitPeopleCnt}',
                                style: TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            '신청일: ${DateFormat('yy.M.d').format(item.applyAt)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                ),
              ),
            );
          },
        );
  }

  Widget _buildThumbnail(int? thumbnailImageId, Size deviceSize) {
    final thumbSize = (deviceSize.width * 0.2).clamp(70.0, 120.0);
    return CachedThumbnailImage(
      imageId: thumbnailImageId,
      width: thumbSize,
      height: thumbSize * 1.0,
      borderRadius: 8,
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
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    String datePart = DateFormat('yy.M.d').format(dateTime);
    String weekday = weekdays[dateTime.weekday - 1];
    String amPm = dateTime.hour >= 12 ? '오후' : '오전';
    int hour = dateTime.hour % 12;
    if (hour == 0) hour = 12;
    return '$datePart($weekday) $amPm $hour:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
