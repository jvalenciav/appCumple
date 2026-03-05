#!/bin/bash
# ================================================================
# AGREGAR: Lienzo para pintar con compartir por WhatsApp
# Ejecuta desde la raiz de cynthia_app/: bash fix_canvas.sh
# ================================================================

echo "Creando pantalla Lienzo Creativo..."

mkdir -p lib/features/canvas

cat > lib/features/canvas/canvas_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';

// Necesitas agregar en pubspec.yaml:
// dependencies:
//   share_plus: ^7.2.2
//   path_provider: ^2.1.2
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  final GlobalKey _canvasKey = GlobalKey();

  // Herramientas
  _ToolType _currentTool = _ToolType.brush;
  double _brushSize = 4.0;
  Color _currentColor = const Color(0xFF1A1A1A);
  _ShapeType? _currentShape;

  // Historial para undo/redo
  final List<_DrawAction> _actions = [];
  final List<_DrawAction> _redoStack = [];

  // Trazo actual
  List<Offset>? _currentStroke;

  // Forma actual arrastrando
  Offset? _shapeStart;
  Offset? _shapeEnd;

  // Paleta de colores
  final List<Color> _paletteColors = [
    const Color(0xFF1A1A1A), // Negro
    const Color(0xFFFFFFFF), // Blanco
    const Color(0xFFFF4444), // Rojo
    const Color(0xFFFF6B8A), // Rosa
    const Color(0xFFE8B4B8), // Rose gold
    const Color(0xFFB388FF), // Lavanda
    const Color(0xFF7C4DFF), // Morado
    const Color(0xFF2962FF), // Azul
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF00C853), // Verde
    const Color(0xFFFFD54F), // Amarillo
    const Color(0xFFFFC107), // Dorado
    const Color(0xFFFF9800), // Naranja
    const Color(0xFF795548), // Cafe
  ];

  // Grosores
  final List<double> _brushSizes = [2.0, 4.0, 8.0, 14.0, 22.0];
  int _selectedSizeIndex = 1;

  bool _showColorPicker = false;
  bool _showBrushPicker = false;
  bool _showShapePicker = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _undo() {
    if (_actions.isEmpty) return;
    setState(() {
      _redoStack.add(_actions.removeLast());
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      _actions.add(_redoStack.removeLast());
    });
  }

  void _clearAll() {
    if (_actions.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkIndigo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Limpiar lienzo', style: TextStyle(color: AppColors.starWhite)),
        content: Text('Borrar todo el dibujo?',
            style: TextStyle(color: AppColors.paleLavender.withOpacity(0.7))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('No', style: TextStyle(color: AppColors.paleLavender.withOpacity(0.5))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _actions.clear();
                _redoStack.clear();
              });
            },
            child: const Text('Si, borrar', style: TextStyle(color: AppColors.roseGold)),
          ),
        ],
      ),
    );
  }

  Future<void> _shareDrawing() async {
    try {
      RenderRepaintBoundary boundary =
          _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/dibujo_para_valencia.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Mira lo que dibuje en la app que me hiciste',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No se pudo compartir'),
            backgroundColor: AppColors.darkIndigo,
          ),
        );
      }
    }
  }

  void _closeAllPickers() {
    setState(() {
      _showColorPicker = false;
      _showBrushPicker = false;
      _showShapePicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(),

            // Lienzo
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Lienzo principal
                      RepaintBoundary(
                        key: _canvasKey,
                        child: GestureDetector(
                          onPanStart: _onPanStart,
                          onPanUpdate: _onPanUpdate,
                          onPanEnd: _onPanEnd,
                          onTapDown: (details) {
                            _closeAllPickers();
                          },
                          child: CustomPaint(
                            painter: _CanvasPainter(
                              actions: _actions,
                              currentStroke: _currentStroke,
                              currentColor: _currentColor,
                              currentBrushSize: _brushSize,
                              isEraser: _currentTool == _ToolType.eraser,
                              currentShape: _currentShape,
                              shapeStart: _shapeStart,
                              shapeEnd: _shapeEnd,
                            ),
                            size: Size.infinite,
                            child: Container(color: Colors.white),
                          ),
                        ),
                      ),

                      // Pickers flotantes
                      if (_showColorPicker) _buildColorPickerOverlay(),
                      if (_showBrushPicker) _buildBrushPickerOverlay(),
                      if (_showShapePicker) _buildShapePickerOverlay(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Toolbar inferior
            _buildToolbar(),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _closeAllPickers();
    final pos = details.localPosition;

    if (_currentTool == _ToolType.shape && _currentShape != null) {
      setState(() {
        _shapeStart = pos;
        _shapeEnd = pos;
      });
    } else {
      setState(() {
        _currentStroke = [pos];
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final pos = details.localPosition;

    if (_currentTool == _ToolType.shape && _currentShape != null) {
      setState(() {
        _shapeEnd = pos;
      });
    } else {
      setState(() {
        _currentStroke?.add(pos);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentTool == _ToolType.shape && _currentShape != null && _shapeStart != null && _shapeEnd != null) {
      setState(() {
        _actions.add(_DrawAction.shape(
          shape: _currentShape!,
          start: _shapeStart!,
          end: _shapeEnd!,
          color: _currentColor,
          strokeWidth: _brushSize,
        ));
        _redoStack.clear();
        _shapeStart = null;
        _shapeEnd = null;
      });
    } else if (_currentStroke != null && _currentStroke!.isNotEmpty) {
      setState(() {
        _actions.add(_DrawAction.stroke(
          points: List.from(_currentStroke!),
          color: _currentTool == _ToolType.eraser ? Colors.white : _currentColor,
          strokeWidth: _currentTool == _ToolType.eraser ? _brushSize * 3 : _brushSize,
          isEraser: _currentTool == _ToolType.eraser,
        ));
        _redoStack.clear();
        _currentStroke = null;
      });
    }
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkIndigo.withOpacity(0.5),
                border: Border.all(color: AppColors.softLavender.withOpacity(0.2)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.starWhite),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Tu Lienzo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.starWhite, letterSpacing: 1),
            ),
          ),
          // Undo
          _buildTopButton(
            icon: Icons.undo_rounded,
            onTap: _undo,
            enabled: _actions.isNotEmpty,
          ),
          const SizedBox(width: 6),
          // Redo
          _buildTopButton(
            icon: Icons.redo_rounded,
            onTap: _redo,
            enabled: _redoStack.isNotEmpty,
          ),
          const SizedBox(width: 6),
          // Clear
          _buildTopButton(
            icon: Icons.delete_outline_rounded,
            onTap: _clearAll,
            enabled: _actions.isNotEmpty,
            color: AppColors.roseGold,
          ),
          const SizedBox(width: 6),
          // Share
          GestureDetector(
            onTap: _actions.isNotEmpty ? _shareDrawing : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: _actions.isNotEmpty
                    ? LinearGradient(colors: [
                        AppColors.softLavender.withOpacity(0.3),
                        AppColors.electricBlue.withOpacity(0.2),
                      ])
                    : null,
                color: _actions.isEmpty ? AppColors.darkIndigo.withOpacity(0.3) : null,
                border: Border.all(
                  color: _actions.isNotEmpty
                      ? AppColors.softLavender.withOpacity(0.4)
                      : AppColors.paleLavender.withOpacity(0.1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.share_rounded, size: 16,
                      color: _actions.isNotEmpty ? AppColors.starWhite : AppColors.paleLavender.withOpacity(0.3)),
                  const SizedBox(width: 6),
                  Text('Enviar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _actions.isNotEmpty ? AppColors.starWhite : AppColors.paleLavender.withOpacity(0.3),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton({required IconData icon, required VoidCallback onTap, bool enabled = true, Color? color}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.darkIndigo.withOpacity(0.3),
        ),
        child: Icon(icon, size: 18,
            color: enabled ? (color ?? AppColors.starWhite) : AppColors.paleLavender.withOpacity(0.2)),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.darkIndigo.withOpacity(0.8),
        border: Border.all(color: AppColors.softLavender.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pincel
          _buildToolButton(
            icon: Icons.brush_rounded,
            label: 'Pincel',
            isSelected: _currentTool == _ToolType.brush,
            onTap: () {
              _closeAllPickers();
              setState(() {
                _currentTool = _ToolType.brush;
                _currentShape = null;
              });
            },
          ),
          // Borrador
          _buildToolButton(
            icon: Icons.auto_fix_normal_rounded,
            label: 'Borrador',
            isSelected: _currentTool == _ToolType.eraser,
            onTap: () {
              _closeAllPickers();
              setState(() {
                _currentTool = _ToolType.eraser;
                _currentShape = null;
              });
            },
          ),
          // Formas
          _buildToolButton(
            icon: Icons.category_rounded,
            label: 'Formas',
            isSelected: _currentTool == _ToolType.shape,
            onTap: () {
              setState(() {
                _showShapePicker = !_showShapePicker;
                _showColorPicker = false;
                _showBrushPicker = false;
              });
            },
          ),
          // Grosor
          _buildToolButton(
            icon: Icons.line_weight_rounded,
            label: 'Grosor',
            isSelected: false,
            onTap: () {
              setState(() {
                _showBrushPicker = !_showBrushPicker;
                _showColorPicker = false;
                _showShapePicker = false;
              });
            },
          ),
          // Color actual
          GestureDetector(
            onTap: () {
              setState(() {
                _showColorPicker = !_showColorPicker;
                _showBrushPicker = false;
                _showShapePicker = false;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentColor,
                    border: Border.all(color: AppColors.starWhite.withOpacity(0.5), width: 2),
                    boxShadow: [
                      BoxShadow(color: _currentColor.withOpacity(0.3), blurRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Text('Color', style: TextStyle(fontSize: 9, color: AppColors.paleLavender.withOpacity(0.5))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({required IconData icon, required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.softLavender.withOpacity(0.2) : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.softLavender.withOpacity(0.4) : Colors.transparent,
              ),
            ),
            child: Icon(icon, size: 20,
                color: isSelected ? AppColors.softLavender : AppColors.paleLavender.withOpacity(0.5)),
          ),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 9,
              color: isSelected ? AppColors.softLavender : AppColors.paleLavender.withOpacity(0.4))),
        ],
      ),
    );
  }

  Widget _buildColorPickerOverlay() {
    return Positioned(
      bottom: 10,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.darkIndigo.withOpacity(0.95),
          border: Border.all(color: AppColors.softLavender.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15)],
        ),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: _paletteColors.map((color) {
            final isSelected = _currentColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentColor = color;
                  _showColorPicker = false;
                  if (_currentTool == _ToolType.eraser) _currentTool = _ToolType.brush;
                });
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: isSelected ? AppColors.starWhite : (color == Colors.white ? Colors.grey.shade300 : Colors.transparent),
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)] : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBrushPickerOverlay() {
    return Positioned(
      bottom: 10,
      left: 40,
      right: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.darkIndigo.withOpacity(0.95),
          border: Border.all(color: AppColors.softLavender.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _brushSizes.asMap().entries.map((entry) {
            final i = entry.key;
            final size = entry.value;
            final isSelected = _selectedSizeIndex == i;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSizeIndex = i;
                  _brushSize = size;
                  _showBrushPicker = false;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.softLavender.withOpacity(0.15) : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? AppColors.softLavender.withOpacity(0.4) : Colors.transparent,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: size + 4,
                        height: size + 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? _currentColor : AppColors.paleLavender.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildShapePickerOverlay() {
    final shapes = [
      (_ShapeType.circle, Icons.circle_outlined, 'Circulo'),
      (_ShapeType.heart, Icons.favorite_border_rounded, 'Corazon'),
      (_ShapeType.star, Icons.star_border_rounded, 'Estrella'),
      (_ShapeType.rectangle, Icons.crop_square_rounded, 'Cuadro'),
    ];

    return Positioned(
      bottom: 10,
      left: 40,
      right: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.darkIndigo.withOpacity(0.95),
          border: Border.all(color: AppColors.softLavender.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: shapes.map((s) {
            final isSelected = _currentShape == s.$1 && _currentTool == _ToolType.shape;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentTool = _ToolType.shape;
                  _currentShape = s.$1;
                  _showShapePicker = false;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.softLavender.withOpacity(0.2) : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? AppColors.softLavender.withOpacity(0.4) : Colors.transparent,
                      ),
                    ),
                    child: Icon(s.$2, size: 22,
                        color: isSelected ? AppColors.softLavender : AppColors.paleLavender.withOpacity(0.5)),
                  ),
                  const SizedBox(height: 4),
                  Text(s.$3, style: TextStyle(fontSize: 9,
                      color: isSelected ? AppColors.softLavender : AppColors.paleLavender.withOpacity(0.4))),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ============================================================
// MODELOS DE DATOS
// ============================================================

enum _ToolType { brush, eraser, shape }
enum _ShapeType { circle, heart, star, rectangle }

class _DrawAction {
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
}

// ============================================================
// CANVAS PAINTER
// ============================================================

class _CanvasPainter extends CustomPainter {
  final List<_DrawAction> actions;
  final List<Offset>? currentStroke;
  final Color currentColor;
  final double currentBrushSize;
  final bool isEraser;
  final _ShapeType? currentShape;
  final Offset? shapeStart;
  final Offset? shapeEnd;

  _CanvasPainter({
    required this.actions,
    this.currentStroke,
    required this.currentColor,
    required this.currentBrushSize,
    required this.isEraser,
    this.currentShape,
    this.shapeStart,
    this.shapeEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dibujar todas las acciones guardadas
    for (final action in actions) {
      if (action.shape != null) {
        _drawShape(canvas, action.shape!, action.shapeStart!, action.shapeEnd!, action.color, action.strokeWidth);
      } else if (action.points != null && action.points!.length > 1) {
        _drawStroke(canvas, action.points!, action.color, action.strokeWidth);
      }
    }

    // Dibujar trazo actual
    if (currentStroke != null && currentStroke!.isNotEmpty) {
      final color = isEraser ? Colors.white : currentColor;
      final size = isEraser ? currentBrushSize * 3 : currentBrushSize;
      _drawStroke(canvas, currentStroke!, color, size);
    }

    // Dibujar forma actual
    if (currentShape != null && shapeStart != null && shapeEnd != null) {
      _drawShape(canvas, currentShape!, shapeStart!, shapeEnd!, currentColor, currentBrushSize);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> points, Color color, double width) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (points.length == 1) {
      canvas.drawCircle(points.first, width / 2, Paint()..color = color);
      return;
    }

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawShape(Canvas canvas, _ShapeType shape, Offset start, Offset end, Color color, double width) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromPoints(start, end);
    final center = rect.center;
    final radius = (end - start).distance / 2;

    switch (shape) {
      case _ShapeType.circle:
        canvas.drawOval(rect, paint);
        break;
      case _ShapeType.rectangle:
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);
        break;
      case _ShapeType.heart:
        _drawHeart(canvas, center, radius, paint);
        break;
      case _ShapeType.star:
        _drawStar(canvas, center, radius, paint);
        break;
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final w = size;
    final path = Path();
    path.moveTo(center.dx, center.dy + w * 0.7);
    path.cubicTo(center.dx - w * 1.2, center.dy - w * 0.1, center.dx - w * 0.6, center.dy - w * 1.1, center.dx, center.dy - w * 0.4);
    path.cubicTo(center.dx + w * 0.6, center.dy - w * 1.1, center.dx + w * 1.2, center.dy - w * 0.1, center.dx, center.dy + w * 0.7);
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = -pi / 2 + (i * 2 * pi / 5);
      final innerAngle = outerAngle + pi / 5;
      final outerPoint = Offset(center.dx + cos(outerAngle) * size, center.dy + sin(outerAngle) * size);
      final innerPoint = Offset(center.dx + cos(innerAngle) * size * 0.4, center.dy + sin(innerAngle) * size * 0.4);
      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CanvasPainter old) => true;
}
ENDOFFILE

echo "  Creado: lib/features/canvas/canvas_screen.dart"

# Agregar import y seccion al home
sed -i '' "s|import '../hearts_game/hearts_game_screen.dart';|import '../hearts_game/hearts_game_screen.dart';\nimport '../canvas/canvas_screen.dart';|" lib/features/home/home_screen.dart 2>/dev/null || sed -i "s|import '../hearts_game/hearts_game_screen.dart';|import '../hearts_game/hearts_game_screen.dart';\nimport '../canvas/canvas_screen.dart';|" lib/features/home/home_screen.dart

sed -i '' "s|screen: const HeartsGameScreen(),|screen: const HeartsGameScreen(),\n    ),\n    _SectionData(\n      title: 'Tu Lienzo',\n      subtitle: 'Dibuja lo que sientas',\n      icon: Icons.palette_rounded,\n      color: AppColors.softLavender,\n      screen: const CanvasScreen(),|" lib/features/home/home_screen.dart 2>/dev/null || sed -i "s|screen: const HeartsGameScreen(),|screen: const HeartsGameScreen(),\n    ),\n    _SectionData(\n      title: 'Tu Lienzo',\n      subtitle: 'Dibuja lo que sientas',\n      icon: Icons.palette_rounded,\n      color: AppColors.softLavender,\n      screen: const CanvasScreen(),|" lib/features/home/home_screen.dart

echo "  Actualizado: home_screen.dart"
echo ""
echo "IMPORTANTE: Agrega estas dependencias a tu pubspec.yaml:"
echo "  dependencies:"
echo "    share_plus: ^7.2.2"
echo "    path_provider: ^2.1.2"
echo ""
echo "Luego ejecuta: flutter pub get"
echo "Y despues: flutter run"
