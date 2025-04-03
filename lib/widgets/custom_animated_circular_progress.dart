import 'dart:math';

import 'package:flutter/material.dart';

import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import '../utils/text_style_helper/text_style_helper.dart';
import 'custom_container.dart';
import 'custom_text.dart';

class AnimatedCircularProgress extends StatefulWidget {
  final double percentage; // Percentage to animate to (0-100)
  final double size; // Size of the circular progress
  final Color color; // Progress color
  final Duration duration; // Animation duration

  const AnimatedCircularProgress({
    super.key,
    required this.percentage,
    this.size = 0,
    this.color = Colors.blue,
    this.duration = const Duration(seconds: 2),
  });

  @override
  _AnimatedCircularProgressState createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(begin: 0, end: widget.percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: 0,
        end: widget.percentage,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.forward(from: 0); // Restart animation
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomContainer(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Circle
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: CirclePainter(
                  progress: _animation.value,
                  color: widget.color,
                ),
              ),

              // Animated Text
              CustomText(
                text: "${_animation.value.toInt()}%",
                style: TextStyleHelper.mediumHeading,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Custom Painter for the Circular Progress
class CirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  CirclePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint trackPaint =
        Paint()
          ..color = AppColors.grey.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = AppSize.size10
          ..strokeCap = StrokeCap.round;

    Paint progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8.0
          ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - 8.0; // Padding from edges

    // Draw background circle
    canvas.drawCircle(center, radius, trackPaint);

    // Draw animated arc
    double sweepAngle = (progress / 100) * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
