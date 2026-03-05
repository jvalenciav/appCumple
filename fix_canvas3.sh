#!/bin/bash
# ================================================================
# FIX: El lienzo no muestra los trazos (child tapa el painter)
# Ejecuta desde la raiz de cynthia_app/: bash fix_canvas3.sh
# ================================================================

echo "Corrigiendo lienzo..."

python3 << 'PYEOF'
filepath = "lib/features/canvas/canvas_screen.dart"

with open(filepath, "r") as f:
    content = f.read()

# El problema: CustomPaint pinta el painter DEBAJO del child.
# El Container(color: Colors.white) como child tapa todo.
# Solucion: usar foregroundPainter en vez de painter

content = content.replace(
    """                        child: CustomPaint(
                            painter: _CanvasPainter(""",
    """                        child: CustomPaint(
                            foregroundPainter: _CanvasPainter("""
)

with open(filepath, "w") as f:
    f.write(content)

print("  Fixed: canvas ahora usa foregroundPainter")
PYEOF

echo ""
echo "Listo. Ejecuta: flutter run"
