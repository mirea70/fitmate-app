import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInputSmall.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAppBar.dart';
import 'MateRegisterView3.dart';

class MateRegisterView5 extends ConsumerStatefulWidget {
  const MateRegisterView5({super.key});

  @override
  ConsumerState<MateRegisterView5> createState() => _MateRegisterView5State();
}

class _MateRegisterView5State extends ConsumerState<MateRegisterView5> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);
    final viewModel = ref.watch(mateRegisterViewModelProvider);

    final hasMateFee = ref.watch(hasMateFeeProvider);
    final hasMateFeeNotifier = ref.read(hasMateFeeProvider.notifier);

    final mateFeeState = ref.watch(mateFeeStateProvider);
    final mateFeeStateNotifier = ref.read(mateFeeStateProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 5,
          totalStep: 6,
        ),
        resizeToAvoidBottomInset: true,
        body:
        LayoutBuilder(
          builder: (context, constraint) {
            return
              SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                  minWidth: constraint.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        deviceSize.width * 0.05, 0, deviceSize.width * 0.05, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '참가비가 있나요?',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.01,
                        ),
                        Text(
                          '개인 거래로 문제가 발생하는 것을 예방하기 위해 \n'
                          '모임 진행에 필요한 모든 금액을 참가비로 설정해 주세요.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.05,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    hasMateFeeNotifier.setHasMateFee(true);
                                  },
                                  child: Container(
                                    height: deviceSize.height * 0.07,
                                    decoration: BoxDecoration(
                                      color: hasMateFee
                                          ? Colors.orangeAccent
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Color(0xffE8E8E8),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '있음',
                                        style: TextStyle(
                                          color: hasMateFee
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: deviceSize.width * 0.05,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    hasMateFeeNotifier.setHasMateFee(false);
                                  },
                                  child: Container(
                                    height: deviceSize.height * 0.07,
                                    decoration: BoxDecoration(
                                      color: hasMateFee
                                          ? Colors.white
                                          : Colors.orangeAccent,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Color(0xffE8E8E8),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '없음',
                                        style: TextStyle(
                                          color: hasMateFee
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!hasMateFee)
                          SizedBox(
                            height: deviceSize.height * 0.02,
                          ),
                        if (!hasMateFee)
                          Container(
                            height: deviceSize.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffE8E8E8),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: deviceSize.width * 0.02,
                                ),
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: 35,
                                ),
                                SizedBox(
                                  width: deviceSize.width * 0.03,
                                ),
                                Text(
                                  "모임진행에 비용이 발생한다면 \n"
                                  "참가비를 '있음'으로 설정해 주세요.",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (hasMateFee)
                          Column(
                            children: [
                              SizedBox(
                                height: deviceSize.height * 0.05,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.add_circle_outlined),
                                        SizedBox(
                                          width: deviceSize.width * 0.02,
                                        ),
                                        Text(
                                          '참가비 추가',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.02,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: deviceSize.width * 0.01),
                                      child: Text(
                                        '참가비 종류',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.01,
                                    ),
                                    CustomInputSmall(
                                      deviceSize: deviceSize,
                                      onChangeMethod: (value) {
                                        mateFeeStateNotifier.setName(value);
                                      },
                                      hintText: '노쇼방지비',
                                      text: mateFeeState.name,
                                      maxLength: 20,
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.01,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: deviceSize.width * 0.01),
                                      child: Text(
                                        '참가비',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.01,
                                    ),
                                    CustomInputSmall(
                                      deviceSize: deviceSize,
                                      onChangeMethod: (value) {
                                        if (value != '')
                                          mateFeeStateNotifier
                                              .setFee(int.parse(value));
                                      },
                                      hintText: '10000',
                                      text: mateFeeState.fee.toString(),
                                      maxLength: 20,
                                      type: 'number',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.02,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.info),
                                        SizedBox(
                                          width: deviceSize.width * 0.02,
                                        ),
                                        Text(
                                          '참가비 정보',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.02,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: viewModel.mateFees.length,
                                        itemBuilder: (context, index) {
                                          String name =
                                              viewModel.mateFees[index].name;
                                          int fee =
                                              viewModel.mateFees[index].fee;
                                          return Text('test');
                                          // return Column(
                                          //   children: [
                                          //     Text(
                                          //       name,
                                          //       style: TextStyle(
                                          //         fontSize: 15,
                                          //         fontWeight: FontWeight.w600,
                                          //       ),
                                          //     ),
                                          //     SizedBox(
                                          //       height:
                                          //           deviceSize.height * 0.01,
                                          //     ),
                                          //     Row(
                                          //       children: [
                                          //         Icon(Icons.attach_money),
                                          //         SizedBox(
                                          //           width:
                                          //               deviceSize.width * 0.01,
                                          //         ),
                                          //         Text(
                                          //           fee.toString(),
                                          //           style: TextStyle(
                                          //             fontSize: 15,
                                          //             fontWeight:
                                          //                 FontWeight.w400,
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ],
                                          // );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        Expanded(child: SizedBox()),
                        Center(
                          child: CustomButton(
                              deviceSize: deviceSize,
                              onTapMethod: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MateRegisterView3()));
                              },
                              title: '다음',
                              isEnabled: viewModel.mateAt != null),
                        ),
                        SizedBox(
                          height:
                              devicePadding.bottom + deviceSize.height * 0.03,
                        ),
                      ],
                    ),
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

final hasMateFeeProvider =
    NotifierProvider<hasMateFeeNotifier, bool>(() => hasMateFeeNotifier());

class hasMateFeeNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setHasMateFee(bool value) {
    state = value;
  }
}

final mateFeeStateProvider =
    NotifierProvider<MateFeeNotifier, MateFee>(() => MateFeeNotifier());

class MateFeeNotifier extends Notifier<MateFee> {
  @override
  MateFee build() {
    return MateFee(name: '', fee: 0);
  }

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setFee(int value) {
    state = state.copyWith(fee: value);
  }

  void reset() {
    state = state.copyWith(name: '', fee: 0);
  }
}
