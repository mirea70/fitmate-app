import 'package:flutter/material.dart';

class DayOfWeekPicker extends StatelessWidget {
  final int selectedIndex;
  final void Function(int index) onSelected;

  const DayOfWeekPicker({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<String> _dayLabels = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(_dayLabels.length, (index) {
        final bool isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onSelected(index),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orangeAccent : Colors.white,
              shape: BoxShape.circle,
              border: !isSelected
                  ? Border.all(
                      color: Color(0xffE8E8E8),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Text(
              _dayLabels[index],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ),
        );
      }),
    );
  }
}
