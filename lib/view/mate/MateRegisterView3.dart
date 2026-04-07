import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/error/CustomException.dart';
import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:fitmate_app/widget/CustomInputLarge.dart';
import 'package:fitmate_app/widget/CustomInputMultiImage.dart';
import 'package:fitmate_app/widget/CustomViewImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAppBar.dart';
import 'MateRegisterView4.dart';

class MateRegisterView3 extends ConsumerStatefulWidget {
  const MateRegisterView3({super.key});

  @override
  ConsumerState<MateRegisterView3> createState() => _MateRegisterView3State();
}

class _MateRegisterView3State extends ConsumerState<MateRegisterView3> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModel = ref.watch(mateRegisterViewModelProvider);
    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 3,
          totalStep: 7,
        ),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(deviceSize.width * 0.05, 0,
                          deviceSize.width * 0.05, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '일정에 대해 소개해봐요!',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: deviceSize.height * 0.03 + 10),
                          Text(
                            '배너 이미지 (최대 3장)',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '(첫 번째 이미지가 목록 썸네일로 사용됩니다)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: (deviceSize.height * 0.02 + 8).clamp(5, 12)),
                          SizedBox(
                            height: deviceSize.width * 0.22,
                            child: _ImageListSection(deviceSize: deviceSize),
                          ),
                          SizedBox(height: deviceSize.height * 0.02 + 8),
                          Text(
                            '제목',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          CustomInput(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) {
                              viewModelNotifier.setTitle(value);
                            },
                            hintText: '제목을 입력해 주세요',
                            text: viewModel.title,
                          ),
                          SizedBox(
                              height: (deviceSize.height * 0.005).clamp(5, 8)),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '(예시 : 아침헬스 함께 가실 분!)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  (deviceSize.height * 0.025).clamp(20, 25)
                          ),
                          Text(
                            '소개글',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          CustomInputLarge(
                            deviceSize: deviceSize,
                            onChangeMethod: (value) {
                              viewModelNotifier.setIntroduction(value);
                            },
                            hintText: '소개글을 입력해 주세요 (선택)',
                            text: viewModel.introduction ?? '',
                          ),
                          SizedBox(
                              height:
                                  (deviceSize.height * 0.03).clamp(20.0, 30.0)),
                        ],
                      ),
                    ),
                  ],
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
                child: _NextButton(),
              ),
              // SizedBox(
              //   height:
              //   devicePadding.bottom + deviceSize.height * 0.03,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageListSection extends ConsumerWidget {
  const _ImageListSection({required this.deviceSize});

  final Size deviceSize;

  Widget _buildServerImageThumbnail(WidgetRef ref, int imageId) {
    final double boxSize = deviceSize.width * 0.2;
    final data = ref.read(imageCacheServiceProvider).get(imageId);
    ImageProvider imageProvider;
    if (data != null) {
      imageProvider = MemoryImage(data);
    } else {
      imageProvider = AssetImage('assets/images/default_intro_image.jpg');
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: boxSize,
          width: boxSize,
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: imageProvider),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffE8E8E8), width: 2),
          ),
        ),
        Positioned(
          top: -5,
          right: -5,
          child: GestureDetector(
            onTap: () {
              final keepIds = ref.read(keepImageIdsProvider.notifier);
              final current = List<int>.from(keepIds.state);
              current.remove(imageId);
              keepIds.state = current;
            },
            child: Container(
              height: 20,
              width: 20,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              child: Icon(Icons.close, color: Colors.white, size: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileViewModel = ref.watch(fileViewModelProvider);
    final keepImageIds = ref.watch(keepImageIdsProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInputMultiImage(
          deviceSize: deviceSize,
        ),
        SizedBox(
          width: deviceSize.width * 0.02,
        ),
        Expanded(
          child: ListView.separated(
            itemCount: keepImageIds.length + fileViewModel.files.length,
            itemBuilder: (context, index) {
              if (index < keepImageIds.length) {
                return _buildServerImageThumbnail(ref, keepImageIds[index]);
              }
              final fileIndex = index - keepImageIds.length;
              return CustomViewImage(
                deviceSize: deviceSize,
                index: fileIndex,
                fileViewModel: fileViewModel,
              );
            },
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) =>
                SizedBox(width: deviceSize.width * 0.02),
          ),
        ),
      ],
    );
  }
}

class _NextButton extends ConsumerWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModel = ref.watch(mateRegisterViewModelProvider);
    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);

    return CustomButton(
        deviceSize: deviceSize,
        onTapMethod: () {
          try {
            viewModelNotifier.validateTitle(viewModel.title);
          } on CustomException catch (e) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlert(
                  title: e.msg,
                  deviceSize: deviceSize,
                );
              },
            );
            return;
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MateRegisterView4()));
        },
        title: '다음',
        isEnabled: viewModel.title.length >= 5);
  }
}
