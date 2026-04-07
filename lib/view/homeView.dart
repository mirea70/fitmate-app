import 'package:fitmate_app/config/Const.dart';
import 'package:fitmate_app/config/SecureStorage.dart';
import 'package:fitmate_app/repository/auth/AuthRepository.dart';
import 'package:fitmate_app/view/account/LoginView.dart';
import 'package:fitmate_app/view/account/ProfileCompleteView.dart';
import 'package:fitmate_app/view/mate/MainView.dart';
import 'package:fitmate_app/widget/AppSnackBar.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
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
    final EdgeInsets padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/fitmate_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // 그라데이션 오버레이
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          // 콘텐츠
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  // 메인 카피
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'FITMATE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w900,
                            letterSpacing: 6,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '운동은 함께할 때\n더 즐거우니까!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.87),
                            fontSize: 28,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '나와 맞는 운동 메이트를 지금 바로 만나보세요!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha:0.7),
                            fontSize: 18,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  SizedBox(height: deviceSize.height * 0.05),
                  // 카카오 로그인 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleKakaoLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffFEE500),
                        disabledBackgroundColor: Color(0xffFEE500).withValues(alpha:0.6),
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble, size: 20, color: Colors.black87),
                          SizedBox(width: 8),
                          Text(
                            _isLoading ? '로그인 중...' : '카카오톡으로 시작하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  // 다른 방법으로 시작하기
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha:0.5), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '다른 방법으로 시작하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: padding.bottom + 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
