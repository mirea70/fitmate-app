import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widget/CustomAppBar.dart';
import 'MainView.dart';
import 'MateRegisterView2.dart';

class MateRegisterView1 extends ConsumerStatefulWidget {
  const MateRegisterView1({super.key});

  @override
  ConsumerState<MateRegisterView1> createState() => _MateRegisterView1State();
}

class _MateRegisterView1State extends ConsumerState<MateRegisterView1> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);
    final viewModel = ref.watch(mateRegisterViewModelProvider);
    final selectNumNotifier = ref.read(selectNumProvider.notifier);
    final selectNum = ref.watch(selectNumProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          resetViewModel: viewModelNotifier,
          onPressed: () {
            final isEditMode = ref.read(mateEditModeProvider) != null;
            viewModelNotifier.reset();
            selectNumNotifier.reset();
            ref.read(mateEditModeProvider.notifier).state = null;
            ref.read(keepImageIdsProvider.notifier).state = [];
            if (isEditMode) {
              Navigator.pop(context);
            } else {
              MainView.of(context)?.selectTab(0);
            }
          },
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 1,
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
                              '운동 카테고리를 골라주세요',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.03,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Wrap(
                                    spacing: deviceSize.width * 0.03,
                                    runSpacing: deviceSize.height * 0.015,
                                    children: FitCategory.values
                                        .where((c) => c != FitCategory.undefined)
                                        .toList()
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index = entry.key + 1;
                                      final category = entry.value;
                                      final isSelected = selectNum == index;
                                      return GestureDetector(
                                        onTap: () {
                                          selectNumNotifier.setSelectNum(index);
                                          viewModelNotifier.setFitCategory(category);
                                        },
                                        child: Container(
                                          width: deviceSize.width * 0.27,
                                          height: deviceSize.height * 0.055,
                                          decoration: BoxDecoration(
                                            color: isSelected ? Colors.orangeAccent : Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isSelected ? Colors.orangeAccent : Color(0xffE8E8E8),
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              category.label,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected ? Colors.white : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
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
                  onTapMethod: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MateRegisterView2()));
                  },
                  title: '다음',
                  isEnabled: viewModel.fitCategory != null,
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

final selectNumProvider =
    NotifierProvider<SelectNumNotifier, int>(() => SelectNumNotifier());

class SelectNumNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setSelectNum(int num) {
    state = num;
  }

  void reset() {
    state = 0;
  }
}
