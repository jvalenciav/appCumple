#!/bin/bash
# ================================================================
# FIX: Redisenar mascotas con mucho mas detalle kawaii
# Ejecuta desde la raiz de cynthia_app/: bash fix_pet_design.sh
# ================================================================

echo "Rediseñando mascotas con mejor diseño..."

python3 << 'PYEOF'
filepath = "lib/features/pet/pet_screen.dart"

with open(filepath, "r") as f:
    content = f.read()

# Reemplazar todo el _PetPainter con uno mucho más detallado
old_painter_start = "class _PetPainter extends CustomPainter {"
old_painter_end = """  @override
  bool shouldRepaint(covariant _PetPainter old) => true;
}"""

# Encontrar indices
start_idx = content.index(old_painter_start)
end_idx = content.index(old_painter_end, start_idx) + len(old_painter_end)

new_painter = '''class _PetPainter extends CustomPainter {
  final String type;
  final Color color;
  final bool isSleeping;
  final int happiness;
  final int hygiene;

  _PetPainter({required this.type, required this.color, required this.isSleeping, required this.happiness, required this.hygiene});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    switch (type) {
      case 'cat':
        _drawCat(canvas, cx, cy);
        break;
      case 'dog':
        _drawDog(canvas, cx, cy);
        break;
      case 'owl':
        _drawOwl(canvas, cx, cy);
        break;
      case 'whale':
        _drawWhale(canvas, cx, cy);
        break;
      case 'bunny':
        _drawBunny(canvas, cx, cy);
        break;
      case 'hamster':
        _drawHamster(canvas, cx, cy);
        break;
    }

    // Manchas de suciedad (para todos)
    if (hygiene < 40) {
      final dirtPaint = Paint()..color = const Color(0xFF795548).withOpacity(0.25);
      canvas.drawOval(Rect.fromCenter(center: Offset(cx + 22, cy + 18), width: 12, height: 8), dirtPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(cx - 20, cy + 22), width: 10, height: 7), dirtPaint);
      canvas.drawCircle(Offset(cx + 8, cy + 28), 4, dirtPaint);
    }
  }

  // Ojos compartidos para todas las mascotas
  void _drawEyes(Canvas canvas, double cx, double cy, {double spacing = 12, double size = 5.5, double yOffset = 0}) {
    final eyePaint = Paint()..color = const Color(0xFF1A1A2E);
    if (isSleeping) {
      final closedPaint = Paint()
        ..color = const Color(0xFF1A1A2E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCenter(center: Offset(cx - spacing, cy + yOffset), width: size * 2, height: size * 1.5), 0, -3.14159, false, closedPaint);
      canvas.drawArc(Rect.fromCenter(center: Offset(cx + spacing, cy + yOffset), width: size * 2, height: size * 1.5), 0, -3.14159, false, closedPaint);
    } else {
      // Ojo izquierdo
      canvas.drawCircle(Offset(cx - spacing, cy + yOffset), size, eyePaint);
      canvas.drawCircle(Offset(cx - spacing + 1.5, cy + yOffset - 1.5), size * 0.4, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(cx - spacing - 1, cy + yOffset + 1.5), size * 0.2, Paint()..color = Colors.white.withOpacity(0.6));
      // Ojo derecho
      canvas.drawCircle(Offset(cx + spacing, cy + yOffset), size, eyePaint);
      canvas.drawCircle(Offset(cx + spacing + 1.5, cy + yOffset - 1.5), size * 0.4, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(cx + spacing - 1, cy + yOffset + 1.5), size * 0.2, Paint()..color = Colors.white.withOpacity(0.6));
    }
  }

  // Rubor compartido
  void _drawBlush(Canvas canvas, double cx, double cy, {double spacing = 20, double yOffset = 5}) {
    if (happiness > 65 && !isSleeping) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx - spacing, cy + yOffset), width: 12, height: 7),
        Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.3),
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx + spacing, cy + yOffset), width: 12, height: 7),
        Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.3),
      );
    }
  }

  // Boca compartida
  void _drawMouth(Canvas canvas, double cx, double cy, {double yOffset = 15}) {
    if (isSleeping) return;
    final paint = Paint()..color = const Color(0xFF1A1A2E)..style = PaintingStyle.stroke..strokeWidth = 1.8..strokeCap = StrokeCap.round;
    if (happiness > 60) {
      canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + yOffset), width: 14, height: 10), 0, 3.14159, false, paint);
    } else if (happiness > 30) {
      canvas.drawLine(Offset(cx - 5, cy + yOffset), Offset(cx + 5, cy + yOffset), paint);
    } else {
      canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + yOffset + 4), width: 12, height: 8), 0, -3.14159, false, paint);
    }
  }

  // Sombra debajo
  void _drawShadow(Canvas canvas, double cx, double cy, double w, double h) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + h / 2 + 8), width: w * 0.7, height: 10),
      Paint()..color = Colors.black.withOpacity(0.1),
    );
  }

  Color get _dark => Color.lerp(color, Colors.black, 0.25)!;
  Color get _light => Color.lerp(color, Colors.white, 0.3)!;
  Color get _veryLight => Color.lerp(color, Colors.white, 0.5)!;

  // ============================================================
  // GATITO
  // ============================================================
  void _drawCat(Canvas canvas, double cx, double cy) {
    _drawShadow(canvas, cx, cy, 70, 65);

    // Cola curva
    final tailPaint = Paint()..color = _dark..style = PaintingStyle.stroke..strokeWidth = 6..strokeCap = StrokeCap.round;
    final tailPath = Path()
      ..moveTo(cx + 25, cy + 22)
      ..cubicTo(cx + 50, cy + 15, cx + 55, cy - 10, cx + 42, cy - 20);
    canvas.drawPath(tailPath, tailPaint);

    // Cuerpo ovalado
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 15), width: 58, height: 45), Paint()..color = color);

    // Patas delanteras
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 22, cy + 26, 14, 18), const Radius.circular(7)), Paint()..color = color);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx + 8, cy + 26, 14, 18), const Radius.circular(7)), Paint()..color = color);
    // Patitas (cojinetes)
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 15, cy + 42), width: 12, height: 7), Paint()..color = _veryLight);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 15, cy + 42), width: 12, height: 7), Paint()..color = _veryLight);

    // Cabeza grande (kawaii = cabeza grande)
    canvas.drawCircle(Offset(cx, cy - 10), 30, Paint()..color = color);

    // Orejas triangulares
    final earPaint = Paint()..color = color;
    final innerEarPaint = Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.4);

    final earL = Path()..moveTo(cx - 24, cy - 28)..lineTo(cx - 34, cy - 55)..lineTo(cx - 8, cy - 34)..close();
    final earR = Path()..moveTo(cx + 24, cy - 28)..lineTo(cx + 34, cy - 55)..lineTo(cx + 8, cy - 34)..close();
    canvas.drawPath(earL, earPaint);
    canvas.drawPath(earR, earPaint);

    final iearL = Path()..moveTo(cx - 22, cy - 30)..lineTo(cx - 30, cy - 50)..lineTo(cx - 12, cy - 34)..close();
    final iearR = Path()..moveTo(cx + 22, cy - 30)..lineTo(cx + 30, cy - 50)..lineTo(cx + 12, cy - 34)..close();
    canvas.drawPath(iearL, innerEarPaint);
    canvas.drawPath(iearR, innerEarPaint);

    // Marca en la frente (mancha clara)
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 20), width: 14, height: 8), Paint()..color = _light.withOpacity(0.3));

    // Bigotes
    final whiskerPaint = Paint()..color = Colors.white.withOpacity(0.5)..strokeWidth = 1..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 14, cy - 3), Offset(cx - 42, cy - 8), whiskerPaint);
    canvas.drawLine(Offset(cx - 14, cy), Offset(cx - 42, cy + 2), whiskerPaint);
    canvas.drawLine(Offset(cx - 14, cy + 3), Offset(cx - 40, cy + 10), whiskerPaint);
    canvas.drawLine(Offset(cx + 14, cy - 3), Offset(cx + 42, cy - 8), whiskerPaint);
    canvas.drawLine(Offset(cx + 14, cy), Offset(cx + 42, cy + 2), whiskerPaint);
    canvas.drawLine(Offset(cx + 14, cy + 3), Offset(cx + 40, cy + 10), whiskerPaint);

    // Nariz triangular
    final nosePath = Path()..moveTo(cx, cy + 2)..lineTo(cx - 4, cy - 3)..lineTo(cx + 4, cy - 3)..close();
    canvas.drawPath(nosePath, Paint()..color = const Color(0xFFFF8FAB));

    _drawEyes(canvas, cx, cy, yOffset: -12, spacing: 12);
    _drawBlush(canvas, cx, cy, yOffset: -2, spacing: 22);
    _drawMouth(canvas, cx, cy, yOffset: 6);
  }

  // ============================================================
  // PERRITO
  // ============================================================
  void _drawDog(Canvas canvas, double cx, double cy) {
    _drawShadow(canvas, cx, cy, 70, 65);

    // Cola moviéndose
    final tailPaint = Paint()..color = _dark..style = PaintingStyle.stroke..strokeWidth = 7..strokeCap = StrokeCap.round;
    final tailPath = Path()
      ..moveTo(cx + 22, cy + 10)
      ..cubicTo(cx + 40, cy - 5, cx + 48, cy - 25, cx + 38, cy - 35);
    canvas.drawPath(tailPath, tailPaint);

    // Cuerpo
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 16), width: 60, height: 42), Paint()..color = color);

    // Patas
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 24, cy + 26, 16, 20), const Radius.circular(8)), Paint()..color = color);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx + 8, cy + 26, 16, 20), const Radius.circular(8)), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 16, cy + 44), width: 14, height: 8), Paint()..color = _veryLight);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 16, cy + 44), width: 14, height: 8), Paint()..color = _veryLight);

    // Cabeza
    canvas.drawCircle(Offset(cx, cy - 10), 32, Paint()..color = color);

    // Orejas caidas (redondeadas)
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 30, cy - 8), width: 22, height: 38), Paint()..color = _dark);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 30, cy - 8), width: 22, height: 38), Paint()..color = _dark);

    // Mancha en la cara
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 2), width: 28, height: 22), Paint()..color = _veryLight.withOpacity(0.5));

    // Hocico
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 2), width: 20, height: 14), Paint()..color = _light);
    // Nariz
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 2), width: 10, height: 7), Paint()..color = const Color(0xFF3E2723));
    // Brillo nariz
    canvas.drawCircle(Offset(cx - 1.5, cy - 3.5), 2, Paint()..color = Colors.white.withOpacity(0.3));

    // Lengua (si feliz)
    if (!isSleeping && happiness > 50) {
      canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 12), width: 9, height: 13), Paint()..color = const Color(0xFFEF9A9A));
      canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 10), width: 7, height: 6), Paint()..color = const Color(0xFFE57373));
    }

    _drawEyes(canvas, cx, cy, yOffset: -14, spacing: 13, size: 5);
    _drawBlush(canvas, cx, cy, yOffset: 0, spacing: 24);
    _drawMouth(canvas, cx, cy, yOffset: 7);
  }

  // ============================================================
  // BUHITO
  // ============================================================
  void _drawOwl(Canvas canvas, double cx, double cy) {
    _drawShadow(canvas, cx, cy, 65, 60);

    // Cuerpo ovalado
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 10), width: 55, height: 60), Paint()..color = color);

    // Panza clara
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 18), width: 34, height: 36), Paint()..color = _veryLight.withOpacity(0.4));

    // Alas
    final wingL = Path()
      ..moveTo(cx - 24, cy)
      ..quadraticBezierTo(cx - 48, cy + 10, cx - 35, cy + 32)
      ..quadraticBezierTo(cx - 28, cy + 20, cx - 24, cy + 15);
    canvas.drawPath(wingL, Paint()..color = _dark);
    final wingR = Path()
      ..moveTo(cx + 24, cy)
      ..quadraticBezierTo(cx + 48, cy + 10, cx + 35, cy + 32)
      ..quadraticBezierTo(cx + 28, cy + 20, cx + 24, cy + 15);
    canvas.drawPath(wingR, Paint()..color = _dark);

    // Patitas
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 10, cy + 38), width: 14, height: 8), Paint()..color = const Color(0xFFFFB74D));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 10, cy + 38), width: 14, height: 8), Paint()..color = const Color(0xFFFFB74D));

    // Cabeza
    canvas.drawCircle(Offset(cx, cy - 14), 28, Paint()..color = color);

    // Plumitas/orejas
    final earL = Path()..moveTo(cx - 18, cy - 30)..lineTo(cx - 28, cy - 52)..lineTo(cx - 8, cy - 35)..close();
    final earR = Path()..moveTo(cx + 18, cy - 30)..lineTo(cx + 28, cy - 52)..lineTo(cx + 8, cy - 35)..close();
    canvas.drawPath(earL, Paint()..color = _dark);
    canvas.drawPath(earR, Paint()..color = _dark);

    // Disco facial (circulos alrededor de ojos)
    canvas.drawCircle(Offset(cx - 12, cy - 14), 14, Paint()..color = _light.withOpacity(0.4));
    canvas.drawCircle(Offset(cx + 12, cy - 14), 14, Paint()..color = _light.withOpacity(0.4));

    // Pico
    final beakPath = Path()..moveTo(cx - 5, cy - 4)..lineTo(cx, cy + 4)..lineTo(cx + 5, cy - 4)..close();
    canvas.drawPath(beakPath, Paint()..color = const Color(0xFFFFB74D));

    _drawEyes(canvas, cx, cy, yOffset: -16, spacing: 12, size: 6);
    _drawBlush(canvas, cx, cy, yOffset: -6, spacing: 22);
  }

  // ============================================================
  // BALLENITA
  // ============================================================
  void _drawWhale(Canvas canvas, double cx, double cy) {
    _drawShadow(canvas, cx, cy, 80, 50);

    // Cuerpo principal (mas ovalado horizontalmente)
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 5), width: 78, height: 55), Paint()..color = color);

    // Panza clara
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 14), width: 52, height: 30), Paint()..color = _veryLight.withOpacity(0.4));

    // Cola
    final tailPath = Path()
      ..moveTo(cx + 36, cy + 5)
      ..quadraticBezierTo(cx + 52, cy - 2, cx + 55, cy - 18)
      ..quadraticBezierTo(cx + 50, cy - 5, cx + 48, cy + 2)
      ..quadraticBezierTo(cx + 50, cy + 10, cx + 55, cy + 22)
      ..quadraticBezierTo(cx + 52, cy + 12, cx + 36, cy + 8);
    canvas.drawPath(tailPath, Paint()..color = _dark);

    // Aletas laterales
    final finL = Path()
      ..moveTo(cx - 20, cy + 10)
      ..quadraticBezierTo(cx - 42, cy + 18, cx - 35, cy + 30)
      ..quadraticBezierTo(cx - 25, cy + 22, cx - 18, cy + 15);
    canvas.drawPath(finL, Paint()..color = _dark);

    // Chorro de agua
    if (!isSleeping) {
      final waterColor = const Color(0xFF90CAF9).withOpacity(0.5);
      canvas.drawCircle(Offset(cx - 2, cy - 28), 4, Paint()..color = waterColor);
      canvas.drawCircle(Offset(cx - 7, cy - 36), 3.5, Paint()..color = waterColor.withOpacity(0.4));
      canvas.drawCircle(Offset(cx + 5, cy - 37), 3, Paint()..color = waterColor.withOpacity(0.3));
      canvas.drawCircle(Offset(cx - 3, cy - 44), 2.5, Paint()..color = waterColor.withOpacity(0.2));
    }

    _drawEyes(canvas, cx, cy, yOffset: -6, spacing: 14, size: 5);
    _drawBlush(canvas, cx, cy, yOffset: 4, spacing: 24);
    _drawMouth(canvas, cx, cy, yOffset: 10);
  }

  // ============================================================
  // CONEJITO
  // ============================================================
  void _drawBunny(Canvas canvas, double cx, double cy) {
    _drawShadow(canvas, cx, cy, 60, 60);

    // Orejas largas (detras de la cabeza)
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 14, cy - 48), width: 18, height: 45), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 14, cy - 48), width: 18, height: 45), Paint()..color = color);
    // Interior orejas
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 14, cy - 48), width: 9, height: 34), Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.35));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 14, cy - 48), width: 9, height: 34), Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.35));

    // Cuerpo
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 16), width: 52, height: 44), Paint()..color = color);
    // Panza
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 20), width: 30, height: 28), Paint()..color = _veryLight.withOpacity(0.3));

    // Patitas
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 16, cy + 36), width: 16, height: 10), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 16, cy + 36), width: 16, height: 10), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 16, cy + 38), width: 10, height: 5), Paint()..color = _veryLight);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 16, cy + 38), width: 10, height: 5), Paint()..color = _veryLight);

    // Colita trasera (bolita)
    canvas.drawCircle(Offset(cx + 24, cy + 22), 8, Paint()..color = _veryLight);

    // Cabeza
    canvas.drawCircle(Offset(cx, cy - 10), 28, Paint()..color = color);

    // Nariz
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 2), width: 8, height: 6), Paint()..color = const Color(0xFFFF8FAB));

    _drawEyes(canvas, cx, cy, yOffset: -14, spacing: 11, size: 5);
    _drawBlush(canvas, cx, cy, yOffset: -4, spacing: 20);
    _drawMouth(canvas, cx, cy, yOffset: 4);
  }

  // ============================================================
  // HAMSTER
  // ============================================================
  void _drawHamster(Canvas canvas, double cx, double cy) {
    _drawShadow(canvas, cx, cy, 65, 55);

    // Cuerpo regordete
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 12), width: 58, height: 50), Paint()..color = color);
    // Panza
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 18), width: 36, height: 30), Paint()..color = _veryLight.withOpacity(0.4));

    // Patitas cortas
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 18, cy + 34), width: 14, height: 10), Paint()..color = _dark);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 18, cy + 34), width: 14, height: 10), Paint()..color = _dark);
    // Manitas
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 24, cy + 14), width: 10, height: 8), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 24, cy + 14), width: 10, height: 8), Paint()..color = color);

    // Cabeza grande
    canvas.drawCircle(Offset(cx, cy - 10), 30, Paint()..color = color);

    // Cachetes GORDOS (caracteristica del hamster)
    final cheekColor = Color.lerp(color, const Color(0xFFFF8FAB), 0.25)!;
    canvas.drawCircle(Offset(cx - 26, cy - 2), 14, Paint()..color = cheekColor);
    canvas.drawCircle(Offset(cx + 26, cy - 2), 14, Paint()..color = cheekColor);

    // Orejas redondas
    canvas.drawCircle(Offset(cx - 24, cy - 30), 11, Paint()..color = _dark);
    canvas.drawCircle(Offset(cx + 24, cy - 30), 11, Paint()..color = _dark);
    canvas.drawCircle(Offset(cx - 24, cy - 30), 7, Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.35));
    canvas.drawCircle(Offset(cx + 24, cy - 30), 7, Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.35));

    // Marca en la cabeza
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 22), width: 20, height: 12), Paint()..color = _dark.withOpacity(0.3));

    // Nariz
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 2), width: 7, height: 5), Paint()..color = const Color(0xFFFF8FAB));

    // Bigotitos
    final whiskerPaint = Paint()..color = Colors.white.withOpacity(0.4)..strokeWidth = 0.8..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 10, cy - 1), Offset(cx - 30, cy - 5), whiskerPaint);
    canvas.drawLine(Offset(cx - 10, cy + 1), Offset(cx - 30, cy + 4), whiskerPaint);
    canvas.drawLine(Offset(cx + 10, cy - 1), Offset(cx + 30, cy - 5), whiskerPaint);
    canvas.drawLine(Offset(cx + 10, cy + 1), Offset(cx + 30, cy + 4), whiskerPaint);

    _drawEyes(canvas, cx, cy, yOffset: -12, spacing: 11, size: 5);
    _drawBlush(canvas, cx, cy, yOffset: 0, spacing: 26);
    _drawMouth(canvas, cx, cy, yOffset: 5);
  }

  @override
  bool shouldRepaint(covariant _PetPainter old) => true;
}'''

content = content[:start_idx] + new_painter + content[end_idx:]

with open(filepath, "w") as f:
    f.write(content)

print("  Fixed: Mascotas rediseñadas con mucho mas detalle")
PYEOF

echo ""
echo "Listo. Ejecuta: flutter run"
