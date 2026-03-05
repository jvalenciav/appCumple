#!/bin/bash
# ================================================================
# FIX: Corregir errores de canvas_screen.dart
# Ejecuta desde la raiz de cynthia_app/: bash fix_canvas2.sh
# ================================================================

echo "Corrigiendo canvas_screen.dart..."

python3 << 'PYEOF'
filepath = "lib/features/canvas/canvas_screen.dart"

with open(filepath, "r") as f:
    content = f.read()

# Fix 1: Cambiar start: y end: por shapeStart: y shapeEnd: en _onPanEnd
content = content.replace(
    "          start: _shapeStart!,\n          end: _shapeEnd!,",
    "          shapeStart: _shapeStart!,\n          shapeEnd: _shapeEnd!,"
)

# Fix 2: Asegurar que _DrawAction.shape constructor use this.shapeStart
content = content.replace(
    "required _ShapeType this.shape,\n    required Offset this.shapeStart,\n    required Offset this.shapeEnd,",
    "required this.shape,\n    required this.shapeStart,\n    required this.shapeEnd,"
)

with open(filepath, "w") as f:
    f.write(content)

print("  Fixed: canvas_screen.dart")
PYEOF

echo ""
echo "Listo. Ejecuta: flutter run"
