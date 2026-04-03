import 'package:fitmate_app/model/mate/MateListItem.dart';
import 'package:fitmate_app/repository/mate/MateRepository.dart';
import 'package:fitmate_app/view/mate/MateDetailView.dart';
import 'package:fitmate_app/widget/CachedProfileImage.dart';
import 'package:fitmate_app/widget/ClosedToggleChip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MyMateListView extends ConsumerStatefulWidget {
  const MyMateListView({super.key});

  @override
  ConsumerState<MyMateListView> createState() => _MyMateListViewState();
}

class _MyMateListViewState extends ConsumerState<MyMateListView> {
  List<MateListItem> _myMates = [];
  bool _isLoading = true;
  bool _showClosed = false;

  @override
  void initState() {
    super.initState();
    _loadMyMates();
  }

  Future<void> _loadMyMates() async {
    try {
      final myMates = await ref.read(mateRepositoryProvider).getMyMates();
      if (mounted) {
        setState(() {
          _myMates = myMates;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '나의 메이트 모집 내역',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(deviceSize.width * 0.04, 8, deviceSize.width * 0.04, 4),
                  child: Row(
                    children: [
                      ClosedToggleChip(
                        isActive: _showClosed,
                        onTap: () => setState(() => _showClosed = !_showClosed),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Builder(builder: (context) {
                    final filtered = _showClosed ? _myMates : _myMates.where((item) => !item.closed).toList();
                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          '작성한 모집글이 없습니다.',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: deviceSize.width * 0.04,
                        vertical: deviceSize.height * 0.01,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: deviceSize.height * 0.015),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return _buildMateItem(item, deviceSize);
                      },
                    );
                  }),
                ),
              ],
            ),
    );
  }

  Widget _buildMateItem(MateListItem item, Size deviceSize) {
    return GestureDetector(
      key: ValueKey(item.id),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MateDetailView(mateId: item.id),
          ),
        );
        _loadMyMates();
      },
      child: Stack(
        children: [
          Opacity(
            opacity: item.closed ? 0.4 : 1.0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xffE8E8E8)),
              ),
              child: Row(
                children: [
                  _buildThumbnail(item.thumbnailImageId, deviceSize),
                  SizedBox(width: deviceSize.width * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.group, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${item.approvedAccountCnt}/${item.permitPeopleCnt}',
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(item.mateAt),
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
          if (item.closed)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('마감', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(int? thumbnailImageId, Size deviceSize) {
    return CachedThumbnailImage(
      imageId: thumbnailImageId,
      width: deviceSize.width * 0.18,
      height: deviceSize.width * 0.18,
      borderRadius: 8,
    );
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
