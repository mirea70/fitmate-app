import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CachedProfileImage extends ConsumerWidget {
  final int? imageId;
  final double size;

  const CachedProfileImage({super.key, required this.imageId, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (imageId == null) return DefaultProfileImage(size: size);
    final data = ref.read(imageCacheServiceProvider).get(imageId!);
    if (data != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: MemoryImage(data), fit: BoxFit.cover),
        ),
      );
    }
    return DefaultProfileImage(size: size);
  }
}

class CachedThumbnailImage extends ConsumerWidget {
  final int? imageId;
  final double width;
  final double height;
  final double borderRadius;

  const CachedThumbnailImage({
    super.key,
    required this.imageId,
    required this.width,
    required this.height,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ImageProvider imageProvider = const AssetImage('assets/images/default_intro_image.jpg');
    if (imageId != null) {
      final data = ref.read(imageCacheServiceProvider).get(imageId!);
      if (data != null) {
        imageProvider = MemoryImage(data);
      }
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    );
  }
}
