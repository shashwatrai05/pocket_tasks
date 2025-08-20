import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 44,
    this.strokeWidth = 6,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress.clamp(0.0, 1.0),
          color: Theme.of(context).colorScheme.primary,
          trackColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Text(
            '${(progress * 100).round()}%',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Track
    canvas.drawCircle(center, radius, trackPaint);

    // Arc: start from top (-90°)
    final startAngle = -90 * (3.1415926535897932 / 180.0);
    final sweepAngle = 2 * 3.1415926535897932 * progress;

    final rect =
        Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        trackColor != oldDelegate.trackColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
