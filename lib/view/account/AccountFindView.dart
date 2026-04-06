import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/service/FirebasePhoneAuthService.dart';
import 'package:fitmate_app/widget/AppSnackBar.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountFindView extends ConsumerStatefulWidget {
  const AccountFindView({super.key});

  @override
  ConsumerState<AccountFindView> createState() => _AccountFindViewState();
}

class _AccountFindViewState extends ConsumerState<AccountFindView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(firebasePhoneAuthServiceProvider).reset();
      }
    });
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
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text('계정 찾기', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700)),
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
            Tab(text: '아이디 찾기'),
            Tab(text: '비밀번호 재설정'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FindIdTab(),
          _ResetPasswordTab(),
        ],
      ),
    );
  }
}

// === 아이디 찾기 탭 ===
class _FindIdTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_FindIdTab> createState() => _FindIdTabState();
}

class _FindIdTabState extends ConsumerState<_FindIdTab> {
  String _phone = '';
  String? _phoneError;
  String? _foundLoginName;
  bool _isLoading = false;

  void _validatePhone(String value) {
    if (!RegExp(r'^010\d{4}\d{4}$').hasMatch(value)) {
      setState(() => _phoneError = '010으로 시작하는 11자리 번호를 입력해주세요');
    } else {
      setState(() => _phoneError = null);
    }
  }

