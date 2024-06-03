import 'package:fitmate_app/view/account/AccountJoinView2.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinErrorViewModel.dart';
import 'package:fitmate_app/view_model/account/join/AccountJoinViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/view_model/mate/SearchViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInput.dart';
import 'package:fitmate_app/widget/CustomInputBox.dart';
import 'package:fitmate_app/widget/CustomInputWithoutFocus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAppBar.dart';
import 'MateRegisterView3.dart';

class MateRegisterView2 extends ConsumerStatefulWidget {
  const MateRegisterView2({super.key});

  @override
  ConsumerState<MateRegisterView2> createState() => _MateRegisterView2State();
}

class _MateRegisterView2State extends ConsumerState<MateRegisterView2> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);
    final viewModel = ref.watch(mateRegisterViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 2,
          totalStep: 7,
        ),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
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
                              '어디서 만날까요?',
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
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          // List<Map<String,String>>
                                          return Consumer(
                                            builder: (context2, ref2, child) {
                                              final searchItems = ref2.watch(searchViewModelProvider);
                                              final viewModelNotifier2 = ref2.read(mateRegisterViewModelProvider.notifier);
                                              return Container(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          deviceSize.height * 0.03,
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        '장소 선택',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: deviceSize.height * 0.03,
                                                    ),
                                                    Container(
                                                      width: deviceSize.width * 0.9,
                                                      height: deviceSize.height * 0.05,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Color(0xffE8E8E8),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: deviceSize
                                                                    .width *
                                                                0.03,
                                                          ),
                                                          Icon(Icons.search),
                                                          SizedBox(
                                                            width: deviceSize
                                                                    .width *
                                                                0.02,
                                                          ),
                                                          CustomInputWithoutFocus(
                                                            deviceSize:
                                                                deviceSize *
                                                                    0.85,
                                                            onChangeMethod:
                                                                (value) {
                                                              ref.read(searchViewModelProvider.notifier).searchPlace(value);
                                                            },
                                                            hintText:
                                                                '어디에서 만나나요?',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          deviceSize.height *
                                                              0.02,
                                                    ),
                                                    searchItems.when(
                                                        data: (items) {
                                                          return Expanded(
                                                            child: ListView
                                                                .builder(
                                                              itemCount: items.length,
                                                              itemBuilder: (context, index) {
                                                                String title = items[index]['title'];
                                                                String address = items[index]['roadAddress']
                                                                    ?? items[index]['address'];
                                                                return ListTile(
                                                                  title: Text(title),
                                                                  titleTextStyle: TextStyle(
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.black
                                                                  ),
                                                                  subtitle: Text(address),
                                                                  subtitleTextStyle: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.w300,
                                                                      color: Colors.grey),
                                                                  onTap: () {
                                                                    viewModelNotifier.setPlace(
                                                                        title,
                                                                        address,
                                                                    );
                                                                    Navigator.pop(context2);
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        error: (error,
                                                                stackTrace) =>
                                                            CustomAlert(
                                                              title:
                                                                  '데이터를 불러오는 중 에러가 발생했습니다.',
                                                              deviceSize:
                                                                  deviceSize,
                                                            ),
                                                        loading: () =>
                                                            CircularProgressIndicator()),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        constraints: BoxConstraints(
                                          minWidth: deviceSize.width,
                                          // maxWidth: deviceSize.width,
                                          minHeight: deviceSize.height * 0.85,
                                          maxHeight: deviceSize.height * 0.85,
                                        ),
                                        isScrollControlled: true,
                                      ).then((value) => ref.read(searchViewModelProvider.notifier).reset());
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.place,
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.02,
                                        ),
                                        Text(
                                          viewModel.fitPlaceName != '' ? viewModel.fitPlaceName
                                          : '장소를 입력해주세요',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                    onTapMethod: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MateRegisterView3()));
                    },
                    title: '다음',
                    isEnabled: viewModel.fitPlaceName != ''
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
}
