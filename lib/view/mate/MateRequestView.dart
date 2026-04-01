import 'dart:typed_data';

import 'package:fitmate_app/repository/file/FileRepository.dart';
import 'package:fitmate_app/repository/mate/MateRepository.dart';
import 'package:fitmate_app/widget/AppSnackBar.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MateRequestView extends ConsumerStatefulWidget {
  final int mateId;

  const MateRequestView({super.key, required this.mateId});

  @override
  ConsumerState<MateRequestView> createState() => _MateRequestViewState();
}

class _MateRequestViewState extends ConsumerState<MateRequestView> {
  int _currentStep = 0;
  bool _isAgreed = false;
  final TextEditingController _answerController = TextEditingController();

  Map<String, dynamic>? _question;
  bool _isLoadingQuestion = true;
  bool _isSubmitting = false;
  Uint8List? _cachedProfileImage;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    try {
      final question = await ref
          .read(mateRepositoryProvider)
          .getMateQuestion(widget.mateId);
      final profileImageId = question['profileImageId'];
      Uint8List? imageData;
      if (profileImageId != null) {
        try {
          imageData = await ref
              .read(fileRepositoryProvider)
              .downloadFile(profileImageId);
        } catch (_) {}
      }
      if (mounted) {
        setState(() {
          _question = question;
          _cachedProfileImage = imageData;
          _isLoadingQuestion = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingQuestion = false);
      }
    }
  }

  Future<void> _submitApply() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(mateRepositoryProvider).applyMate(
            widget.mateId,
            _answerController.text.trim(),
          );
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
        AppSnackBar.show(context, message: '메이트 신청이 완료되었습니다!', type: SnackBarType.success);
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        AppSnackBar.show(context, message: '신청에 실패했습니다. ${_parseError(e)}', type: SnackBarType.error);
      }
    }
  }

  String _parseError(dynamic e) {
    try {
      return e.response?.data['message'] ?? '';
    } catch (_) {
      return '';
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (_currentStep > 0) {
                setState(() => _currentStep = 0);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Column(
          children: [
            _buildProgressBar(deviceSize),
            Expanded(
              child: _currentStep == 0
                  ? _buildStep1(deviceSize)
                  : _buildStep2(deviceSize),
            ),
            _buildBottomButton(deviceSize, devicePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(Size deviceSize) {
    return Row(
      children: [
        Container(
          height: 3,
          width: deviceSize.width * (_currentStep == 0 ? 0.5 : 1.0),
          color: Colors.orangeAccent,
        ),
        Expanded(
          child: Container(height: 3, color: Colors.grey.shade200),
        ),
      ],
    );
  }

  Widget _buildStep1(Size deviceSize) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: deviceSize.height * 0.04),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.priority_high, color: Colors.white, size: 28),
          ),
          SizedBox(height: deviceSize.height * 0.025),
          const Text(
            '모두가 즐거운 모임이 될 수 있도록\n꼭 확인해 주세요!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1.4),
          ),
          SizedBox(height: deviceSize.height * 0.05),
          _buildGuideItem(1, '모임 시작 전 부득이하게 참여가 어려워진 경우,\n반드시 모집자에게 미리 알려주세요'),
          SizedBox(height: deviceSize.height * 0.03),
          _buildGuideItem(2, '무단으로 불참하거나, 함께하는 멤버들에게\n피해를 주는 경우 이용 제재를 받게돼요'),
          SizedBox(height: deviceSize.height * 0.03),
          _buildGuideItem(3, '나와 다른 의견에도 귀 기울이며, 함께하는\n멤버들을 존중하는 태도를 지켜주세요'),
          SizedBox(height: deviceSize.height * 0.05),
          GestureDetector(
            onTap: () => setState(() => _isAgreed = !_isAgreed),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _isAgreed ? Icons.check_circle : Icons.check_circle_outline,
                    color: _isAgreed ? Colors.orangeAccent : Colors.grey,
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '이용 규칙을 잘 지킬게요!',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(Size deviceSize) {
    if (_isLoadingQuestion) {
      return const Center(child: CircularProgressIndicator());
    }

    final writerName = _question?['writerName'] ?? '';
    final comeQuestion = _question?['comeQuestion'] ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: deviceSize.height * 0.04),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('Q', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            ),
          ),
          SizedBox(height: deviceSize.height * 0.025),
          const Text(
            '모집자의 질문에\n답변을 작성해 주세요',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1.4),
          ),
          const SizedBox(height: 6),
          Text(
            '작성한 답변은 모집자에게만 공개돼요',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          SizedBox(height: deviceSize.height * 0.04),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _buildQuestionProfileImage(52),
                  const SizedBox(height: 6),
                  Text(
                    writerName,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    comeQuestion,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: deviceSize.height * 0.03),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _answerController,
              maxLines: 5,
              maxLength: 500,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: '최소 5글자 이상 입력해 주세요',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '전화번호, 카카오톡 아이디, 신청 폼 작성 요구 등 과도한 개인 정보를 요구하는 경우 가이드 위반 모임이므로 문토에게 신고하기 해주세요',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionProfileImage(double size) {
    if (_cachedProfileImage != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: MemoryImage(_cachedProfileImage!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return DefaultProfileImage(size: size);
  }

  Widget _buildBottomButton(Size deviceSize, EdgeInsets devicePadding) {
    final bool isEnabled;
    final String title;
    final VoidCallback? onTap;

    if (_currentStep == 0) {
      isEnabled = _isAgreed;
      title = '다음';
      onTap = isEnabled ? () => setState(() => _currentStep = 1) : null;
    } else {
      isEnabled = _answerController.text.trim().length >= 5 && !_isSubmitting;
      title = _isSubmitting ? '신청 중...' : '신청하기';
      onTap = isEnabled ? _submitApply : null;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, devicePadding.bottom + 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? Colors.orangeAccent : Colors.grey.shade300,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          child: Text(title),
        ),
      ),
    );
  }
}
