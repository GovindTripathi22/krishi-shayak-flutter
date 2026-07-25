import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class HomeSkeletonLoader extends StatelessWidget {
  const HomeSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Skeleton
          _SkeletonBox(height: 60.0, borderRadius: AppConstants.radiusMedium),
          const SizedBox(height: 16.0),
          // Weather Skeleton
          _SkeletonBox(height: 170.0, borderRadius: AppConstants.radiusMedium),
          const SizedBox(height: 24.0),
          // Quick Actions Skeleton
          _SkeletonBox(height: 140.0, borderRadius: AppConstants.radiusMedium),
          const SizedBox(height: 24.0),
          // Recommended Carousel Skeleton
          _SkeletonBox(height: 210.0, borderRadius: AppConstants.radiusMedium),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatefulWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const _SkeletonBox({
    required this.height,
    this.width,
    required this.borderRadius,
  });

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        height: widget.height,
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}
