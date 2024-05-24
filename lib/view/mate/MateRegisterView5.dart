import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInputCalendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../widget/CustomAppBar.dart';
import 'MateRegisterView3.dart';

class MateRegisterView5 extends ConsumerStatefulWidget {
  const MateRegisterView5({super.key});

  @override
  ConsumerState<MateRegisterView5> createState() => _MateRegisterView5State();
}

class _MateRegisterView5State extends ConsumerState<MateRegisterView5> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;
    final viewModelNotifier = ref.read(mateRegisterViewModelProvider.notifier);
    final viewModel = ref.watch(mateRegisterViewModelProvider);

    final isIngCalendar = ref.watch(isIngCalendarProvider);
    final isIngCalendarNotifier = ref.read(isIngCalendarProvider.notifier);

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
                              '참가비가 있나요?',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              ),
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
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      isIngCalendarNotifier.setIsIng(!isIngCalendar);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.02,
                                        ),
                                        Text(
                                          '${viewModel.mateAt!.month}.${viewModel.mateAt!.day} '
                                              '(${DateFormat('E', 'ko_KR').format(viewModel.mateAt!)})',
                                          style: TextStyle(
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
                                  if(isIngCalendar)
                                  Container(
                                    height: deviceSize.height * 0.5,
                                    child: CustomInputCalendar(
                                      initDay: viewModel.mateAt,
                                      onDaySelected: (selectedDay, focusedDay) {
                                        viewModelNotifier.setMateAtDate(selectedDay);
                                        isIngCalendarNotifier.setIsIng(false);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: deviceSize.height * 0.03,
                                  ),

                                  GestureDetector(
                                    onTap: () async {
                                      final TimeOfDay? selectTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                            hour: viewModel.mateAt!.hour,
                                            minute: viewModel.mateAt!.minute,
                                        ),
                                        initialEntryMode: TimePickerEntryMode.dialOnly,
                                      );
                                      if(selectTime != null)
                                        viewModelNotifier.setMateAtTime(selectTime);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                        ),
                                        SizedBox(
                                          width: deviceSize.width * 0.02,
                                        ),
                                        Text(
                                          '${formatTimeOfDay(
                                              TimeOfDay(
                                                  hour: viewModel.mateAt!.hour,
                                                  minute: viewModel.mateAt!.minute,
                                              ),
                                          )}',
                                          style: TextStyle(
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
                          isEnabled: viewModel.mateAt != null
                        ),
                      ),
                      SizedBox(
                        height: devicePadding.bottom + deviceSize.height * 0.03,
                      ),
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

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(timeOfDay, alwaysUse24HourFormat: false);
  }
}

final isIngCalendarProvider =
NotifierProvider<isIngCalendarNotifier, bool>(() => isIngCalendarNotifier());

class isIngCalendarNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setIsIng(bool value) {
    state = value;
  }
}
