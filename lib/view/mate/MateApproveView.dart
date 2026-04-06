import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/widget/AppSnackBar.dart';
import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/repository/mate/MateRepository.dart';
import 'package:fitmate_app/view_model/mate/MateAsyncViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateDetailViewModel.dart';
import 'package:fitmate_app/view/account/UserProfileView.dart';
import 'package:fitmate_app/widget/CachedProfileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MateApproveView extends ConsumerStatefulWidget {
  final int mateId;
  final List<int> waitingAccountIds;
  final List<int> approvedAccountIds;

  const MateApproveView({
    super.key,
    required this.mateId,
    required this.waitingAccountIds,
    required this.approvedAccountIds,
  });

  @override
  ConsumerState<MateApproveView> createState() => _MateApproveViewState();
}

class _MateApproveViewState extends ConsumerState<MateApproveView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<int, AccountProfile> _profileCache = {};
  late List<int> _waitingIds;
  late List<int> _approvedIds;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _waitingIds = List.from(widget.waitingAccountIds);
    _approvedIds = List.from(widget.approvedAccountIds);
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final allIds = {..._waitingIds, ..._approvedIds};
    final imageIds = <int?>[];
    await Future.wait(allIds.map((id) async {
      try {
        final profile = await ref
            .read(accountRepositoryProvider)
            .getProfileByAccountId(id);
        _profileCache[id] = profile;
        imageIds.add(profile.profileImageId);
      } catch (_) {}
    }));
    await ref.read(imageCacheServiceProvider).ensureLoaded(imageIds);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _approveUser(int accountId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          '신청 승인',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Text(
          '${_profileCache[accountId]?.nickName ?? ''}님의 참여를 승인하시겠습니까?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('승인', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(mateRepositoryProvider).approveMate(widget.mateId, accountId);
      ref.invalidate(mateDetailProvider(widget.mateId));
      ref.read(mateAsyncViewModelProvider.notifier).refresh();
      if (mounted) {
        setState(() {
          _waitingIds.remove(accountId);
          _approvedIds.add(accountId);
        });
        AppSnackBar.show(context, message: '${_profileCache[accountId]?.nickName ?? ''}님을 승인했습니다.', type: SnackBarType.success);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, message: '승인에 실패했습니다.', type: SnackBarType.error);
      }
    }
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
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '신청 관리',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
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
          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          tabs: [
            Tab(text: '대기중 ${_waitingIds.length}'),
            Tab(text: '승인됨 ${_approvedIds.length}'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(_waitingIds, showApproveButton: true),
                _buildList(_approvedIds, showApproveButton: false),
              ],
            ),
    );
  }

  Widget _buildList(List<int> accountIds, {required bool showApproveButton}) {
    if (accountIds.isEmpty) {
      return Center(
        child: Text(
          showApproveButton ? '대기중인 신청이 없습니다.' : '승인된 참여자가 없습니다.',
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: accountIds.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final accountId = accountIds[index];
        final profile = _profileCache[accountId];

        return ListTile(
          key: ValueKey(accountId),
          leading: _buildProfileImage(profile?.profileImageId, 44),
          title: Text(
            profile?.nickName ?? '...',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          subtitle: profile?.introduction != null && profile!.introduction.isNotEmpty
              ? Text(
                  profile.introduction,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: showApproveButton
              ? ElevatedButton(
                  onPressed: () => _approveUser(accountId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('승인'),
                )
              : Icon(Icons.check_circle, color: Colors.orangeAccent.shade400, size: 24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileView(accountId: accountId),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileImage(int? profileImageId, double size) {
    return CachedProfileImage(imageId: profileImageId, size: size);
  }
}
