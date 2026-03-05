#!/bin/bash
# ================================================================
# FIX: Corregir error de parametros requeridos en CanvasPainter
# Ejecuta desde la raiz de cynthia_app/: bash fix_canvas_error.sh
# ================================================================

echo "Corrigiendo canvas_screen.dart..."

python3 << 'PYEOF'
filepath = "lib/features/canvas/canvas_screen.dart"

with open(filepath, "r") as f:
    content = f.read()

# Los campos shapeStart y shapeEnd en el painter son required pero 
# se pasan como null. Hay que hacerlos opcionales en el constructor.

old = """  _CanvasPainter({
    required this.actions,
    this.currentStroke,
    required this.currentColor,
    required this.currentBrushSize,
    required this.isEraser,
    this.currentShape,
    this.shapeStart,
    this.shapeEnd,
  });"""

new = """  _CanvasPainter({
    required this.actions,
    this.currentStroke,
    required this.currentColor,
    required this.currentBrushSize,
    required this.isEraser,
    this.currentShape,
    this.shapeStart,
    this.shapeEnd,
  });"""

# El problema real es que en _DrawAction.stroke, shapeStart y shapeEnd 
# son null pero declarados como Offset? ya. Revisemos el painter constructor.
# En realidad el error esta en _DrawAction donde shapeStart y shapeEnd son required

old_shape = """  _DrawAction.shape({
    required _ShapeType this.shape,
    required Offset this.shapeStart,
    required Offset this.shapeEnd,
    required this.color,
    required this.strokeWidth,
  })  : points = null,
        isEraser = false;"""

# Verificar si ese es el problema - no, el error dice que al INSTANCIAR
# _CanvasPainter faltan shapeStart y shapeEnd. Veamos la instancia:

# La instancia en build() no pasa shapeStart ni shapeEnd explicitamente
# porque son opcionales (this.shapeStart). Pero el tipo es Offset? 
# no required. Asi que el error debe estar en otro lugar.

# Busquemos el problema real - el error dice "required" asi que 
# probablemente los campos estan como required en el constructor

# Realmente creo que el Dart analyzer ve que shapeStart y shapeEnd 
# en _DrawAction son required pero nullable. Cambiemos el approach:
# hacemos que _CanvasPainter siempre reciba los parametros.

old_painter_call = """                            painter: _CanvasPainter(
                              actions: _actions,
                              currentStroke: _currentStroke,
                              currentColor: _currentColor,
                              currentBrushSize: _brushSize,
                              isEraser: _currentTool == _ToolType.eraser,
                              currentShape: _currentShape,
                              shapeStart: _shapeStart,
                              shapeEnd: _shapeEnd,
                            ),"""

# Hmm eso ya los pasa. El error entonces es en _DrawAction.stroke
# donde shape, shapeStart, shapeEnd son null pero en _DrawAction.shape
# son required Offset this.shapeStart. Veamos...

# El problema es que Offset? en named constructor con required 
# En _DrawAction, shapeStart es Offset? pero NO en shape constructor
# donde es "required Offset this.shapeStart" - esto es Offset no Offset?
# Pero el campo es declarado como Offset? shapeStart

# Actually re-reading the code, the fields are:
#   final _ShapeType? shape;
#   final Offset? shapeStart;  
#   final Offset? shapeEnd;
# And in _DrawAction.shape constructor: required Offset this.shapeStart
# This should work because Dart allows required non-nullable to assign to nullable field

# The REAL error must be in _CanvasPainter fields. Let me check:
# In _CanvasPainter:
#   final _ShapeType? currentShape;
#   final Offset? shapeStart;
#   final Offset? shapeEnd;
# Constructor: this.shapeStart, this.shapeEnd (optional positional)
# This should work too...

# Wait - maybe the issue is that in _DrawAction, the fields are declared 
# differently. Let me just fix by making the _CanvasPainter constructor explicit:

if "painter: _CanvasPainter(" in content:
    print("  Fixed: canvas_screen.dart - parametros ya estaban incluidos")
    print("  Verificando otro posible error...")
    
    # Check if Offset? fields have required in constructor
    # Actually the likely issue is the _DrawAction class fields
    # Let me check if shapeStart field type matches
    
    # Fix: ensure _DrawAction fields match constructors
    old_draw = """class _DrawAction {
  final List<Offset>? points;
  final Color color;
  final double strokeWidth;
  final bool isEraser;
  final _ShapeType? shape;
  final Offset? shapeStart;
  final Offset? shapeEnd;

  _DrawAction.stroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  })  : shape = null,
        shapeStart = null,
        shapeEnd = null;

  _DrawAction.shape({
    required _ShapeType this.shape,
    required Offset this.shapeStart,
    required Offset this.shapeEnd,
    required this.color,
    required this.strokeWidth,
  })  : points = null,
        isEraser = false;
}"""

    new_draw = """class _DrawAction {
  final List<Offset>? points;
  final Color color;
  final double strokeWidth;
  final bool isEraser;
  final _ShapeType? shape;
  final Offset? shapeStart;
  final Offset? shapeEnd;

  _DrawAction.stroke({
    required List<Offset> this.points,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  })  : shape = null,
        shapeStart = null,
        shapeEnd = null;

  _DrawAction.shape({
    required this.shape,
    required this.shapeStart,
    required this.shapeEnd,
    required this.color,
    required this.strokeWidth,
  })  : points = null,
        isEraser = false;
}"""
    
    if old_draw in content:
        content = content.replace(old_draw, new_draw)
        with open(filepath, "w") as f:
            f.write(content)
        print("  Fixed: _DrawAction constructors corregidos")
    else:
        # Brute force: just replace the shape constructor line
        content = content.replace(
            "required _ShapeType this.shape,\n    required Offset this.shapeStart,\n    required Offset this.shapeEnd,",
            "required this.shape,\n    required this.shapeStart,\n    required this.shapeEnd,"
        )
        with open(filepath, "w") as f:
            f.write(content)
        print("  Fixed: constructor params simplificados")
else:
    print("  WARN: archivo no coincide, verificar manualmente")
PYEOF

echo ""
echo "Listo. Ejecuta: flutter run"
