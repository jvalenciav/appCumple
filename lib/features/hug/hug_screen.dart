import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class HugScreen extends StatefulWidget {
  const HugScreen({super.key});

  @override
  State<HugScreen> createState() => _HugScreenState();
}

class _HugScreenState extends State<HugScreen> with TickerProviderStateMixin {
  // Posiciones de los personajes
  late Offset _valenciaPos;
  late Offset _cynthiaPos;
  Offset? _draggingOffset;
  bool _isDraggingValencia = false;
  bool _isDraggingCynthia = false;

  // Estado del abrazo
  bool _isHugging = false;
  bool _showMessage = false;
  bool _initialized = false;

  // Animaciones
  late AnimationController _entranceController;
  late AnimationController _hugExplosionController;
  late AnimationController _heartRainController;
  late AnimationController _glowPulseController;
  late AnimationController _messageController;
  late AnimationController _idleFloatController;

  // Particulas
  final List<_Particle> _particles = [];
  final List<_HeartParticle> _hearts = [];
  final Random _random = Random();

  // Distancia para activar abrazo
  static const double hugDistance = 60.0;
  static const double characterSize = 80.0;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _hugExplosionController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _heartRainController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _glowPulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _messageController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _idleFloatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _initPositions(Size size) {
    if (_initialized) return;
    _initialized = true;
    _valenciaPos = Offset(size.width * 0.2 - characterSize / 2, size.height * 0.45);
    _cynthiaPos = Offset(size.width * 0.8 - characterSize / 2, size.height * 0.45);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _hugExplosionController.dispose();
    _heartRainController.dispose();
    _glowPulseController.dispose();
    _messageController.dispose();
    _idleFloatController.dispose();
    super.dispose();
  }

  void _checkHugDistance() {
    final vCenter = _valenciaPos + const Offset(characterSize / 2, characterSize / 2);
    final cCenter = _cynthiaPos + const Offset(characterSize / 2, characterSize / 2);
    final distance = (vCenter - cCenter).distance;

    if (distance < hugDistance && !_isHugging) {
      _triggerHug(vCenter, cCenter);
    }
  }

