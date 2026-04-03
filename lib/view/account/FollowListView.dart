import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/view/account/UserProfileView.dart';
import 'package:fitmate_app/widget/CachedProfileImage.dart';
import 'package:fitmate_app/widget/ShimmerLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowListView extends ConsumerStatefulWidget {
  final bool isFollowers;
  final List<int> followerIds;
  final List<int> followingIds;

  const FollowListView({
    super.key,
    required this.isFollowers,
    required this.followerIds,
    required this.followingIds,
  });

  @override
  ConsumerState<FollowListView> createState() => _FollowListViewState();
}

class _FollowListViewState extends ConsumerState<FollowListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<int, AccountProfile> _profileCache = {};
  List<AccountProfile> _followers = [];
  List<AccountProfile> _followings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isFollowers ? 0 : 1,
    );
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      final repo = ref.read(accountRepositoryProvider);
      final allIds = {...widget.followerIds, ...widget.followingIds};

      await Future.wait(allIds.map((id) async {
        try {
          final profile = await repo.getProfileByAccountId(id);
          _profileCache[id] = profile;
        } catch (_) {}
      }));

      ref.read(imageCacheServiceProvider).preloadInBackground(
        _profileCache.values.map((p) => p.profileImageId).toList(),
      );

      if (mounted) {
        setState(() {
          _followers = widget.followerIds
              .where((id) => _profileCache.containsKey(id))
              .map((id) => _profileCache[id]!)
              .toList();
          _followings = widget.followingIds
              .where((id) => _profileCache.containsKey(id))
              .map((id) => _profileCache[id]!)
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
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
          '팔로우',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
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
            Tab(text: '팔로워 ${widget.followerIds.length}'),
            Tab(text: '팔로잉 ${widget.followingIds.length}'),
          ],
        ),
      ),
      body: _isLoading
          ? const ChatListSkeleton()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(_followers),
                _buildList(_followings),
              ],
            ),
    );
  }

  Widget _buildList(List<AccountProfile> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          '목록이 비어있습니다.',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final profile = list[index];
        return ListTile(
          key: ValueKey(profile.accountId),
          leading: _buildProfileImage(profile.profileImageId, 44),
          title: Text(
            profile.nickName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileView(accountId: profile.accountId),
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
