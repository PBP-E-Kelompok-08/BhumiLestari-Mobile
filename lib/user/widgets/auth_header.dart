import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const double authHeaderTallHeight = 390;
const double authHeaderCompactHeight = 210;

/// Header ilustrasi (langit krem + bukit + bunga) untuk halaman Login & Sign Up.
/// [compact] = versi pendek untuk Sign Up (logo di kiri, judul di kanan).
class AuthHeader extends StatelessWidget {
  final bool compact;
  const AuthHeader({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final height = compact ? authHeaderCompactHeight : authHeaderTallHeight;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _LandscapePainter(compact: compact)),
          ),
          Positioned.fill(
            child: compact ? const _CompactContent() : const _TallContent(),
          ),
        ],
      ),
    );
  }
}

Widget _logo(double size) => ClipOval(
      child: Image.asset('assets/images/logo.png',
          width: size, height: size, fit: BoxFit.cover),
    );

TextStyle _titleStyle(double size) => GoogleFonts.dmSerifDisplay(
      fontSize: size,
      color: const Color(0xFF1B1B1B),
    );

TextStyle _subtitleStyle(double size) => GoogleFonts.lora(
      fontSize: size,
      height: 1.35,
      color: const Color(0xFF2B2B2B),
    );

class _TallContent extends StatelessWidget {
  const _TallContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 54),
      child: Column(
        children: [
          _logo(96),
          const SizedBox(height: 18),
          Text('BhumiLestari', style: _titleStyle(34)),
          const SizedBox(height: 8),
          Text(
            'Produk ramah lingkungan,\nuntuk masa depan yang lebih baik.',
            textAlign: TextAlign.center,
            style: _subtitleStyle(15),
          ),
        ],
      ),
    );
  }
}

