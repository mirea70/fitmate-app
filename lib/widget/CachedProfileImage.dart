import 'dart:typed_data';

import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:fitmate_app/widget/DefaultProfileImage.dart';
import 'package:fitmate_app/widget/ShimmerLoading.dart';
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
  Uint8List? _data;
  bool _fadeIn = false;
  bool _loadDone = false;

  @override
  void initState() {
    super.initState();
    _initImage();
  }

  @override
  void didUpdateWidget(covariant CachedProfileImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageId != oldWidget.imageId) {
      _data = null;
      _fadeIn = false;
      _loadDone = false;
      _initImage();
    }
  }

  void _initImage() {
    if (widget.imageId == null) return;
    final cache = ref.read(imageCacheServiceProvider);
    final cached = cache.get(widget.imageId!);
    if (cached != null) {
      _data = cached;
      _loadDone = true;
      return;
    }
    cache.load(widget.imageId!).then((data) {
      if (mounted) setState(() { _data = data; _fadeIn = data != null; _loadDone = true; });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageId == null) return DefaultProfileImage(size: widget.size);

    if (!_loadDone) {
      return ShimmerBox.circle(size: widget.size);
    }

    if (_data == null) {
      return DefaultProfileImage(size: widget.size);
    }

    final cacheSize = (widget.size * MediaQuery.devicePixelRatioOf(context)).toInt();
    final image = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: ResizeImage(MemoryImage(_data!), width: cacheSize, height: cacheSize),
          fit: BoxFit.cover,
        ),
      ),
    );

    if (_fadeIn) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, opacity, child) => Opacity(opacity: opacity, child: child),
        child: image,
      );
    }
    return image;
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
  Uint8List? _data;
  bool _fadeIn = false;
  bool _loadDone = false;

  @override
  void initState() {
    super.initState();
    _initImage();
  }

  void _initImage() {
    if (widget.imageId == null) return;
    final cache = ref.read(imageCacheServiceProvider);
    final cached = cache.getThumbnail(widget.imageId!);
    if (cached != null) {
      _data = cached;
      _loadDone = true;
      return;
    }
    cache.loadThumbnail(widget.imageId!).then((data) {
      if (mounted) setState(() { _data = data; _fadeIn = data != null; _loadDone = true; });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadDone && widget.imageId != null) {
      return ShimmerBox(
        width: widget.width,
        height: widget.height,
        borderRadius: widget.borderRadius,
      );
    }

    ImageProvider imageProvider = const AssetImage('assets/images/default_intro_image.jpg');
    if (_data != null) {
      final dpr = MediaQuery.devicePixelRatioOf(context);
      imageProvider = ResizeImage(
        MemoryImage(_data!),
        width: (widget.width * dpr).toInt(),
        height: (widget.height * dpr).toInt(),
      );
    }

    final container = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    );

    if (_fadeIn) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, opacity, child) => Opacity(opacity: opacity, child: child),
        child: container,
      );
    }
    return container;
  }
}
