import 'package:flutter/material.dart';

class DefaultProfileImage extends StatelessWidget {
  final double size;

  const DefaultProfileImage({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffE0E0E0),
      ),
      child: ClipOval(
        child: Transform.scale(
          scale: 1.2,
          child: Image.asset(
            'assets/images/default_profile.jpeg',
            fit: BoxFit.cover,
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}