class _CompactContent extends StatelessWidget {
  const _CompactContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 34, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _logo(64),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('BhumiLestari', style: _titleStyle(26)),
                ),
                const SizedBox(height: 2),
                Text(
                  'Produk ramah lingkungan,\nuntuk masa depan yang lebih baik.',
                  textAlign: TextAlign.center,
                  style: _subtitleStyle(12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LandscapePainter extends CustomPainter {
  final bool compact;
  _LandscapePainter({required this.compact});

  static const _sky = Color(0xFFF2EDC9);
  static const _leaf = Color(0xFF5E7C4E);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..isAntiAlias = true;

    // Langit
    canvas.drawRect(Offset.zero & size, paint..color = _sky);

    // Cahaya melingkar di belakang logo
    final glowCenter = compact ? const Offset(54, 66) : Offset(w / 2, 102);
    final radii = compact ? [120.0, 86.0, 58.0] : [w * 0.62, w * 0.44, w * 0.3];
    final alphas = [0.25, 0.35, 0.5];
    for (var i = 0; i < radii.length; i++) {
      canvas.drawCircle(glowCenter, radii[i],
          paint..color = Colors.white.withValues(alpha: alphas[i]));
    }

    // Lingkaran putus-putus di sekeliling logo
    final dotRadius = compact ? 44.0 : 70.0;
    paint.color = const Color(0xFFCFC69A);
    for (var deg = 0; deg < 360; deg += 7) {
      final r = deg * math.pi / 180;
      canvas.drawCircle(
        glowCenter + Offset(math.cos(r), math.sin(r)) * dotRadius,
        1.1,
        paint,
      );
    }

    // Burung
    final birdPaint = Paint()
      ..color = const Color(0xFF6E6A50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    final birds = compact
        ? [Offset(w * 0.86, 30), Offset(w * 0.9, 46)]
        : [Offset(w * 0.12, 112), Offset(w * 0.8, 50), Offset(w * 0.86, 66)];
    for (final b in birds) {
      final p = Path()
        ..moveTo(b.dx - 7, b.dy)
        ..quadraticBezierTo(b.dx - 3.5, b.dy - 4, b.dx, b.dy)
        ..quadraticBezierTo(b.dx + 3.5, b.dy - 4, b.dx + 7, b.dy);
      canvas.drawPath(p, birdPaint);
    }

    // Garis dasar bukit (kartu putih menutupi 28px terbawah)
    final top = compact ? h - 92 : h - 128;

    // Awan
    paint.color = Colors.white.withValues(alpha: 0.9);
    _cloud(canvas, paint, Offset(w * 0.86, top + 2), compact ? 0.8 : 1.0);
    _cloud(canvas, paint, Offset(w * 0.6, top + 10), compact ? 0.6 : 0.75);

    // Bukit belakang -> depan
    _hill(canvas, size, top + 18, const Color(0xFFDDE3B1), [0.3, -12, 0.65, 22, 0]);
    _hill(canvas, size, top + 40, const Color(0xFFC8D697), [0.35, 18, 0.7, -14, 6]);

    // Semak
    paint.color = const Color(0xFF8FA864);
    canvas.drawCircle(Offset(w * 0.28, top + 36), 9, paint);
    canvas.drawCircle(Offset(w * 0.32, top + 33), 11, paint);
    canvas.drawCircle(Offset(w * 0.36, top + 37), 8, paint);
    canvas.drawCircle(Offset(w * 0.74, top + 34), 9, paint);
    canvas.drawCircle(Offset(w * 0.78, top + 31), 7, paint);

    _hill(canvas, size, top + 62, const Color(0xFFB2C77F), [0.4, -10, 0.7, 16, -4]);

    // Bunga kecil
    final flowers = [0.12, 0.24, 0.4, 0.52, 0.66, 0.8, 0.92];
    final flowerY = compact ? top + 50 : top + 74;
    for (var i = 0; i < flowers.length; i++) {
      _flower(canvas, Offset(w * flowers[i], flowerY + (i.isEven ? 0 : 8)));
    }

    // Tanaman di sisi kiri & kanan
    if (!compact) _plant(canvas, Offset(w * 0.06, h), h - top + 16, flip: false);
    _plant(canvas, Offset(w * 0.95, h), h - top + (compact ? 30 : 26), flip: true);
  }

  /// [c] = [x1 ratio, dy1, x2 ratio, dy2, dyEnd]
  void _hill(Canvas canvas, Size size, double y, Color color, List<double> c) {
    final w = size.width;
    final path = Path()
      ..moveTo(0, y)
      ..cubicTo(w * c[0], y + c[1], w * c[2], y + c[3], w, y + c[4])
      ..lineTo(w, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _cloud(Canvas canvas, Paint paint, Offset c, double s) {
    canvas.drawCircle(c + Offset(-16 * s, 6 * s), 11 * s, paint);
    canvas.drawCircle(c + Offset(0, 0), 15 * s, paint);
    canvas.drawCircle(c + Offset(16 * s, 5 * s), 12 * s, paint);
    canvas.drawRect(
        Rect.fromLTRB(c.dx - 16 * s, c.dy + 4 * s, c.dx + 16 * s, c.dy + 17 * s),
        paint);
  }

  void _flower(Canvas canvas, Offset c) {
    final petal = Paint()..color = Colors.white;
    for (var i = 0; i < 5; i++) {
      final a = i * 2 * math.pi / 5;
      canvas.drawCircle(c + Offset(math.cos(a), math.sin(a)) * 3.2, 2.6, petal);
    }
    canvas.drawCircle(c, 1.8, Paint()..color = const Color(0xFFE8C468));
  }

  void _plant(Canvas canvas, Offset base, double height, {required bool flip}) {
    final dir = flip ? -1.0 : 1.0;
    final stem = Paint()
      ..color = _leaf
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final tip = base + Offset(10 * dir, -height);
    final path = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(base.dx - 4 * dir, base.dy - height * 0.5, tip.dx, tip.dy);
    canvas.drawPath(path, stem);

    final leaf = Paint()..color = _leaf;
    for (var i = 0; i < 4; i++) {
      final t = 0.25 + i * 0.2;
      final p = Offset(base.dx + 2 * dir * t, base.dy - height * t);
      final side = i.isEven ? 1.0 : -1.0;
      _leafShape(canvas, p, 18 - i * 2.0, (-math.pi / 2) + side * 0.9, leaf);
    }
  }

  void _leafShape(Canvas canvas, Offset at, double len, double angle, Paint p) {
    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.rotate(angle + math.pi / 2);
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(len * 0.35, -len * 0.5, 0, -len)
      ..quadraticBezierTo(-len * 0.35, -len * 0.5, 0, 0);
    canvas.drawPath(path, p);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LandscapePainter old) => old.compact != compact;
}
