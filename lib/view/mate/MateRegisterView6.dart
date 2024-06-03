import 'package:fitmate_app/error/CustomException.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomIconButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAppBar.dart';
import 'MateRegisterPreview.dart';
import 'MateRegisterView3.dart';
import 'MateRegisterView7.dart';

class MateRegisterView6 extends ConsumerStatefulWidget {
  const MateRegisterView6({super.key});

  @override
  ConsumerState<MateRegisterView6> createState() => _MateRegisterView6State();
}

class _MateRegisterView6State extends ConsumerState<MateRegisterView6> {
  bool _isPermitPeopleCntEditing = false;
  bool _isGatherTypeEditing = false;
  bool _isPermitAgesEditing = false;
  bool _isPermitGenderEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final ScrollController _scrollController = ScrollController();

    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);
    final viewModel = ref.watch(mateRegisterViewModelProvider);

    _controller.value = TextEditingValue(
        text: getTextPermitPeopleCnt(viewModel.permitPeopleCnt!),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _isPermitGenderEditing = false;
        _isGatherTypeEditing = false;
        _isPermitPeopleCntEditing = false;
        _isPermitAgesEditing = false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 6,
          totalStep: 7,
        ),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              controller: _scrollController,
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
                          '모집 규칙을 정해봐요',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.05,
                        ),
                        Container(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPermitPeopleCntEditing = !_isPermitPeopleCntEditing;
                                    _isGatherTypeEditing = false;
                                    _isPermitAgesEditing = false;
                                    _isPermitGenderEditing = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.groups,
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.03,
                                        ),
                                        Text(
                                          '참여 인원(주최자 포함)',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Row(
                                      children: [
                                        Text(
                                          '최대 ${viewModel.permitPeopleCnt}명',
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.02,
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.02,
                              ),
                              Center(
                                child: Container(
                                  height: 2,
                                  width: deviceSize.width * 0.9,
                                  color: Color(0xffE8E8E8),
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.02,
                              ),
                              if(_isPermitPeopleCntEditing)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: deviceSize.height * 0.1,
                                    width: deviceSize.width * 0.3,
                                    child: Text(
                                      '최대 인원',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    height: deviceSize.height * 0.18,
                                    width: deviceSize.width * 0.4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomIconButton(
                                          onPressed: () {
                                            viewModelNotifier
                                                .plusPermitPeopleCnt();
                                          },
                                          icon: Icon(
                                            Icons.keyboard_arrow_up_rounded,
                                            color: Colors.orangeAccent,
                                            size: 35,
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                              SizedBox(
                                                height: 35,
                                                width: 30,
                                                child: TextField(
                                                  controller: _controller,
                                                  maxLength: 2,
                                                  onChanged: (value) {

                                                  },
                                                  onSubmitted: (value) {
                                                    if (value.isNotEmpty) {
                                                      int intVal = int.parse(value);
                                                      try {
                                                        viewModelNotifier.validatePermitPeopleCnt(intVal);
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
                                                      }
                                                      viewModelNotifier.setPermitPeopleCnt(intVal);
                                                      _controller.value = TextEditingValue(
                                                        text: getTextPermitPeopleCnt(intVal),
                                                        selection: TextSelection.collapsed(offset: 2),
                                                      );
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.all(0),
                                                  ),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.digitsOnly
                                                  ],
                                                  buildCounter: (
                                                    BuildContext context, {
                                                    required int currentLength,
                                                    required int? maxLength,
                                                    required bool isFocused,
                                                  }) =>
                                                      null,
                                                ),
                                              ),
                                                Center(
                                              child: Text(
                                              '명',
                                                style:
                                                TextStyle(fontSize: 20),
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(child: SizedBox()),
                                        CustomIconButton(
                                          onPressed: () {
                                            viewModelNotifier
                                                .minusPermitPeopleCnt();
                                          },
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.orangeAccent,
                                            size: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.02,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isGatherTypeEditing = !_isGatherTypeEditing;
                                    _isPermitPeopleCntEditing = false;
                                    _isPermitAgesEditing = false;
                                    _isPermitGenderEditing = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person_add_alt_rounded,
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.03,
                                        ),
                                        Text(
                                          '모집 방식',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Row(
                                      children: [
                                        Text(
                                          getTextGatherType(viewModel.gatherType!),
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.02,
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.02,
                              ),
                              Center(
                                child: Container(
                                  height: 2,
                                  width: deviceSize.width * 0.9,
                                  color: Color(0xffE8E8E8),
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.02,
                              ),
                              if(_isGatherTypeEditing)
                              Container(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        viewModelNotifier.setGatherType(GatherType.FAST);
                                      },
                                      child: Container(
                                        height: deviceSize.height * 0.15,
                                        decoration: BoxDecoration(
                                          color: viewModel.gatherType == GatherType.FAST ? Colors.orangeAccent : Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          border: viewModel.gatherType != GatherType.FAST ? Border.all(color: Color(0xffE8E8E8), width: 2) : null,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: deviceSize.width * 0.025,
                                            ),
                                            Icon(Icons.watch_later),
                                            SizedBox(
                                              width: deviceSize.width * 0.025,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                  text: '선착순\n',
                                                  style: TextStyle(
                                                    color: viewModel.gatherType == GatherType.FAST ? Colors.white : Colors.black,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration.underline,
                                                    decorationColor: viewModel.gatherType == GatherType.FAST ? Colors.white : Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: '신청자들의 신청과 동시에 참여가 안료돼요.\n',
                                                      style: TextStyle(
                                                        color: viewModel.gatherType == GatherType.FAST ? Colors.white : Colors.grey,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        decoration: TextDecoration.none,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '누구나 참여할 수 있어서 신청률이 높아요.',
                                                      style: TextStyle(
                                                        color: viewModel.gatherType == GatherType.FAST ? Colors.white : Colors.grey,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        decoration: TextDecoration.none,
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: deviceSize.height * 0.02,
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        viewModelNotifier.setGatherType(GatherType.AGREE);
                                      },
                                      child: Container(
                                        height: deviceSize.height * 0.15,
                                        decoration: BoxDecoration(
                                          color: viewModel.gatherType == GatherType.AGREE ? Colors.orangeAccent : Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          border: viewModel.gatherType != GatherType.AGREE ? Border.all(color: Color(0xffE8E8E8), width: 2) : null,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: deviceSize.width * 0.025,
                                            ),
                                            Icon(Icons.approval_rounded),
                                            SizedBox(
                                              width: deviceSize.width * 0.025,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                  text: '승인제\n',
                                                  style: TextStyle(
                                                    color: viewModel.gatherType == GatherType.AGREE ? Colors.white : Colors.black,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration.underline,
                                                    decorationColor: viewModel.gatherType == GatherType.AGREE ? Colors.white : Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: '신청자들의 신청과 동시에 참여가 안료돼요.\n',
                                                      style: TextStyle(
                                                        color: viewModel.gatherType == GatherType.AGREE ? Colors.white : Colors.grey,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        decoration: TextDecoration.none,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '누구나 참여할 수 있어서 신청률이 높아요.',
                                                      style: TextStyle(
                                                        color: viewModel.gatherType == GatherType.AGREE ? Colors.white : Colors.grey,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                        decoration: TextDecoration.none,
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.02,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPermitAgesEditing = !_isPermitAgesEditing;
                                    _isPermitPeopleCntEditing = false;
                                    _isGatherTypeEditing = false;
                                    _isPermitGenderEditing = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.compare_arrows_rounded,
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.03,
                                        ),
                                        Text(
                                          '연령',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Row(
                                      children: [
                                        Text(
                                          getTextPermitAges(viewModel.permitMinAge!, viewModel.permitMaxAge!),
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.02,
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.02,
                              ),
                              Center(
                                child: Container(
                                  height: 2,
                                  width: deviceSize.width * 0.9,
                                  color: Color(0xffE8E8E8),
                                ),
                              ),
                              SizedBox(
                                height: deviceSize.height * 0.02,
                              ),
                              if(_isPermitAgesEditing)
                              Container(
                                child: Column(
                                  children: [
                                    RangeSlider(
                                      values: RangeValues(viewModel.permitMinAge!.toDouble(), viewModel.permitMaxAge!.toDouble()),
                                      min: 20,
                                      max: 50,
                                      divisions: 6,
                                      onChanged: (value) {
                                        viewModelNotifier.setPermitMinAge(value.start.toInt());
                                        viewModelNotifier.setPermitMaxAge(value.end.toInt());
                                      },
                                      activeColor: Colors.orangeAccent,
                                      inactiveColor: Color(0xffE8E8E8),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(deviceSize.width * 0.02, 0, deviceSize.width * 0.02, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('~20'),
                                          Text('25'),
                                          Text('30'),
                                          Text('35'),
                                          Text('40'),
                                          Text('45'),
                                          Text('50~'),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPermitGenderEditing = !_isPermitGenderEditing;
                              _isGatherTypeEditing = false;
                              _isPermitPeopleCntEditing = false;
                              _isPermitAgesEditing = false;
                            });
                          },
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.group,
                                  ),
                                  SizedBox(
                                    width: deviceSize.width * 0.03,
                                  ),
                                  Text(
                                    '성별',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Row(
                                children: [
                                  Text(
                                    getTextPermitGender(viewModel.permitGender!),
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(
                                    width: deviceSize.width * 0.02,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        Center(
                          child: Container(
                            height: 2,
                            width: deviceSize.width * 0.9,
                            color: Color(0xffE8E8E8),
                          ),
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        if(_isPermitGenderEditing)
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      viewModelNotifier.setPermitGender(PermitGender.ALL);
                                    },
                                    child: Container(
                                      height: deviceSize.height * 0.09,
                                      decoration: BoxDecoration(
                                        color: viewModel.permitGender == PermitGender.ALL ? Colors.orangeAccent : Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: viewModel.permitGender != PermitGender.ALL ? Border.all(color: Color(0xffE8E8E8), width: 2) : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '누구나',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: viewModel.permitGender == PermitGender.ALL ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: deviceSize.width * 0.01,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      viewModelNotifier.setPermitGender(PermitGender.MALE);
                                    },
                                    child: Container(
                                        height: deviceSize.height * 0.09,
                                        decoration: BoxDecoration(
                                          color: viewModel.permitGender == PermitGender.MALE ? Colors.orangeAccent : Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          border: viewModel.permitGender != PermitGender.MALE ? Border.all(color: Color(0xffE8E8E8), width: 2) : null,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '남자만',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: viewModel.permitGender == PermitGender.MALE ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: deviceSize.width * 0.01,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      viewModelNotifier.setPermitGender(PermitGender.FEMALE);
                                    },
                                    child: Container(
                                        height: deviceSize.height * 0.09,
                                        decoration: BoxDecoration(
                                          color: viewModel.permitGender == PermitGender.FEMALE ? Colors.orangeAccent : Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          border: viewModel.permitGender != PermitGender.FEMALE ? Border.all(color: Color(0xffE8E8E8), width: 2) : null,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '여자만',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: viewModel.permitGender == PermitGender.FEMALE ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                      ],
                    ),
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
                    onTapMethod: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MateRegisterView7()));
                    },
                    title: '다음',
                    isEnabled: true
                ),
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

  String getTextPermitPeopleCnt(int permitPeopleCnt) {
    return permitPeopleCnt.toString().padLeft(2, '0');
  }
  
  String getTextGatherType(GatherType gatherType) {
    if(gatherType == GatherType.FAST) return '선착순';
    else return '승인제';
  }

  String getTextPermitAges(int min, int max) {
    String result = '';
    if(min == 20) {
      if(max == 50) result = '모든 연령';
      else result = max.toString() + '세 이하';
    }
    else {
      if(max == 50) result = min.toString() + '세 이상';
      else result = min.toString() + ' ~ ' + max.toString() + '세';
    }
    return result;
  }

  String getTextPermitGender(PermitGender permitGender) {
    String result = '';
    switch (permitGender) {
      case PermitGender.MALE: result = '남자만';
      break;
      case PermitGender.FEMALE: result = '여자만';
      break;
      case PermitGender.ALL: result = '누구나';
    }
    return result;
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
