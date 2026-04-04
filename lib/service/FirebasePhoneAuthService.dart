import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebasePhoneAuthServiceProvider = Provider<FirebasePhoneAuthService>((ref) {
  return FirebasePhoneAuthService();
});

class FirebasePhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  /// 인증번호 요청. 성공 시 true 반환, 실패 시 예외 throw.
  Future<bool> requestCode(String phone) async {
    final completer = Completer<bool>();

    try {
      debugPrint('[FirebasePhoneAuth] requestCode 시작: +82${phone.substring(1)}');

      await _auth.verifyPhoneNumber(
        phoneNumber: '+82${phone.substring(1)}',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          debugPrint('[FirebasePhoneAuth] verificationCompleted');
          if (!completer.isCompleted) completer.complete(true);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('[FirebasePhoneAuth] verificationFailed: ${e.code} - ${e.message}');
          if (!completer.isCompleted) {
            completer.completeError(e.message ?? '인증번호 요청에 실패했습니다.');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('[FirebasePhoneAuth] codeSent: verificationId=$verificationId');
          _verificationId = verificationId;
          if (!completer.isCompleted) completer.complete(true);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('[FirebasePhoneAuth] codeAutoRetrievalTimeout');
          _verificationId = verificationId;
        },
      );

      debugPrint('[FirebasePhoneAuth] verifyPhoneNumber 호출 완료, 콜백 대기 중...');
    } catch (e) {
      debugPrint('[FirebasePhoneAuth] verifyPhoneNumber 예외: $e');
      if (!completer.isCompleted) {
        completer.completeError('인증번호 요청 중 오류가 발생했습니다: $e');
      }
    }

    // reCAPTCHA 인증 시간을 포함하여 충분한 타임아웃 (120초)
    return completer.future.timeout(
      const Duration(seconds: 120),
      onTimeout: () {
        debugPrint('[FirebasePhoneAuth] 타임아웃 - 콜백 미수신');
        throw TimeoutException('인증번호 요청 시간이 초과되었습니다.');
      },
    );
  }

  /// 인증번호 검증. 성공 시 Firebase ID 토큰 반환.
  Future<String> verifyCode(String smsCode) async {
    if (_verificationId == null) {
      throw Exception('인증번호를 먼저 요청해주세요.');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final idToken = await userCredential.user!.getIdToken();

    // Firebase 세션은 앱 자체 인증과 별개이므로 로그아웃
    await _auth.signOut();

    return idToken!;
  }
}
