import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:fitmate_app/widget/CustomInputCalendar.dart';
import 'package:fitmate_app/widget/TimePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../widget/CustomAppBar.dart';
import 'MateRegisterView5.dart';

class MateRegisterView4 extends ConsumerStatefulWidget {
  const MateRegisterView4({super.key});

  @override
  ConsumerState<MateRegisterView4> createState() => _MateRegisterView4State();
}

class _MateRegisterView4State extends ConsumerState<MateRegisterView4> {

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
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          deviceSize: deviceSize,
          devicePadding: devicePadding,
          step: 4,
          totalStep: 7,
        ),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
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
                              '언제 만날까요?',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.05,
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    isIngCalendarNotifier.setIsIng(!isIngCalendar);
                                  },
                                  child: Container(
                                    width: deviceSize.width * 0.9,
                                    height: deviceSize.height * 0.06,
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: isIngCalendar ? Colors.orangeAccent : Color(0xffE8E8E8),
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          size: 20,
                                          color: Colors.orangeAccent,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            '${viewModel.mateAt!.year}년 ${viewModel.mateAt!.month}월 ${viewModel.mateAt!.day}일 '
                                                '(${DateFormat('E', 'ko_KR').format(viewModel.mateAt!)})',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          isIngCalendar ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                AnimatedCrossFade(
                                  firstChild: SizedBox.shrink(),
                                  secondChild: Container(
                                    margin: EdgeInsets.only(top: 8),
                                    width: deviceSize.width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Color(0xffFAFAFA),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Color(0xffE8E8E8)),
                                    ),
                                    child: CustomInputCalendar(
                                      initDay: viewModel.mateAt,
                                      onDaySelected: (selectedDay, focusedDay) {
                                        viewModelNotifier.setMateAtDate(selectedDay);
                                        isIngCalendarNotifier.setIsIng(false);
                                      },
                                    ),
                                  ),
                                  crossFadeState: isIngCalendar ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  duration: Duration(milliseconds: 250),
                                ),
                                SizedBox(height: deviceSize.height * 0.02),
                                CustomTimePicker(
                                  initialHour: viewModel.mateAt!.hour,
                                  initialMinute: viewModel.mateAt!.minute,
                                  onTimeChanged: (time) {
                                    viewModelNotifier.setMateAtTime(time);
                                  },
                                ),
                              ],
                            ),
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
                child: CustomButton(
                    deviceSize: deviceSize,
                    onTapMethod: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MateRegisterView5()));
                    },
                    title: '다음',
                    isEnabled: viewModel.mateAt != null
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