  Future<void> _findId() async {
    setState(() => _isLoading = true);
    try {
      final loginName = await ref.read(accountRepositoryProvider).findLoginName(_phone);
      setState(() => _foundLoginName = loginName);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => CustomAlert(
            title: '해당 전화번호로 가입된 계정이 없습니다.',
            deviceSize: MediaQuery.of(context).size,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: deviceSize.height * 0.05),
              Text('가입 시 등록한 전화번호를 입력해주세요',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: deviceSize.height * 0.01),
              Text('전화번호로 로그인 ID를 찾을 수 있습니다.',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              SizedBox(height: deviceSize.height * 0.04),
              Text('전화번호', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              CustomInput(
                deviceSize: deviceSize,
                onChangeMethod: (value) {
                  _phone = value;
                  _validatePhone(value);
                  setState(() => _foundLoginName = null);
                },
                hintText: '01012345678',
                errorText: _phoneError,
                maxLength: 11,
                text: _phone,
              ),
              SizedBox(height: deviceSize.height * 0.04),
              if (_foundLoginName != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xffFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.orangeAccent, size: 40),
                      SizedBox(height: 12),
                      Text('로그인 ID', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      SizedBox(height: 4),
                      Text(_foundLoginName!,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              if (_foundLoginName == null)
                Center(
                  child: CustomButton(
                    deviceSize: deviceSize,
                    onTapMethod: _phone.length == 11 && _phoneError == null && !_isLoading ? _findId : () {},
                    title: _isLoading ? '조회 중...' : '아이디 찾기',
                    isEnabled: _phone.length == 11 && _phoneError == null && !_isLoading,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// === 비밀번호 재설정 탭 ===
class _ResetPasswordTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ResetPasswordTab> createState() => _ResetPasswordTabState();
}

class _ResetPasswordTabState extends ConsumerState<_ResetPasswordTab> {
  int _step = 0; // 0: 아이디/전화번호 입력, 1: 인증번호 확인, 2: 새 비밀번호 설정
  String _loginName = '';
  String _phone = '';
  String _code = '';
  String _newPassword = '';
  String _confirmPassword = '';
  String? _phoneError;
  String? _passwordError;
  String? _confirmError;
  bool _isLoading = false;

  void _validatePhone(String value) {
    if (!RegExp(r'^010\d{4}\d{4}$').hasMatch(value)) {
      setState(() => _phoneError = '010으로 시작하는 11자리 번호를 입력해주세요');
    } else {
      setState(() => _phoneError = null);
    }
  }

  void _validatePassword(String value) {
    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$').hasMatch(value)) {
      setState(() => _passwordError = '8자 이상, 대소문자/숫자/특수문자 포함');
    } else {
      setState(() => _passwordError = null);
    }
  }

  void _validateConfirm(String value) {
    if (value != _newPassword) {
      setState(() => _confirmError = '비밀번호가 일치하지 않습니다');
    } else {
      setState(() => _confirmError = null);
    }
  }

  Future<void> _requestCode() async {
    setState(() => _isLoading = true);
    try {
      // 아이디+전화번호로 계정 존재 확인
      await ref.read(accountRepositoryProvider).checkAccountExists(_loginName, _phone);
      // Firebase로 인증번호 발송
      await ref.read(firebasePhoneAuthServiceProvider).requestCode(_phone);
      setState(() {
        _step = 1;
        _code = '';
      });
      if (mounted) AppSnackBar.show(context, message: '인증번호가 발송되었습니다.', type: SnackBarType.success);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => CustomAlert(
            title: '아이디 또는 전화번호가 일치하는 계정이 없습니다.',
            deviceSize: MediaQuery.of(context).size,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyCode() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(firebasePhoneAuthServiceProvider).verifyCode(_code);
      setState(() {
        _step = 2;
        _newPassword = '';
        _confirmPassword = '';
        _passwordError = null;
        _confirmError = null;
      });
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => CustomAlert(
            title: '인증번호가 올바르지 않습니다.',
            deviceSize: MediaQuery.of(context).size,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(accountRepositoryProvider).resetPassword(_loginName, _phone, _newPassword);
      if (mounted) {
        Navigator.pop(context);
        AppSnackBar.show(context, message: '비밀번호가 변경되었습니다. 새 비밀번호로 로그인해주세요.', type: SnackBarType.success);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => CustomAlert(
            title: '비밀번호 변경에 실패했습니다.',
            deviceSize: MediaQuery.of(context).size,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: deviceSize.height * 0.05),
              if (_step == 0) _buildPhoneStep(deviceSize),
              if (_step == 1) _buildCodeStep(deviceSize),
              if (_step == 2) _buildPasswordStep(deviceSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneStep(Size deviceSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('아이디와 전화번호를 입력해주세요',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: deviceSize.height * 0.01),
        Text('본인 확인 후 비밀번호를 재설정합니다.',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: deviceSize.height * 0.04),
        Text('아이디', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        CustomInput(
          deviceSize: deviceSize,
          onChangeMethod: (value) {
            setState(() => _loginName = value);
          },
          hintText: '가입 시 등록한 아이디',
          maxLength: 20,
          text: _loginName,
        ),
        SizedBox(height: deviceSize.height * 0.03),
        Text('전화번호', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
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
        SizedBox(height: deviceSize.height * 0.04),
        Center(
          child: CustomButton(
            deviceSize: deviceSize,
            onTapMethod: _loginName.isNotEmpty && _phone.length == 11 && _phoneError == null && !_isLoading ? _requestCode : () {},
            title: _isLoading ? '발송 중...' : '인증번호 받기',
            isEnabled: _loginName.isNotEmpty && _phone.length == 11 && _phoneError == null && !_isLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildCodeStep(Size deviceSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('인증번호를 입력해주세요',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: deviceSize.height * 0.02),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orangeAccent, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$_phone (으)로 인증번호가 발송되었습니다. 5분 이내에 입력해주세요.',
                  style: TextStyle(fontSize: 13, color: Colors.brown),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: deviceSize.height * 0.04),
        Text('인증번호', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        CustomInput(
          deviceSize: deviceSize,
          onChangeMethod: (value) => setState(() => _code = value),
          hintText: '인증번호 6자리',
          maxLength: 6,
          text: _code,
        ),
        SizedBox(height: deviceSize.height * 0.04),
        Center(
          child: CustomButton(
            deviceSize: deviceSize,
            onTapMethod: _code.length == 6 && !_isLoading ? _verifyCode : () {},
            title: _isLoading ? '확인 중...' : '인증 확인',
            isEnabled: _code.length == 6 && !_isLoading,
          ),
        ),
        SizedBox(height: deviceSize.height * 0.02),
        Center(
          child: TextButton(
            onPressed: !_isLoading ? () async {
              setState(() => _isLoading = true);
              try {
                await ref.read(firebasePhoneAuthServiceProvider).requestCode(_phone);
                setState(() => _code = '');
                if (mounted) AppSnackBar.show(context, message: '인증번호가 재발송되었습니다.', type: SnackBarType.success);
              } catch (e) {
                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => CustomAlert(
                      title: '인증번호 재발송에 실패했습니다.',
                      deviceSize: deviceSize,
                    ),
                  );
                }
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            } : null,
            child: Text(
              '인증번호 재발송',
              style: TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep(Size deviceSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('새 비밀번호를 설정해주세요',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: deviceSize.height * 0.01),
        Text('8자 이상, 대소문자/숫자/특수문자를 각각 하나 이상 포함해야 합니다.',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: deviceSize.height * 0.04),
        Text('새 비밀번호', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        CustomInput(
          deviceSize: deviceSize,
          onChangeMethod: (value) {
            _newPassword = value;
            _validatePassword(value);
          },
          hintText: '새 비밀번호',
          errorText: _passwordError,
          text: _newPassword,
          obscureText: true,
        ),
        SizedBox(height: deviceSize.height * 0.03),
        Text('비밀번호 확인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        CustomInput(
          deviceSize: deviceSize,
          onChangeMethod: (value) {
            _confirmPassword = value;
            _validateConfirm(value);
          },
          hintText: '비밀번호 확인',
          errorText: _confirmError,
          text: _confirmPassword,
          obscureText: true,
        ),
        SizedBox(height: deviceSize.height * 0.04),
        Center(
          child: CustomButton(
            deviceSize: deviceSize,
            onTapMethod: _newPassword.isNotEmpty && _confirmPassword == _newPassword && _passwordError == null && !_isLoading
                ? _resetPassword
                : () {},
            title: _isLoading ? '변경 중...' : '비밀번호 변경',
            isEnabled: _newPassword.isNotEmpty && _confirmPassword == _newPassword && _passwordError == null && !_isLoading,
          ),
        ),
      ],
    );
  }
}
