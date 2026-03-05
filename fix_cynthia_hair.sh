#!/bin/bash
# ================================================================
# FIX: Cambiar pelo de Cynthia chibi a cortito
# Ejecuta desde la raiz de cynthia_app/: bash fix_cynthia_hair.sh
# ================================================================

echo "Cambiando pelo de Cynthia a cortito..."

python3 << 'PYEOF'
filepath = "lib/features/hug/hug_screen.dart"

with open(filepath, "r") as f:
    content = f.read()

old_hair = """    // Pelo largo (oscuro con reflejos)
    final hairPaint = Paint()..color = const Color(0xFF3D2314);
    // Pelo arriba
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 12), width: 36, height: 30),
      pi, pi, true, hairPaint,
    );
    // Pelo a los lados (largo)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 18, cy - 14, 10, 36),
        const Radius.circular(5),
      ),
      hairPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 8, cy - 14, 10, 36),
        const Radius.circular(5),
      ),
      hairPaint,
    );"""

new_hair = """    // Pelo cortito
    final hairPaint = Paint()..color = const Color(0xFF3D2314);
    // Base del pelo (cubre toda la parte superior de la cabeza)
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 10), width: 38, height: 32),
      pi, pi, true, hairPaint,
    );
    // Flequillo cortito con textura
    final bangsPath = Path()
      ..moveTo(cx - 15, cy - 18)
      ..quadraticBezierTo(cx - 10, cy - 12, cx - 5, cy - 15)
      ..quadraticBezierTo(cx, cy - 11, cx + 5, cy - 15)
      ..quadraticBezierTo(cx + 10, cy - 12, cx + 15, cy - 18)
      ..lineTo(cx + 17, cy - 22)
      ..quadraticBezierTo(cx, cy - 28, cx - 17, cy - 22)
      ..close();
    canvas.drawPath(bangsPath, hairPaint);
    // Mechoncitos a los lados (cortitos, solo llegan a las orejas)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 18, cy - 14, 9, 14),
        const Radius.circular(5),
      ),
      hairPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 9, cy - 14, 9, 14),
        const Radius.circular(5),
      ),
      hairPaint,
    );
    // Brillo en el pelo
    final hairShinePaint = Paint()..color = const Color(0xFF5A3A28);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - 4, cy - 18), width: 12, height: 8),
      pi, pi, true, hairShinePaint,
    );"""

if old_hair in content:
    content = content.replace(old_hair, new_hair)
    with open(filepath, "w") as f:
        f.write(content)
    print("  Fixed: Cynthia ahora tiene pelo cortito")
else:
    print("  WARN: No se encontro el bloque exacto. Verificar manualmente.")
PYEOF

echo ""
echo "Listo. Ejecuta: flutter run"