  void _triggerHug(Offset vCenter, Offset cCenter) {
    setState(() => _isHugging = true);

    // Vibrar
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 200), () => HapticFeedback.mediumImpact());
    Future.delayed(const Duration(milliseconds: 400), () => HapticFeedback.lightImpact());

    // Centrar personajes juntos
    final center = Offset(
      (vCenter.dx + cCenter.dx) / 2,
      (vCenter.dy + cCenter.dy) / 2,
    );

    setState(() {
      _valenciaPos = Offset(center.dx - characterSize - 2, center.dy - characterSize / 2);
      _cynthiaPos = Offset(center.dx + 2, center.dy - characterSize / 2);
    });

    // Generar particulas de explosion
    _generateExplosionParticles(center);
    _generateHearts(center);

    // Ejecutar animaciones
    _hugExplosionController.forward(from: 0);
    _heartRainController.forward(from: 0);
    _glowPulseController.repeat(reverse: true);

    // Mostrar mensaje despues de la explosion
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _showMessage = true);
        _messageController.forward(from: 0);
        HapticFeedback.lightImpact();
      }
    });
  }

  void _generateExplosionParticles(Offset center) {
    _particles.clear();
    for (int i = 0; i < 60; i++) {
      final angle = _random.nextDouble() * pi * 2;
      final speed = 2.0 + _random.nextDouble() * 6.0;
      final size = 2.0 + _random.nextDouble() * 4.0;
      final colors = [
        AppColors.shimmerGold,
        AppColors.roseGold,
        AppColors.softLavender,
        AppColors.starWhite,
        AppColors.electricBlue,
        AppColors.warmGold,
      ];
      _particles.add(_Particle(
        x: center.dx,
        y: center.dy,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        size: size,
        color: colors[_random.nextInt(colors.length)],
        life: 0.5 + _random.nextDouble() * 0.5,
      ));
    }
  }

  void _generateHearts(Offset center) {
    _hearts.clear();
    for (int i = 0; i < 25; i++) {
      _hearts.add(_HeartParticle(
        x: center.dx + (_random.nextDouble() - 0.5) * 200,
        startY: center.dy + _random.nextDouble() * 100,
        speed: 0.5 + _random.nextDouble() * 1.5,
        size: 10.0 + _random.nextDouble() * 18.0,
        wobble: _random.nextDouble() * pi * 2,
        delay: _random.nextDouble() * 0.4,
        opacity: 0.4 + _random.nextDouble() * 0.6,
      ));
    }
  }

  void _resetHug() {
    final size = MediaQuery.of(context).size;
    setState(() {
      _isHugging = false;
      _showMessage = false;
      _particles.clear();
      _hearts.clear();
      _valenciaPos = Offset(size.width * 0.2 - characterSize / 2, size.height * 0.45);
      _cynthiaPos = Offset(size.width * 0.8 - characterSize / 2, size.height * 0.45);
    });
    _hugExplosionController.reset();
    _heartRainController.reset();
    _glowPulseController.stop();
    _glowPulseController.reset();
    _messageController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _initPositions(size);

          return StarfieldBackground(
            starCount: 120,
            enableShootingStars: true,
            child: SafeArea(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _entranceController,
                  _hugExplosionController,
                  _heartRainController,
                  _glowPulseController,
                  _messageController,
                  _idleFloatController,
                ]),
                builder: (context, _) {
                  return Stack(
                    children: [
                      // App bar
                      Positioned(
                        top: 8,
                        left: 16,
                        right: 16,
                        child: _buildAppBar(),
                      ),

                      // Titulo
                      Positioned(
                        top: 70,
                        left: 0,
                        right: 0,
                        child: _buildTitle(),
                      ),

                      // Glow central cuando se abrazan
                      if (_isHugging) _buildCentralGlow(),

                      // Particulas de explosion
                      if (_particles.isNotEmpty)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ParticlePainter(
                              particles: _particles,
                              progress: _hugExplosionController.value,
                            ),
                          ),
                        ),

                      // Corazones flotando
                      if (_hearts.isNotEmpty)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _HeartRainPainter(
                              hearts: _hearts,
                              progress: _heartRainController.value,
                            ),
                          ),
                        ),

                      // Personaje Valencia (draggable)
                      Positioned(
                        left: _valenciaPos.dx,
                        top: _valenciaPos.dy + (_isHugging ? 0 : sin(_idleFloatController.value * pi) * 5),
                        child: _isHugging
                            ? _buildChibiValencia(hugging: true)
                            : GestureDetector(
                                onPanStart: (_) => _isDraggingValencia = true,
                                onPanUpdate: (details) {
                                  if (_isHugging) return;
                                  setState(() {
                                    _valenciaPos += details.delta;
                                  });
                                  _checkHugDistance();
                                },
                                onPanEnd: (_) => _isDraggingValencia = false,
                                child: _buildChibiValencia(hugging: false),
                              ),
                      ),

                      // Personaje Cynthia (draggable)
                      Positioned(
                        left: _cynthiaPos.dx,
                        top: _cynthiaPos.dy + (_isHugging ? 0 : sin((_idleFloatController.value + 0.5) * pi) * 5),
                        child: _isHugging
                            ? _buildChibiCynthia(hugging: true)
                            : GestureDetector(
                                onPanStart: (_) => _isDraggingCynthia = true,
                                onPanUpdate: (details) {
                                  if (_isHugging) return;
                                  setState(() {
                                    _cynthiaPos += details.delta;
                                  });
                                  _checkHugDistance();
                                },
                                onPanEnd: (_) => _isDraggingCynthia = false,
                                child: _buildChibiCynthia(hugging: false),
                              ),
                      ),

                      // Instruccion
                      if (!_isHugging)
                        Positioned(
                          bottom: 80,
                          left: 0,
                          right: 0,
                          child: _buildInstruction(),
                        ),

                      // Mensaje post-abrazo
                      if (_showMessage) _buildHugMessage(),

                      // Boton de repetir
                      if (_isHugging)
                        Positioned(
                          bottom: 40,
                          left: 0,
                          right: 0,
                          child: _buildResetButton(),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    return Opacity(
      opacity: fade.value,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkIndigo.withOpacity(0.5),
                border: Border.all(color: AppColors.roseGold.withOpacity(0.2)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.starWhite),
            ),
          ),
          const Expanded(
            child: Text(
              'Abrazo Virtual',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.starWhite, letterSpacing: 1),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    );
    return Opacity(
      opacity: _isHugging ? 0.0 : fade.value,
      child: Column(
        children: [
          Text(
            '1,051 km de distancia',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.starWhite.withOpacity(0.9),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'pero aqui estamos a un toque de distancia',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AppColors.paleLavender.withOpacity(0.5),
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHIBI VALENCIA - personaje pixel art
  // ============================================================
  Widget _buildChibiValencia({required bool hugging}) {
    return SizedBox(
      width: characterSize,
      height: characterSize + 24,
      child: Column(
        children: [
          Container(
            width: characterSize,
            height: characterSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.electricBlue.withOpacity(0.15),
                  AppColors.darkIndigo.withOpacity(0.6),
                ],
              ),
              border: Border.all(
                color: AppColors.electricBlue.withOpacity(hugging ? 0.5 : 0.25),
                width: hugging ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricBlue.withOpacity(hugging ? 0.3 : 0.1),
                  blurRadius: hugging ? 20 : 10,
                ),
              ],
            ),
            child: CustomPaint(
              painter: _ChibiValenciaPainter(hugging: hugging),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Valencia',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.electricBlue.withOpacity(0.7),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHIBI CYNTHIA - personaje pixel art
  // ============================================================
  Widget _buildChibiCynthia({required bool hugging}) {
    return SizedBox(
      width: characterSize,
      height: characterSize + 24,
      child: Column(
        children: [
          Container(
            width: characterSize,
            height: characterSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.roseGold.withOpacity(0.15),
                  AppColors.darkIndigo.withOpacity(0.6),
                ],
              ),
              border: Border.all(
                color: AppColors.roseGold.withOpacity(hugging ? 0.5 : 0.25),
                width: hugging ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.roseGold.withOpacity(hugging ? 0.3 : 0.1),
                  blurRadius: hugging ? 20 : 10,
                ),
              ],
            ),
            child: CustomPaint(
              painter: _ChibiCynthiaPainter(hugging: hugging),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Cynthia',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.roseGold.withOpacity(0.7),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction() {
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );
    return Opacity(
      opacity: fade.value * 0.6,
      child: Column(
        children: [
          Icon(Icons.touch_app_rounded, size: 24, color: AppColors.paleLavender.withOpacity(0.3)),
          const SizedBox(height: 8),
          Text(
            'Arrastra los personajes\npara juntarlos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.paleLavender.withOpacity(0.4),
              height: 1.5,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralGlow() {
    final vCenter = _valenciaPos + const Offset(characterSize / 2, characterSize / 2);
    final cCenter = _cynthiaPos + const Offset(characterSize / 2, characterSize / 2);
    final center = Offset((vCenter.dx + cCenter.dx) / 2, (vCenter.dy + cCenter.dy) / 2);
    final glowSize = 100.0 + (_hugExplosionController.value * 200);
    final pulseExtra = _glowPulseController.isAnimating ? _glowPulseController.value * 30 : 0.0;

    return Positioned(
      left: center.dx - (glowSize + pulseExtra) / 2,
      top: center.dy - (glowSize + pulseExtra) / 2,
      child: Container(
        width: glowSize + pulseExtra,
        height: glowSize + pulseExtra,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.shimmerGold.withOpacity(0.2 * (1 - _hugExplosionController.value * 0.5)),
              AppColors.roseGold.withOpacity(0.1 * (1 - _hugExplosionController.value * 0.5)),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHugMessage() {
    final fade = CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeOut,
    );
    final scale = CurvedAnimation(
      parent: _messageController,
      curve: Curves.elasticOut,
    );

    return Positioned(
      top: MediaQuery.of(context).size.height * 0.12,
      left: 32,
      right: 32,
      child: Opacity(
        opacity: fade.value,
        child: Transform.scale(
          scale: 0.5 + scale.value * 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.shimmerGold.withOpacity(0.1),
                  AppColors.darkIndigo.withOpacity(0.8),
                  AppColors.roseGold.withOpacity(0.08),
                ],
              ),
              border: Border.all(
                color: AppColors.shimmerGold.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shimmerGold.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [AppColors.shimmerGold, AppColors.roseGold, AppColors.shimmerGold],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Te quiero demasiado',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Aunque hoy nos separen 1,051 km,\nen este momento estamos juntos.\nY algun dia este abrazo sera real.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: AppColors.starWhite.withOpacity(0.8),
                    height: 1.7,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '- Tu buho',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.shimmerGold.withOpacity(0.5),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Center(
      child: GestureDetector(
        onTap: _resetHug,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.darkIndigo.withOpacity(0.5),
            border: Border.all(color: AppColors.paleLavender.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.replay_rounded, size: 16, color: AppColors.paleLavender.withOpacity(0.6)),
              const SizedBox(width: 8),
              Text(
                'Otro abrazo',
                style: TextStyle(fontSize: 13, color: AppColors.paleLavender.withOpacity(0.6), letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CHIBI PAINTERS - Personajes dibujados con CustomPaint
// ============================================================

class _ChibiValenciaPainter extends CustomPainter {
  final bool hugging;
  _ChibiValenciaPainter({required this.hugging});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Cuerpo (hoodie azul)
    final bodyPaint = Paint()..color = const Color(0xFF2962FF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 14), width: 36, height: 30),
        const Radius.circular(8),
      ),
      bodyPaint,
    );

    // Cabeza
    final skinPaint = Paint()..color = const Color(0xFFE8B89D);
    canvas.drawCircle(Offset(cx, cy - 8), 16, skinPaint);

    // Pelo (oscuro)
    final hairPaint = Paint()..color = const Color(0xFF2C1810);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 12), width: 34, height: 28),
      pi, pi, true, hairPaint,
    );
    // Fleco
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 12, cy - 22, 24, 10),
        const Radius.circular(6),
      ),
      hairPaint,
    );

    // Ojos
    final eyePaint = Paint()..color = const Color(0xFF1A1A1A);
    if (hugging) {
      // Ojos cerrados felices (arcos)
      final closedEyePaint = Paint()
        ..color = const Color(0xFF1A1A1A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCenter(center: Offset(cx - 5, cy - 7), width: 6, height: 5), 0, -pi, false, closedEyePaint);
      canvas.drawArc(Rect.fromCenter(center: Offset(cx + 5, cy - 7), width: 6, height: 5), 0, -pi, false, closedEyePaint);
    } else {
      canvas.drawCircle(Offset(cx - 5, cy - 8), 2.5, eyePaint);
      canvas.drawCircle(Offset(cx + 5, cy - 8), 2.5, eyePaint);
      // Brillos
      final shinePaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(cx - 4, cy - 9), 1, shinePaint);
      canvas.drawCircle(Offset(cx + 6, cy - 9), 1, shinePaint);
    }

    // Sonrisa
    final smilePaint = Paint()
      ..color = const Color(0xFFCC6655)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 3), width: hugging ? 10 : 8, height: hugging ? 7 : 5),
      0, pi, false, smilePaint,
    );

    // Brazos
    final armPaint = Paint()
      ..color = const Color(0xFF2962FF)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (hugging) {
      // Brazos extendidos hacia la derecha (hacia Cynthia)
      canvas.drawLine(Offset(cx + 12, cy + 8), Offset(cx + 30, cy + 2), armPaint);
      canvas.drawLine(Offset(cx + 12, cy + 14), Offset(cx + 28, cy + 18), armPaint);
    } else {
      canvas.drawLine(Offset(cx - 14, cy + 8), Offset(cx - 22, cy + 18), armPaint);
      canvas.drawLine(Offset(cx + 14, cy + 8), Offset(cx + 22, cy + 18), armPaint);
    }

    // Piernas
    final legPaint = Paint()
      ..color = const Color(0xFF1A237E)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 6, cy + 28), Offset(cx - 8, cy + 38), legPaint);
    canvas.drawLine(Offset(cx + 6, cy + 28), Offset(cx + 8, cy + 38), legPaint);
  }

  @override
  bool shouldRepaint(covariant _ChibiValenciaPainter old) => old.hugging != hugging;
}

class _ChibiCynthiaPainter extends CustomPainter {
  final bool hugging;
  _ChibiCynthiaPainter({required this.hugging});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Cuerpo (vestido rosa/lavanda)
    final bodyPaint = Paint()..color = const Color(0xFFB388FF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 14), width: 34, height: 32),
        const Radius.circular(10),
      ),
      bodyPaint,
    );
    // Falda triangular
    final skirtPath = Path()
      ..moveTo(cx - 17, cy + 16)
      ..lineTo(cx - 20, cy + 30)
      ..lineTo(cx + 20, cy + 30)
      ..lineTo(cx + 17, cy + 16)
      ..close();
    canvas.drawPath(skirtPath, Paint()..color = const Color(0xFFA070E0));

    // Cabeza
    final skinPaint = Paint()..color = const Color(0xFFF0C4A8);
    canvas.drawCircle(Offset(cx, cy - 8), 16, skinPaint);

    // Pelo cortito
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
    );

    // Ojos
    final eyePaint = Paint()..color = const Color(0xFF2C1810);
    if (hugging) {
      final closedEyePaint = Paint()
        ..color = const Color(0xFF2C1810)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCenter(center: Offset(cx - 5, cy - 7), width: 6, height: 5), 0, -pi, false, closedEyePaint);
      canvas.drawArc(Rect.fromCenter(center: Offset(cx + 5, cy - 7), width: 6, height: 5), 0, -pi, false, closedEyePaint);
      // Rubor
      canvas.drawCircle(Offset(cx - 10, cy - 3), 4, Paint()..color = const Color(0x44FF6B6B));
      canvas.drawCircle(Offset(cx + 10, cy - 3), 4, Paint()..color = const Color(0x44FF6B6B));
    } else {
      canvas.drawCircle(Offset(cx - 5, cy - 8), 2.5, eyePaint);
      canvas.drawCircle(Offset(cx + 5, cy - 8), 2.5, eyePaint);
      final shinePaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(cx - 4, cy - 9), 1, shinePaint);
      canvas.drawCircle(Offset(cx + 6, cy - 9), 1, shinePaint);
    }

    // Sonrisa
    final smilePaint = Paint()
      ..color = const Color(0xFFDD7788)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 3), width: hugging ? 10 : 8, height: hugging ? 7 : 5),
      0, pi, false, smilePaint,
    );

    // Brazos
    final armPaint = Paint()
      ..color = const Color(0xFFF0C4A8)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (hugging) {
      canvas.drawLine(Offset(cx - 12, cy + 8), Offset(cx - 30, cy + 2), armPaint);
      canvas.drawLine(Offset(cx - 12, cy + 14), Offset(cx - 28, cy + 18), armPaint);
    } else {
      canvas.drawLine(Offset(cx - 14, cy + 8), Offset(cx - 22, cy + 18), armPaint);
      canvas.drawLine(Offset(cx + 14, cy + 8), Offset(cx + 22, cy + 18), armPaint);
    }

    // Piernas
    final legPaint = Paint()
      ..color = const Color(0xFFF0C4A8)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 5, cy + 30), Offset(cx - 6, cy + 38), legPaint);
    canvas.drawLine(Offset(cx + 5, cy + 30), Offset(cx + 6, cy + 38), legPaint);
  }

  @override
  bool shouldRepaint(covariant _ChibiCynthiaPainter old) => old.hugging != hugging;
}

