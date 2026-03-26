import 'dart:typed_data';

import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/repository/file/FileRepository.dart';
import 'package:fitmate_app/view/mate/MainView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileView extends ConsumerWidget {
  final int accountId;

  const UserProfileView({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;

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
        future: ref.read(accountRepositoryProvider).getProfileByAccountId(accountId),
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
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: deviceSize.height * 0.02),
                _buildProfileImage(ref, profile.profileImageId, deviceSize),
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
                    _buildStatColumn('팔로워', profile.followers.length),
                    SizedBox(width: deviceSize.width * 0.15),
                    _buildStatColumn('팔로잉', profile.followings.length),
                  ],
                ),
                SizedBox(height: deviceSize.height * 0.03),
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
                        '기본 정보',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: deviceSize.height * 0.015),
                      _buildInfoRow('이름', profile.name),
                      _buildInfoRow('닉네임', profile.nickName),
                      if (profile.introduction.isNotEmpty)
                        _buildInfoRow('소개', profile.introduction),
                      _buildInfoRow('성별', profile.gender == 'MALE' ? '남성' : '여성'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
