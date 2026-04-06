import 'package:fitmate_app/config/Const.dart';
import 'package:fitmate_app/config/SecureStorage.dart';
import 'package:fitmate_app/model/account/Account.dart';
import 'package:fitmate_app/repository/auth/AuthRepository.dart';
import 'package:fitmate_app/view/mate/MainView.dart';
import 'package:fitmate_app/widget/AppSnackBar.dart';
import 'package:fitmate_app/widget/BirthDatePicker.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileCompleteView extends ConsumerStatefulWidget {
  final String kakaoAccessToken;
  final String kakaoNickName;
  final String kakaoEmail;

  const ProfileCompleteView({
    super.key,
    required this.kakaoAccessToken,
    required this.kakaoNickName,
    required this.kakaoEmail,
  });

  @override
  ConsumerState<ProfileCompleteView> createState() => _ProfileCompleteViewState();
}

class _ProfileCompleteViewState extends ConsumerState<ProfileCompleteView> {
  late String _nickName;
  late String _email;
  String _name = '';
  Gender? _gender;
  String? _birthDate;
  String _phone = '';
  bool _isSubmitting = false;

  String? _nameError;
  String? _phoneError;
  String? _nickNameError;

  @override
  void initState() {
    super.initState();
    _nickName = widget.kakaoNickName;
    _email = widget.kakaoEmail;
  }

  void _validateName(String value) {
    if (!RegExp(r'^[가-힣]{2,5}$').hasMatch(value)) {
      setState(() => _nameError = '2~5자의 한글로 입력해주세요');
    } else {
      setState(() => _nameError = null);
    }
  }

  void _validatePhone(String value) {
    if (!RegExp(r'^010\d{4}\d{4}$').hasMatch(value)) {
      setState(() => _phoneError = '010으로 시작하는 11자리 번호를 입력해주세요');
    } else {
      setState(() => _phoneError = null);
    }
  }

  void _validateNickName(String value) {
    if (!RegExp(r'^[a-zA-Zㄱ-힣\d\s]{2,10}$').hasMatch(value)) {
      setState(() => _nickNameError = '2~10자의 한글/영문/숫자로 입력해주세요');
    } else {
      setState(() => _nickNameError = null);
    }
  }

  bool _isFormValid() {
    return _name.isNotEmpty &&
        _nickName.isNotEmpty &&
        _gender != null &&
        _birthDate != null &&
        _phone.isNotEmpty &&
        _nameError == null &&
        _phoneError == null &&
        _nickNameError == null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final loginResponse = await ref.read(authRepositoryProvider).kakaoRegister(
        kakaoAccessToken: widget.kakaoAccessToken,
        name: _name,
        gender: _gender!.name,
        birthDate: _birthDate!,
        phone: _phone,
        nickName: _nickName,
        email: _email.isNotEmpty ? _email : null,
      );

      final FlutterSecureStorage storage = ref.read(secureStorageProvider);
      await storage.write(key: accessTokenKey, value: loginResponse.accessToken);
      await storage.write(key: refreshTokenKey, value: loginResponse.refreshToken);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainView()),
          (route) => false,
        );
        AppSnackBar.show(context,
            message: '환영합니다! 지금 바로 운동 메이트를 만나보세요!',
            type: SnackBarType.success);
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = '회원가입에 실패했습니다.';
        try {
          final dioError = e as dynamic;
          errorMsg = dioError.response?.data['message'] ?? errorMsg;
        } catch (_) {}
        showDialog(
          context: context,
          builder: (context) => CustomAlert(
            title: errorMsg,
            deviceSize: MediaQuery.of(context).size,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          resizeToAvoidBottomInset: true,
          body: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraint.maxHeight,
                    minWidth: constraint.maxWidth,
                  ),
                  child: Container(
                      padding: EdgeInsets.only(left: deviceSize.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: deviceSize.width * 0.8,
                              height: deviceSize.height * 0.05,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orangeAccent,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '거의 다 왔어요! 기본 정보만 입력해주세요',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: deviceSize.height * 0.04),
                          // 닉네임
                          Text('닉네임', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          SizedBox(height: deviceSize.height * 0.01),
                          CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) {
                              _nickName = value;
                              _validateNickName(value);
                            },
                            hintText: '닉네임을 입력해주세요',
                            errorText: _nickNameError,
                            maxLength: 10,
                            text: _nickName,
                          ),
                          SizedBox(height: deviceSize.height * 0.04),
                          // 이름
                          Text('이름', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          SizedBox(height: deviceSize.height * 0.01),
                          CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) {
                              _name = value;
                              _validateName(value);
                            },
                            hintText: '홍길동',
                            errorText: _nameError,
                            maxLength: 5,
                            text: _name,
                          ),
                          SizedBox(height: deviceSize.height * 0.04),
                          // 성별
                          Text('성별', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          SizedBox(height: deviceSize.height * 0.01),
                          Padding(
                            padding: EdgeInsets.only(right: deviceSize.width * 0.05),
                            child: Row(
                              children: [
                                Radio(
                                  value: Gender.MALE,
                                  activeColor: Colors.orangeAccent,
                                  groupValue: _gender,
                                  onChanged: (value) => setState(() => _gender = value),
                                ),
                                Text('남성', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                                SizedBox(width: deviceSize.width * 0.2),
                                Radio(
                                  value: Gender.FEMALE,
                                  activeColor: Colors.orangeAccent,
                                  groupValue: _gender,
                                  onChanged: (value) => setState(() => _gender = value),
                                ),
                                Text('여성', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          SizedBox(height: deviceSize.height * 0.04),
                          // 생년월일
                          Text('생년월일', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          SizedBox(height: deviceSize.height * 0.01),
                          BirthDatePicker(
                            initialDate: _birthDate,
                            onDateChanged: (value) => setState(() => _birthDate = value),
                          ),
                          SizedBox(height: deviceSize.height * 0.04),
                          // 전화번호
                          Text('전화번호', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          SizedBox(height: deviceSize.height * 0.01),
                          CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) {
                              _phone = value;
                              _validatePhone(value);
                            },
                            hintText: '01012345678',
                            errorText: _phoneError,
                            maxLength: 11,
                            text: _phone,
                          ),
                          SizedBox(height: deviceSize.height * 0.02),
                        ],
                      ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            elevation: 0,
            child: Column(
              children: [
                Center(
                  child: CustomButton(
                    deviceSize: deviceSize,
                    onTapMethod: _isFormValid() ? _submit : () {},
                    title: _isSubmitting ? '가입 중...' : '시작하기',
                    isEnabled: _isFormValid() && !_isSubmitting,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
