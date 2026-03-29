import 'dart:typed_data';

import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/repository/chat/ChatRepository.dart';
import 'package:fitmate_app/repository/file/FileRepository.dart';
import 'package:fitmate_app/view/account/LoginView.dart';
import 'package:fitmate_app/view/account/MateRequestListView.dart';
import 'package:fitmate_app/view/account/NoticeListView.dart';
import 'package:fitmate_app/view/account/ProfileEditView.dart';
import 'package:fitmate_app/view/chat/ChatRoomView.dart';
import 'package:fitmate_app/view_model/account/MyProfileViewModel.dart';
import 'package:fitmate_app/view_model/account/login/LoginViewModel.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:fitmate_app/view/mate/MainView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileView extends ConsumerStatefulWidget {
  final int accountId;

  const UserProfileView({super.key, required this.accountId});

  @override
  ConsumerState<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends ConsumerState<UserProfileView> {
  bool _isFollowing = false;
  int _followerCount = 0;

  void _initFollowState(AccountProfile profile, AccountProfile? myProfile) {
    if (myProfile != null) {
      _isFollowing = myProfile.followings.contains(widget.accountId);
    }
    _followerCount = profile.followers.length;
  }

  Future<void> _toggleFollow() async {
    try {
      await ref.read(accountRepositoryProvider).followUser(widget.accountId);
      setState(() {
        _isFollowing = !_isFollowing;
        _followerCount += _isFollowing ? 1 : -1;
      });
      ref.invalidate(myProfileProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('팔로우 요청에 실패했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final myProfileAsync = ref.watch(myProfileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_rounded), label: '추가'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        onTap: (int index) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainView()),
            (route) => false,
          );
        },
      ),
      body: FutureBuilder<AccountProfile>(
        future: ref.read(accountRepositoryProvider).getProfileByAccountId(widget.accountId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '프로필을 불러올 수 없습니다.',
                style: TextStyle(fontSize: 17, color: Colors.grey),
              ),
            );
          }
          final profile = snapshot.data!;
          final myProfile = myProfileAsync.whenOrNull(data: (p) => p);
          final bool isMe = myProfile?.accountId == widget.accountId;

          if (_followerCount == 0 && !_isFollowing) {
            _initFollowState(profile, myProfile);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                if (isMe)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: deviceSize.width * 0.04, top: deviceSize.height * 0.01),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEditView(profile: profile),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '프로필 수정',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: deviceSize.height * (isMe ? 0.01 : 0.02)),
                _buildProfileImage(profile.profileImageId, deviceSize),
                SizedBox(height: deviceSize.height * 0.02),
                Text(
                  profile.nickName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: deviceSize.height * 0.005),
                if (profile.introduction.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.1),
                    child: Text(
                      profile.introduction,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w400),
                    ),
                  ),
                SizedBox(height: deviceSize.height * 0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatColumn('팔로워', _followerCount),
                    SizedBox(width: deviceSize.width * 0.15),
                    _buildStatColumn('팔로잉', profile.followings.length),
                  ],
                ),
                if (!isMe) ...[
                  SizedBox(height: deviceSize.height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.1),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: _toggleFollow,
                              icon: Icon(
                                _isFollowing ? Icons.person_remove_outlined : Icons.person_add_outlined,
                                size: 18,
                              ),
                              label: Text(_isFollowing ? '팔로잉' : '팔로우'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFollowing ? Colors.white : Colors.black,
                                foregroundColor: _isFollowing ? Colors.black : Colors.white,
                                side: _isFollowing
                                    ? BorderSide(color: Colors.grey.shade300)
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () => _startDm(profile),
                              icon: const Icon(Icons.chat_bubble_outline, size: 18),
                              label: const Text('DM'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: deviceSize.height * (isMe ? 0.03 : 0.02)),
                Divider(color: Color(0xffE8E8E8), thickness: 8),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceSize.width * 0.05,
                    vertical: deviceSize.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMe ? '내 정보' : '기본 정보',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: deviceSize.height * 0.015),
                      _buildInfoRow('이름', profile.name),
                      if (isMe) _buildInfoRow('아이디', profile.loginName),
                      _buildInfoRow('닉네임', profile.nickName),
                      if (isMe) _buildInfoRow('이메일', profile.email),
                      if (isMe) _buildInfoRow('전화번호', profile.phone),
                      if (profile.introduction.isNotEmpty)
                        _buildInfoRow('소개', profile.introduction),
                      _buildInfoRow('성별', profile.gender == 'MALE' ? '남성' : '여성'),
                    ],
                  ),
                ),
                if (isMe) ...[
                  Divider(color: Color(0xffE8E8E8), thickness: 8),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: '알림',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NoticeListView()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.calendar_today_outlined,
                    title: '나의 메이트 신청 내역',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MateRequestListView()),
                      );
                    },
                  ),
                  Divider(color: Color(0xffE8E8E8), thickness: 8),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: '로그아웃',
                    titleColor: Colors.redAccent,
                    onTap: () async {
                      await ref.read(loginViewModelProvider.notifier).logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginView()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.person_off_outlined,
                    title: '회원탈퇴',
                    titleColor: Colors.grey,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              '회원탈퇴',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            content: Text(
                              '탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.\n\n정말 탈퇴하시겠습니까?',
                              style: TextStyle(fontSize: 15),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text(
                                  '취소',
                                  style: TextStyle(color: Colors.grey, fontSize: 15),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(dialogContext);
                                  try {
                                    await ref.read(accountRepositoryProvider).deleteAccount(profile.accountId);
                                    await ref.read(loginViewModelProvider.notifier).logout();
                                    if (context.mounted) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => LoginView()),
                                        (route) => false,
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('회원탈퇴에 실패했습니다.')),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  '탈퇴',
                                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 15),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: deviceSize.height * 0.03),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _startDm(AccountProfile profile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final myProfile = await ref.read(accountRepositoryProvider).getMyProfile();
      final room = await ref.read(chatRepositoryProvider).createDmRoom({
        'fromAccountId': myProfile.accountId,
        'toAccountId': profile.accountId,
      });

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomView(
            roomId: room.roomId,
            roomName: profile.nickName,
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('채팅방을 생성할 수 없습니다.')),
      );
    }
  }

  Widget _buildProfileImage(int? profileImageId, Size deviceSize) {
    final double size = deviceSize.width * 0.25;
    if (profileImageId == null) {
      return DefaultProfileImage(size: size);
    }
    return FutureBuilder<Uint8List>(
      future: ref.read(fileRepositoryProvider).downloadFile(profileImageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return _buildProfileCircle(MemoryImage(snapshot.data!), deviceSize);
        }
        return DefaultProfileImage(size: size);
      },
    );
  }

  Widget _buildProfileCircle(ImageProvider imageProvider, Size deviceSize) {
    return Container(
      width: deviceSize.width * 0.25,
      height: deviceSize.width * 0.25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        border: Border.all(color: Color(0xffE8E8E8), width: 2),
      ),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
