import 'package:flutter/material.dart';

/// Iconen uit het prototype: dunne lijnen, geen vulling. Material's iconenset
/// is een stuk zwaarder, daarom tekenen we deze paar vormen zelf.
enum StrokeShape {
  chevronLeft,
  chevronRight,
  plus,
  minus,
  close,
  calendar,
  barcode,
  ring,
  square,
  dots,
  home,
  trash,
}

class StrokeIcon extends StatelessWidget {
  const StrokeIcon(
    this.shape, {
    super.key,
    this.size = 16,
    this.color,
    this.strokeWidth = 1.7,
  });

  final StrokeShape shape;
  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? IconTheme.of(context).color ?? const Color(0xFF000000);
    final box = switch (shape) {
      StrokeShape.chevronLeft || StrokeShape.chevronRight =>
        Size(size * 9 / 16, size),
      StrokeShape.minus => Size(size, strokeWidth),
      StrokeShape.barcode => Size(size * 20 / 16, size),
      _ => Size.square(size),
    };
    return SizedBox.fromSize(
      size: box,
      child: CustomPaint(
        painter: _StrokePainter(
          shape: shape,
          color: resolved,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _StrokePainter extends CustomPainter {
  const _StrokePainter({
    required this.shape,
    required this.color,
    required this.strokeWidth,
  });

  final StrokeShape shape;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final w = size.width;
    final h = size.height;
    final path = Path();

    switch (shape) {
      case StrokeShape.chevronLeft:
        path
          ..moveTo(w * 0.82, h * 0.06)
          ..lineTo(w * 0.16, h * 0.5)
          ..lineTo(w * 0.82, h * 0.94);
      case StrokeShape.chevronRight:
        path
          ..moveTo(w * 0.18, h * 0.06)
          ..lineTo(w * 0.84, h * 0.5)
          ..lineTo(w * 0.18, h * 0.94);
      case StrokeShape.plus:
        path
          ..moveTo(w / 2, 0)
          ..lineTo(w / 2, h)
          ..moveTo(0, h / 2)
          ..lineTo(w, h / 2);
      case StrokeShape.minus:
        path
          ..moveTo(0, h / 2)
          ..lineTo(w, h / 2);
      case StrokeShape.close:
        path
          ..moveTo(w * 0.08, h * 0.08)
          ..lineTo(w * 0.92, h * 0.92)
          ..moveTo(w * 0.92, h * 0.08)
          ..lineTo(w * 0.08, h * 0.92);
      case StrokeShape.home:
        path
          ..moveTo(w * 0.08, h * 0.48)
          ..lineTo(w * 0.5, h * 0.1)
          ..lineTo(w * 0.92, h * 0.48)
          ..moveTo(w * 0.22, h * 0.42)
          ..lineTo(w * 0.22, h * 0.9)
          ..lineTo(w * 0.78, h * 0.9)
          ..lineTo(w * 0.78, h * 0.42);
      case StrokeShape.calendar:
        final r = RRect.fromLTRBR(
          strokeWidth / 2,
          h * 0.17,
          w - strokeWidth / 2,
          h - strokeWidth / 2,
          const Radius.circular(3),
        );
        canvas.drawRRect(r, paint);
        path
          ..moveTo(strokeWidth / 2, h * 0.42)
          ..lineTo(w - strokeWidth / 2, h * 0.42)
          ..moveTo(w * 0.3, 0)
          ..lineTo(w * 0.3, h * 0.17)
          ..moveTo(w * 0.7, 0)
          ..lineTo(w * 0.7, h * 0.17);
      case StrokeShape.barcode:
        for (final x in const [0.06, 0.26, 0.46, 0.66, 0.9]) {
          path
            ..moveTo(w * x, 0)
            ..lineTo(w * x, h);
        }
      case StrokeShape.ring:
        canvas.drawCircle(
          Offset(w / 2, h / 2),
          (w - strokeWidth) / 2,
          paint..strokeWidth = strokeWidth,
        );
        return;
      case StrokeShape.square:
        canvas.drawRRect(
          RRect.fromLTRBR(
            strokeWidth / 2,
            strokeWidth / 2,
            w - strokeWidth / 2,
            h - strokeWidth / 2,
            const Radius.circular(3),
          ),
          paint,
        );
        return;
      case StrokeShape.dots:
        final dot = Paint()..color = color;
        final radius = w * 0.115;
        for (final x in [w * 0.16, w * 0.5, w * 0.84]) {
          canvas.drawCircle(Offset(x, h / 2), radius, dot);
        }
        return;
      case StrokeShape.trash:
        path
          ..moveTo(w * 0.18, h * 0.30)
          ..lineTo(w * 0.82, h * 0.30)
          ..moveTo(w * 0.28, h * 0.30)
          ..lineTo(w * 0.34, h * 0.90)
          ..lineTo(w * 0.66, h * 0.90)
          ..lineTo(w * 0.72, h * 0.30)
          ..moveTo(w * 0.38, h * 0.30)
          ..lineTo(w * 0.40, h * 0.12)
          ..lineTo(w * 0.60, h * 0.12)
          ..lineTo(w * 0.62, h * 0.30)
          ..moveTo(w * 0.50, h * 0.42)
          ..lineTo(w * 0.50, h * 0.78);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StrokePainter old) =>
      old.shape != shape || old.color != color || old.strokeWidth != strokeWidth;
}
