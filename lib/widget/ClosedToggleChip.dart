import 'package:flutter/material.dart';

class ClosedToggleChip extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const ClosedToggleChip({
    super.key,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.orangeAccent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.orangeAccent : Color(0xffE8E8E8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.check_circle_outline,
              size: 16,
              color: isActive ? Colors.white : Colors.grey,
            ),
            SizedBox(width: 4),
            Text(
              '마감 포함',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
