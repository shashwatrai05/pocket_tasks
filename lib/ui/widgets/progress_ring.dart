import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressRing extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final bool showPercentage;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 44,
    this.strokeWidth = 6,
    this.showPercentage = true,
  });

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  double _displayedProgress = 0.0;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _progressAnimation.addListener(() {
      setState(() {
        _displayedProgress = _progressAnimation.value;
      });
    });

    _progressController.forward();
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _displayedProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ));
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background shimmer effect when progress is 0
          if (_displayedProgress == 0.0)
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _ShimmerRingPainter(
                    strokeWidth: widget.strokeWidth,
                    rotation: _rotationController.value,
                  ),
                );
              },
            ),

          // Main progress ring
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _ProgressRingPainter(
              progress: _displayedProgress.clamp(0.0, 1.0),
              strokeWidth: widget.strokeWidth,
            ),
          ),

          // Center content
          if (widget.showPercentage)
            Container(
              width: widget.size - (widget.strokeWidth * 2) - 8,
              height: widget.size - (widget.strokeWidth * 2) - 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(_displayedProgress * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_displayedProgress > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 12,
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    // Track (background circle)
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      // Progress arc with gradient effect
      final rect = Rect.fromCircle(center: center, radius: radius);
      final startAngle = -math.pi / 2; // Start from top
      final sweepAngle = 2 * math.pi * progress;

      // Create gradient colors
      final colors = [
        Colors.white,
        Colors.white.withOpacity(0.8),
      ];

      final progressPaint = Paint()
        ..shader = SweepGradient(
          colors: colors,
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

      // Add glow effect
      final glowPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 2
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}

class _ShimmerRingPainter extends CustomPainter {
  final double strokeWidth;
  final double rotation;

  _ShimmerRingPainter({
    required this.strokeWidth,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Animated shimmer effect
    final shimmerPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
        transform: GradientRotation(rotation * 2 * math.pi),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, shimmerPaint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerRingPainter oldDelegate) {
    return rotation != oldDelegate.rotation;
  }
}