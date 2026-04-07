import 'package:flutter/material.dart';

class MateListFilterViewAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MateListFilterViewAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        '필터 결과',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 22,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
