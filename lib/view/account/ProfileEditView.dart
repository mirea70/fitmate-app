import 'dart:typed_data';

import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/repository/file/FileRepository.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:fitmate_app/view_model/account/MyProfileViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' show DioException;

class ProfileEditView extends ConsumerStatefulWidget {
  final AccountProfile profile;

  const ProfileEditView({super.key, required this.profile});

  @override
  ConsumerState<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends ConsumerState<ProfileEditView> {
  late TextEditingController _nickNameController;
  late TextEditingController _introductionController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  int? _profileImageId;
  Uint8List? _newImageBytes;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nickNameController = TextEditingController(text: widget.profile.nickName);
    _introductionController = TextEditingController(text: widget.profile.introduction);
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _emailController = TextEditingController(text: widget.profile.email);
    _profileImageId = widget.profile.profileImageId;
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _introductionController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('카메라로 촬영'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (image != null) await _uploadImage(image);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('갤러리에서 선택'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (image != null) await _uploadImage(image);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImage(XFile image) async {
    try {
      final files = await ref.read(fileRepositoryProvider).uploadFiles([image.path]);
      if (files.isNotEmpty) {
        final bytes = await image.readAsBytes();
        setState(() {
          _profileImageId = files[0]['attachFileId'];
          _newImageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => CustomAlert(
            title: '이미지 업로드에 실패했습니다.',
            deviceSize: MediaQuery.of(context).size,
          ),
        );
      }
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(accountRepositoryProvider).updateProfile(
        nickName: _nickNameController.text,
        introduction: _introductionController.text,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        profileImageId: _profileImageId,
      );
      ref.invalidate(myProfileProvider);
      if (mounted) Navigator.pop(context);
    } on DioException catch (e) {
      if (mounted) {
        final message = e.response?.data?['message'] ?? '프로필 수정에 실패했습니다.';
        showDialog(
          context: context,
          builder: (context) => CustomAlert(
            title: message,
            deviceSize: MediaQuery.of(context).size,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '프로필 수정',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orangeAccent,
                      ),
                    ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.05),
            child: Column(
              children: [
                SizedBox(height: deviceSize.height * 0.03),
                // 프로필 이미지
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      _buildCurrentProfileImage(deviceSize),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.04),
                _buildEditField('닉네임', _nickNameController, maxLength: 10),
                SizedBox(height: deviceSize.height * 0.02),
                _buildEditField('자기소개', _introductionController, maxLength: 50),
                SizedBox(height: deviceSize.height * 0.02),
                _buildEditField('이름', _nameController, maxLength: 5),
                SizedBox(height: deviceSize.height * 0.02),
                _buildEditField('전화번호', _phoneController, maxLength: 11),
                SizedBox(height: deviceSize.height * 0.02),
                _buildEditField('이메일', _emailController, maxLength: 30),
                SizedBox(height: deviceSize.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentProfileImage(Size deviceSize) {
    if (_newImageBytes != null) {
      return _buildCircle(MemoryImage(_newImageBytes!), deviceSize);
    }
    if (_profileImageId != null && _profileImageId == widget.profile.profileImageId) {
      return FutureBuilder<Uint8List>(
        future: ref.read(fileRepositoryProvider).downloadFile(_profileImageId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return _buildCircle(MemoryImage(snapshot.data!), deviceSize);
          }
          return DefaultProfileImage(size: deviceSize.width * 0.25);
        },
      );
    }
    return DefaultProfileImage(size: deviceSize.width * 0.25);
  }

  Widget _buildCircle(ImageProvider imageProvider, Size deviceSize) {
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

  Widget _buildEditField(String label, TextEditingController controller, {int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLength: maxLength,
          decoration: InputDecoration(
            counterText: '',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Color(0xffE8E8E8), width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}
