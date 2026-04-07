import 'package:flutter/material.dart';

class BirthDatePicker extends StatefulWidget {
  final String? initialDate;
  final ValueChanged<String> onDateChanged;

  const BirthDatePicker({
    super.key,
    this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<BirthDatePicker> createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  bool _isExpanded = false;

  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;

  final int _startYear = 1950;
  final int _endYear = 2025;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      final parts = widget.initialDate!.split('-');
      _selectedYear = int.parse(parts[0]);
      _selectedMonth = int.parse(parts[1]);
      _selectedDay = int.parse(parts[2]);
    } else {
      _selectedYear = 2000;
      _selectedMonth = 1;
      _selectedDay = 1;
    }
    _yearController = FixedExtentScrollController(initialItem: _selectedYear - _startYear);
    _monthController = FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _onChanged() {
    final maxDay = _daysInMonth(_selectedYear, _selectedMonth);
    if (_selectedDay > maxDay) {
      _selectedDay = maxDay;
      _dayController.jumpToItem(_selectedDay - 1);
    }
    final formatted = '$_selectedYear-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}';
    widget.onDateChanged(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final bool hasValue = widget.initialDate != null;

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            width: deviceSize.width * 0.9,
            height: (deviceSize.height * 0.06).clamp(48.0, 56.0),
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _isExpanded ? Colors.orangeAccent : Color(0xffE8E8E8),
                width: 2,
              ),
              color: hasValue ? Colors.orange.withValues(alpha: 0.05) : Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.cake_outlined,
                  size: 20,
                  color: hasValue ? Colors.orangeAccent : Colors.grey,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasValue
                        ? '${_selectedYear}년 ${_selectedMonth}월 ${_selectedDay}일'
                        : '생년월일을 선택해주세요',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                      color: hasValue ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: Row(
                    children: [
                      _buildWheel(
                        controller: _yearController,
                        itemCount: _endYear - _startYear + 1,
                        labelBuilder: (index) => '${_startYear + index}년',
                        onChanged: (index) {
                          setState(() => _selectedYear = _startYear + index);
                          _onChanged();
                        },
                        flex: 3,
                      ),
                      _buildDivider(),
                      _buildWheel(
                        controller: _monthController,
                        itemCount: 12,
                        labelBuilder: (index) => '${index + 1}월',
                        onChanged: (index) {
                          setState(() => _selectedMonth = index + 1);
                          _onChanged();
                        },
                        flex: 2,
                      ),
                      _buildDivider(),
                      _buildWheel(
                        controller: _dayController,
                        itemCount: _daysInMonth(_selectedYear, _selectedMonth),
                        labelBuilder: (index) => '${index + 1}일',
                        onChanged: (index) {
                          setState(() => _selectedDay = index + 1);
                          _onChanged();
                        },
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _onChanged();
                    setState(() => _isExpanded = false);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xffE8E8E8))),
                    ),
                    child: Center(
                      child: Text(
                        '${_selectedYear}년 ${_selectedMonth}월 ${_selectedDay}일 선택',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 250),
        ),
      ],
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) labelBuilder,
    required ValueChanged<int> onChanged,
    required int flex,
  }) {
    return Expanded(
      flex: flex,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        perspective: 0.005,
        diameterRatio: 1.2,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            final isSelected = _isSelectedItem(controller, index);
            return Center(
              child: Text(
                labelBuilder(index),
                style: TextStyle(
                  fontSize: isSelected ? 17 : 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.orangeAccent : Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isSelectedItem(FixedExtentScrollController controller, int index) {
    if (!controller.hasClients) return false;
    return controller.selectedItem == index;
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 100,
      color: Color(0xffE8E8E8),
    );
  }
}
