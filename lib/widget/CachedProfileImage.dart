import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CachedProfileImage extends ConsumerStatefulWidget {
  final int? imageId;
  final double size;

  const CachedProfileImage({super.key, required this.imageId, required this.size});

  @override
  ConsumerState<CachedProfileImage> createState() => _CachedProfileImageState();
}

class _CachedProfileImageState extends ConsumerState<CachedProfileImage> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _tryLoad();
  }

  void _tryLoad() {
    if (widget.imageId == null) return;
    final cache = ref.read(imageCacheServiceProvider);
    if (cache.has(widget.imageId!)) return;
    cache.load(widget.imageId!).then((_) {
      if (mounted) setState(() => _loaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageId == null) return DefaultProfileImage(size: widget.size);
    final data = ref.read(imageCacheServiceProvider).get(widget.imageId!);
    if (data != null) {
      final cacheSize = (widget.size * MediaQuery.devicePixelRatioOf(context)).toInt();
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: ResizeImage(MemoryImage(data), width: cacheSize, height: cacheSize),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return DefaultProfileImage(size: widget.size);
  }
}

class CachedThumbnailImage extends ConsumerStatefulWidget {
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
  ConsumerState<CachedThumbnailImage> createState() => _CachedThumbnailImageState();
}

class _CachedThumbnailImageState extends ConsumerState<CachedThumbnailImage> {
  @override
  void initState() {
    super.initState();
    _tryLoad();
  }

  void _tryLoad() {
    if (widget.imageId == null) return;
    final cache = ref.read(imageCacheServiceProvider);
    if (cache.has(widget.imageId!)) return;
    cache.load(widget.imageId!).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider = const AssetImage('assets/images/default_intro_image.jpg');
    if (widget.imageId != null) {
      final data = ref.read(imageCacheServiceProvider).get(widget.imageId!);
      if (data != null) {
        final dpr = MediaQuery.devicePixelRatioOf(context);
        imageProvider = ResizeImage(
          MemoryImage(data),
          width: (widget.width * dpr).toInt(),
          height: (widget.height * dpr).toInt(),
        );
      }
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    );
  }
}
