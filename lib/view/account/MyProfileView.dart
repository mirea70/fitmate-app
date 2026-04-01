import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/widget/AppSnackBar.dart';
import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:fitmate_app/view/account/FollowListView.dart';
import 'package:fitmate_app/view/mate/WishListView.dart';
import 'package:fitmate_app/view/account/LoginView.dart';
import 'package:fitmate_app/view/account/MateRequestListView.dart';
import 'package:fitmate_app/view/mate/MyMateListView.dart';
import 'package:fitmate_app/view/account/NoticeListView.dart';
import 'package:fitmate_app/view/account/ProfileEditView.dart';
import 'package:fitmate_app/view_model/account/MyProfileViewModel.dart';
import 'package:fitmate_app/view_model/account/login/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProfileView extends ConsumerStatefulWidget {
  const MyProfileView({super.key});

  @override
  ConsumerState<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends ConsumerState<MyProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.invalidate(myProfileProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final profileAsync = ref.watch(myProfileProvider);

    return profileAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          '프로필을 불러올 수 없습니다.',
          style: TextStyle(fontSize: 17, color: Colors.grey),
        ),
      ),
      data: (profile) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // 프로필 수정 버튼 (우측 상단)
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
              SizedBox(height: deviceSize.height * 0.01),
              // 프로필 이미지
              _buildProfileImage(profile.profileImageId, deviceSize),
              SizedBox(height: deviceSize.height * 0.02),
              // 닉네임
              Text(
                profile.nickName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: deviceSize.height * 0.005),
              // 소개
              if (profile.introduction.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.1),
                  child: Text(
                    profile.introduction,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              SizedBox(height: deviceSize.height * 0.025),
              // 팔로워 / 팔로잉
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatColumn('팔로워', profile.followers.length, onTap: () => _navigateToFollowList(true, profile)),
                  SizedBox(width: deviceSize.width * 0.15),
                  _buildStatColumn('팔로잉', profile.followings.length, onTap: () => _navigateToFollowList(false, profile)),
                ],
              ),
              SizedBox(height: deviceSize.height * 0.03),
              Divider(color: Color(0xffE8E8E8), thickness: 8),
              // 내 정보
              _buildInfoSection(profile, deviceSize),
              Divider(color: Color(0xffE8E8E8), thickness: 8),
              // 메뉴
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
                icon: Icons.favorite_border,
                title: '나의 찜 목록',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WishListView()),
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
              _buildMenuItem(
                icon: Icons.how_to_reg_outlined,
                title: '나의 메이트 모집 내역',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyMateListView()),
                  );
                },
              ),
              Divider(color: Color(0xffE8E8E8), thickness: 8),
              // 로그아웃
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
              // 회원탈퇴
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
                                  AppSnackBar.show(context, message: '회원탈퇴에 실패했습니다.', type: SnackBarType.error);
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
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(int? profileImageId, Size deviceSize) {
    final double size = deviceSize.width * 0.25;
    final data = profileImageId != null
        ? ref.read(imageCacheServiceProvider).get(profileImageId)
        : null;
    if (data != null) {
      return _buildProfileCircle(MemoryImage(data), deviceSize);
    }
    return DefaultProfileImage(size: size);
  }

  Widget _buildProfileCircle(ImageProvider imageProvider, Size deviceSize) {
    return Container(
      width: deviceSize.width * 0.25,
      height: deviceSize.width * 0.25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
        border: Border.all(color: Color(0xffE8E8E8), width: 2),
      ),
    );
  }

  void _navigateToFollowList(bool isFollowers, AccountProfile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowListView(
          isFollowers: isFollowers,
          followerIds: profile.followers,
          followingIds: profile.followings,
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int count, {VoidCallback? onTap}) {
    final column = Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: column);
    }
    return column;
  }

  Widget _buildInfoSection(profile, Size deviceSize) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: deviceSize.width * 0.05,
        vertical: deviceSize.height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내 정보',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: deviceSize.height * 0.015),
          _buildInfoRow('이름', profile.name),
          _buildInfoRow('아이디', profile.loginName),
          _buildInfoRow('이메일', profile.email),
          _buildInfoRow('전화번호', profile.phone),
          _buildInfoRow('성별', profile.gender == 'MALE' ? '남성' : '여성'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
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