// ============================================================
// PARTICLE PAINTERS
// ============================================================

class _Particle {
  final double x, y, vx, vy, size, life;
  final Color color;
  _Particle({required this.x, required this.y, required this.vx, required this.vy, required this.size, required this.color, required this.life});
}

class _HeartParticle {
  final double x, startY, speed, size, wobble, delay, opacity;
  _HeartParticle({required this.x, required this.startY, required this.speed, required this.size, required this.wobble, required this.delay, required this.opacity});
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = progress;
      if (t < (1 - p.life)) continue;
      final particleProgress = (t / p.life).clamp(0.0, 1.0);
      final opacity = (1 - particleProgress).clamp(0.0, 1.0);
      final px = p.x + p.vx * t * 80;
      final py = p.y + p.vy * t * 80 + t * t * 40;
      final paint = Paint()
        ..color = p.color.withOpacity(opacity * 0.8)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * 0.5);
      canvas.drawCircle(Offset(px, py), p.size * (1 - particleProgress * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => true;
}

class _HeartRainPainter extends CustomPainter {
  final List<_HeartParticle> hearts;
  final double progress;
  _HeartRainPainter({required this.hearts, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final h in hearts) {
      final t = (progress - h.delay).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final y = h.startY - t * 300 * h.speed;
      final x = h.x + sin(t * pi * 3 + h.wobble) * 20;
      final opacity = h.opacity * (1 - t).clamp(0.0, 1.0);
      final heartSize = h.size * (0.5 + t * 0.5);
      _drawHeart(canvas, Offset(x, y), heartSize, opacity);
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, double opacity) {
    final paint = Paint()
      ..color = AppColors.roseGold.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size / 2;
    path.moveTo(center.dx, center.dy + w * 0.4);
    path.cubicTo(center.dx - w, center.dy - w * 0.2, center.dx - w * 0.5, center.dy - w, center.dx, center.dy - w * 0.4);
    path.cubicTo(center.dx + w * 0.5, center.dy - w, center.dx + w, center.dy - w * 0.2, center.dx, center.dy + w * 0.4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartRainPainter old) => true;
}
