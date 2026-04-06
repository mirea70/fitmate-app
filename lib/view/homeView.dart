import 'package:fitmate_app/config/Const.dart';
import 'package:fitmate_app/config/SecureStorage.dart';
import 'package:fitmate_app/repository/auth/AuthRepository.dart';
import 'package:fitmate_app/view/account/LoginView.dart';
import 'package:fitmate_app/view/account/ProfileCompleteView.dart';
import 'package:fitmate_app/view/mate/MainView.dart';
import 'package:fitmate_app/widget/AppSnackBar.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  bool _isLoading = false;

  Future<void> _handleKakaoLogin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
        } catch (_) {
          token = await UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      final result = await ref.read(authRepositoryProvider).kakaoLogin(
        kakaoAccessToken: token.accessToken,
      );

      final bool isNewUser = result['isNewUser'];

      if (mounted) {
        if (isNewUser) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ProfileCompleteView(
              kakaoAccessToken: token.accessToken,
              kakaoNickName: result['kakaoNickName'] ?? '',
              kakaoEmail: result['kakaoEmail'] ?? '',
            )),
            (route) => false,
          );
        } else {
          final loginResponse = result['loginResponse'];
          final FlutterSecureStorage storage = ref.read(secureStorageProvider);
          await storage.write(key: accessTokenKey, value: loginResponse.accessToken);
          await storage.write(key: refreshTokenKey, value: loginResponse.refreshToken);

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainView()),
            (route) => false,
          );
          AppSnackBar.show(context, message: '환영합니다! 지금 바로 운동 메이트를 만나보세요!', type: SnackBarType.success);
        }
      }
    } catch (e) {
      debugPrint('카카오 로그인 에러: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => CustomAlert(
            title: '카카오 로그인에 실패했습니다.',
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

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: deviceSize.height * 0.08),
                      Center(
                        child: ClipPath(
                          clipper: TrapezoidClipper(),
                          child: Container(
                            alignment: Alignment.center,
                            height: deviceSize.height * 0.08,
                            width: deviceSize.width * 0.55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.orangeAccent,
                            ),
                            child: Text(
                              'FitMate',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: deviceSize.height * 0.1),
                      Column(
                        children: [
                          Text(
                            '아직도 혼자 운동하세요?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            '이제,',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 7),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '운동 메이트와 함께 해봐요!',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: deviceSize.height * 0.1),
                      Column(
                        children: [
                          CustomButton(
                            deviceSize: deviceSize,
                            onTapMethod: _isLoading ? () {} : _handleKakaoLogin,
                            title: _isLoading ? '로그인 중...' : '카카오톡으로 시작하기',
                            isEnabled: !_isLoading,
                            color: Color(0xffFEE500),
                            textColor: Colors.black87,
                          ),
                          SizedBox(height: deviceSize.height * 0.02),
                          CustomButton(
                            deviceSize: deviceSize,
                            onTapMethod: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginView();
                                  },
                                ),
                              );
                            },
                            title: '다른 방법으로 시작하기',
                            isEnabled: true,
                          ),
                        ],
                      ),
                      SizedBox(height: deviceSize.height * 0.05),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.05, size.height * 0.9);
    path.lineTo(size.width * 0.13, size.height * 0.1);
    path.lineTo(size.width * 0.95, size.height * 0.1);
    path.lineTo(size.width * 0.87, size.height * 0.9);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
