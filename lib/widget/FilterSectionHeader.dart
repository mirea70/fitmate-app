import 'package:flutter/material.dart';

class FilterSectionHeader extends StatelessWidget {
  final String title;

  const FilterSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: deviceSize.width * 0.03),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
