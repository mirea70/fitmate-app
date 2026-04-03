import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const CustomTimePicker({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.onTimeChanged,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int _selectedAmPm;
  late int _selectedHour;
  late int _selectedMinute;
  bool _isExpanded = false;

  late FixedExtentScrollController _amPmController;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    _selectedAmPm = widget.initialHour >= 12 ? 1 : 0;
    _selectedHour = widget.initialHour % 12;
    if (_selectedHour == 0) _selectedHour = 12;
    _selectedMinute = widget.initialMinute;

    _amPmController = FixedExtentScrollController(initialItem: _selectedAmPm);
    _hourController = FixedExtentScrollController(initialItem: _selectedHour - 1);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _amPmController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _onChanged() {
    int hour24 = _selectedHour;
    if (_selectedAmPm == 0) {
      if (hour24 == 12) hour24 = 0;
    } else {
      if (hour24 != 12) hour24 += 12;
    }
    widget.onTimeChanged(TimeOfDay(hour: hour24, minute: _selectedMinute));
  }

  String _formatDisplay() {
    String amPm = _selectedAmPm == 0 ? '오전' : '오후';
    String hour = _selectedHour.toString();
    String minute = _selectedMinute.toString().padLeft(2, '0');
    return '$amPm $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            width: deviceSize.width * 0.9,
            height: deviceSize.height * 0.06,
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _isExpanded ? Colors.orangeAccent : Color(0xffE8E8E8),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.watch_later_outlined,
                  size: 20,
                  color: Colors.orangeAccent,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _formatDisplay(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
                        controller: _amPmController,
                        itemCount: 2,
                        labelBuilder: (index) => index == 0 ? '오전' : '오후',
                        onChanged: (index) {
                          setState(() => _selectedAmPm = index);
                          _onChanged();
                        },
                        flex: 2,
                      ),
                      _buildDivider(),
                      _buildWheel(
                        controller: _hourController,
                        itemCount: 12,
                        labelBuilder: (index) => '${index + 1}시',
                        onChanged: (index) {
                          setState(() => _selectedHour = index + 1);
                          _onChanged();
                        },
                        flex: 2,
                      ),
                      _buildDivider(),
                      _buildWheel(
                        controller: _minuteController,
                        itemCount: 60,
                        labelBuilder: (index) => '${index.toString().padLeft(2, '0')}분',
                        onChanged: (index) {
                          setState(() => _selectedMinute = index);
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
                        '${_formatDisplay()} 선택',
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
            final isSelected = controller.hasClients && controller.selectedItem == index;
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

  Widget _buildDivider() {
    return Container(width: 1, height: 100, color: Color(0xffE8E8E8));
  }
}
