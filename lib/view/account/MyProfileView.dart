import 'dart:typed_data';

import 'package:fitmate_app/repository/file/FileRepository.dart';
import 'package:fitmate_app/view/account/LoginView.dart';
import 'package:fitmate_app/view_model/account/MyProfileViewModel.dart';
import 'package:fitmate_app/view_model/account/login/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProfileView extends ConsumerWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              SizedBox(height: deviceSize.height * 0.03),
              // 프로필 이미지
              _buildProfileImage(ref, profile.profileImageId, deviceSize),
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
                  _buildStatColumn('팔로워', profile.followers.length),
                  SizedBox(width: deviceSize.width * 0.15),
                  _buildStatColumn('팔로잉', profile.followings.length),
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
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.calendar_today_outlined,
                title: '내 메이트 신청 내역',
                onTap: () {},
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
              SizedBox(height: deviceSize.height * 0.03),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(WidgetRef ref, int? profileImageId, Size deviceSize) {
    if (profileImageId == null) {
      return _buildProfileCircle(AssetImage('assets/images/default_profile.jpeg'), deviceSize);
    }
    return FutureBuilder<Uint8List>(
      future: ref.read(fileRepositoryProvider).downloadFile(profileImageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return _buildProfileCircle(MemoryImage(snapshot.data!), deviceSize);
        }
        return _buildProfileCircle(AssetImage('assets/images/default_profile.jpeg'), deviceSize);
      },
    );
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

  Widget _buildStatColumn(String label, int count) {
    return Column(
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
