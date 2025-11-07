import 'package:flutter/material.dart';

class TypingLoader extends StatefulWidget {
  final bool showAvatar;
  const TypingLoader({super.key, this.showAvatar = false});

  @override
  State<TypingLoader> createState() => _TypingLoaderState();
}

class _TypingLoaderState extends State<TypingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animations = List.generate(3, (i) {
      final start = i * 0.2;
      final end = start + 0.6;
      return Tween(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(Animation<double> anim) {
    return FadeTransition(
      opacity: anim,
      child: ScaleTransition(
        scale: anim,
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.showAvatar)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFEAEAEA),
              child: Icon(Icons.car_crash_outlined,
                  size: 16, color: Colors.black54),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dot(_animations[0]),
              const SizedBox(width: 4),
              _dot(_animations[1]),
              const SizedBox(width: 4),
              _dot(_animations[2]),
            ],
          ),
        ),
      ],
    );
  }
}
