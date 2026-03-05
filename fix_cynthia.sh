#!/bin/bash
# ================================================================
# FIX: Corregir el conflicto de AnimatedBuilder
# Ejecuta desde la raiz de cynthia_app/: bash fix_cynthia.sh
# ================================================================

echo "Corrigiendo conflicto AnimatedBuilder..."

# 1. En todos los features, cambiar "listenable:" por "animation:"
FILES=(
  "lib/features/splash/splash_screen.dart"
  "lib/features/home/home_screen.dart"
  "lib/features/book/book_screen.dart"
  "lib/features/map/map_screen.dart"
  "lib/features/reasons/reasons_screen.dart"
  "lib/features/timeline/timeline_screen.dart"
  "lib/features/quotes/quotes_screen.dart"
)

for f in "${FILES[@]}"; do
  if [ -f "$f" ]; then
    # Compatible con macOS sed
    sed -i '' 's/listenable:/animation:/g' "$f" 2>/dev/null || sed -i 's/listenable:/animation:/g' "$f"
    echo "  Fixed: $f"
  fi
done

# 2. Reescribir starfield_background.dart SIN la clase custom AnimatedBuilder
cat > lib/shared/widgets/starfield_background.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StarfieldBackground extends StatefulWidget {
  final int starCount;
  final Widget? child;
  final bool enableShootingStars;

  const StarfieldBackground({
    super.key,
    this.starCount = 150,
    this.child,
    this.enableShootingStars = true,
  });

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with TickerProviderStateMixin {
  late AnimationController _twinkleController;
  late AnimationController _shootingStarController;
  final Random _random = Random();
  late List<Star> _stars;
  ShootingStar? _shootingStar;

  @override
  void initState() {
    super.initState();

    _twinkleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _shootingStarController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _stars = List.generate(widget.starCount, (_) => Star.random(_random));

    if (widget.enableShootingStars) {
      _scheduleShootingStar();
    }
  }

  void _scheduleShootingStar() {
    Future.delayed(Duration(seconds: 3 + _random.nextInt(8)), () {
      if (!mounted) return;
      _shootingStar = ShootingStar.random(_random);
      _shootingStarController.forward(from: 0).then((_) {
        if (mounted) _scheduleShootingStar();
      });
    });
  }

  @override
  void dispose() {
    _twinkleController.dispose();
    _shootingStarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: AnimatedBuilder(
        animation: Listenable.merge([_twinkleController, _shootingStarController]),
        builder: (context, child) {
          return CustomPaint(
            painter: StarfieldPainter(
              stars: _stars,
              twinkleValue: _twinkleController.value,
              shootingStar: _shootingStar,
              shootingStarProgress: _shootingStarController.value,
            ),
            child: child,
          );
        },
        child: widget.child ?? const SizedBox.expand(),
      ),
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double twinkleOffset;
  final double brightness;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.twinkleOffset,
    required this.brightness,
  });

  factory Star.random(Random random) {
    return Star(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: 0.5 + random.nextDouble() * 2.5,
      twinkleOffset: random.nextDouble(),
      brightness: 0.3 + random.nextDouble() * 0.7,
    );
  }
}

class ShootingStar {
  final double startX;
  final double startY;
  final double angle;
  final double length;

  ShootingStar({
    required this.startX,
    required this.startY,
    required this.angle,
    required this.length,
  });

  factory ShootingStar.random(Random random) {
    return ShootingStar(
      startX: 0.2 + random.nextDouble() * 0.6,
      startY: random.nextDouble() * 0.4,
      angle: 0.3 + random.nextDouble() * 0.5,
      length: 0.15 + random.nextDouble() * 0.2,
    );
  }
}

class StarfieldPainter extends CustomPainter {
  final List<Star> stars;
  final double twinkleValue;
  final ShootingStar? shootingStar;
  final double shootingStarProgress;

  StarfieldPainter({
    required this.stars,
    required this.twinkleValue,
    this.shootingStar,
    required this.shootingStarProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle = sin((twinkleValue + star.twinkleOffset) * pi * 2);
      final opacity = (star.brightness + twinkle * 0.3).clamp(0.1, 1.0);

      final paint = Paint()
        ..color = AppColors.starWhite.withOpacity(opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 0.5);

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );

      if (star.size > 1.8) {
        final glowPaint = Paint()
          ..color = AppColors.softLavender.withOpacity(opacity * 0.2)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 3);
        canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height),
          star.size * 2,
          glowPaint,
        );
      }
    }

    if (shootingStar != null && shootingStarProgress > 0) {
      _paintShootingStar(canvas, size);
    }
  }

  void _paintShootingStar(Canvas canvas, Size size) {
    final ss = shootingStar!;
    final progress = shootingStarProgress;

    final startX = ss.startX * size.width;
    final startY = ss.startY * size.height;
    final endX = startX + cos(ss.angle) * ss.length * size.width;
    final endY = startY + sin(ss.angle) * ss.length * size.height;

    final currentX = startX + (endX - startX) * progress;
    final currentY = startY + (endY - startY) * progress;

    final tailLength = 0.3;
    final tailStartProgress = (progress - tailLength).clamp(0.0, 1.0);
    final tailX = startX + (endX - startX) * tailStartProgress;
    final tailY = startY + (endY - startY) * tailStartProgress;

    final opacity = progress < 0.8 ? 1.0 : (1.0 - progress) * 5;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.starWhite.withOpacity(0.5 * opacity),
          AppColors.shimmerGold.withOpacity(opacity),
        ],
      ).createShader(Rect.fromPoints(
        Offset(tailX, tailY),
        Offset(currentX, currentY),
      ))
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(tailX, tailY),
      Offset(currentX, currentY),
      paint,
    );

    final headPaint = Paint()
      ..color = AppColors.pureWhite.withOpacity(opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(currentX, currentY), 2, headPaint);
  }

  @override
  bool shouldRepaint(StarfieldPainter oldDelegate) => true;
}
ENDOFFILE

echo "  Fixed: lib/shared/widgets/starfield_background.dart"
echo ""
echo "Done - ejecuta: flutter run"
