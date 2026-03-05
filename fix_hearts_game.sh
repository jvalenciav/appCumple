#!/bin/bash
# ================================================================
# AGREGAR: Mini juego "Atrapa Corazones"
# Ejecuta desde la raiz de cynthia_app/: bash fix_hearts_game.sh
# ================================================================

echo "Creando mini juego Atrapa Corazones..."

mkdir -p lib/features/hearts_game

cat > lib/features/hearts_game/hearts_game_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class HeartsGameScreen extends StatefulWidget {
  const HeartsGameScreen({super.key});

  @override
  State<HeartsGameScreen> createState() => _HeartsGameScreenState();
}

class _HeartsGameScreenState extends State<HeartsGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _gameLoopController;
  late AnimationController _entranceController;
  late AnimationController _revealController;
  late AnimationController _pulseController;

  final Random _random = Random();
  final List<_FallingHeart> _hearts = [];
  final List<_CaughtEffect> _caughtEffects = [];

  bool _gameStarted = false;
  bool _showingMessage = false;
  int _caughtCount = 0;
  String _currentMessage = '';
  int _messageIndex = 0;

  // Timing
  double _spawnTimer = 0;
  double _spawnInterval = 1.8;
  static const double heartSize = 48;

  // ============================================================
  // VALENCIA: Agrega tus mensajes secretos aqui
  // ============================================================
  final List<String> _secretMessages = [
    'Eres lo mas bonito que me ha pasado.',
    'Me encanta cuando te ries de mis chistes malos.',
    'Tus ojos son mi lugar favorito.',
    'Contigo hasta el silencio es perfecto.',
    'Eres mi persona favorita en todo el universo.',
    'Cada dia te quiero mas que ayer.',
    'Tu voz es lo primero que quiero escuchar cada dia.',
    'Haces que la distancia valga la pena.',
    'Eres mas bonita de lo que crees.',
    'Me haces querer ser mejor persona.',
    'Nuestras llamadas de 6 horas son mi momento favorito del dia.',
    'Tu creatividad me deja sin palabras.',
    'Me encanta como me dices las cosas.',
    'Contigo descubri que el amor es real.',
    'Eres la razon por la que sonrio sin motivo.',
    'Tu calma es mi refugio.',
    'Me muero por abrazarte algun dia.',
    'Eres mi inspiracion para todo lo que hago.',
    'Nunca me canso de hablar contigo.',
    'Eres el mejor plot twist de mi vida.',
    'Gracias por quedarte.',
    'Contigo todo es mejor.',
    'Tu risa cura todo.',
    'Eres mi estrella mas brillante.',
    'Te quiero demasiado, Cynthia.',
  ];

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _gameLoopController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _revealController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _gameLoopController.addListener(_gameLoop);
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _caughtCount = 0;
      _messageIndex = 0;
      _hearts.clear();
      _spawnTimer = 0;
    });
    _gameLoopController.repeat();
  }

  DateTime? _lastFrame;

  void _gameLoop() {
    final now = DateTime.now();
    final dt = _lastFrame != null
        ? (now.difference(_lastFrame!).inMilliseconds / 1000.0).clamp(0.0, 0.1)
        : 0.016;
    _lastFrame = now;

    if (_showingMessage) return;

    setState(() {
      // Spawn nuevos corazones
      _spawnTimer += dt;
      if (_spawnTimer >= _spawnInterval) {
        _spawnTimer = 0;
        _spawnHeart();
        // Aumentar dificultad gradualmente
        _spawnInterval = (_spawnInterval - 0.02).clamp(0.6, 2.0);
      }

      // Mover corazones
      for (final heart in _hearts) {
        heart.y += heart.speed * dt * 100;
        heart.x += sin(heart.wobblePhase + heart.y * 0.02) * 0.5;
        heart.rotation += heart.rotSpeed * dt;
      }

      // Remover corazones que salieron de pantalla
      _hearts.removeWhere((h) => h.y > MediaQuery.of(context).size.height + 50);

      // Actualizar efectos de captura
      for (final e in _caughtEffects) {
        e.progress += dt * 2;
      }
      _caughtEffects.removeWhere((e) => e.progress > 1.0);
    });
  }

  void _spawnHeart() {
    final screenWidth = MediaQuery.of(context).size.width;
    _hearts.add(_FallingHeart(
      x: 30 + _random.nextDouble() * (screenWidth - 60 - heartSize),
      y: -heartSize - _random.nextDouble() * 40,
      speed: 1.2 + _random.nextDouble() * 1.5,
      size: heartSize * (0.7 + _random.nextDouble() * 0.6),
      wobblePhase: _random.nextDouble() * pi * 2,
      rotation: _random.nextDouble() * 0.3 - 0.15,
      rotSpeed: (_random.nextDouble() - 0.5) * 2,
      glowColor: [
        AppColors.roseGold,
        AppColors.softLavender,
        AppColors.shimmerGold,
        const Color(0xFFFF6B8A),
        const Color(0xFFFF85A2),
      ][_random.nextInt(5)],
    ));
  }

  void _onHeartTapped(int index) {
    if (_showingMessage) return;

    final heart = _hearts[index];
    HapticFeedback.mediumImpact();

    // Efecto de captura
    _caughtEffects.add(_CaughtEffect(
      x: heart.x + heart.size / 2,
      y: heart.y + heart.size / 2,
      color: heart.glowColor,
      progress: 0,
    ));

    setState(() {
      _hearts.removeAt(index);
      _caughtCount++;
      _showingMessage = true;
      _currentMessage = _secretMessages[_messageIndex % _secretMessages.length];
      _messageIndex++;
    });

    _revealController.forward(from: 0);
    HapticFeedback.lightImpact();
  }

  void _dismissMessage() {
    setState(() => _showingMessage = false);
  }

  @override
  void dispose() {
    _gameLoopController.dispose();
    _entranceController.dispose();
    _revealController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 80,
        enableShootingStars: true,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _entranceController,
              _gameLoopController,
              _revealController,
              _pulseController,
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

                  // Contador de corazones atrapados
                  if (_gameStarted)
                    Positioned(
                      top: 64,
                      left: 0,
                      right: 0,
                      child: _buildScoreDisplay(),
                    ),

                  // Pantalla de inicio
                  if (!_gameStarted) _buildStartScreen(),

                  // Corazones cayendo
                  if (_gameStarted)
                    ..._hearts.asMap().entries.map((entry) {
                      final i = entry.key;
                      final heart = entry.value;
                      return Positioned(
                        left: heart.x,
                        top: heart.y,
                        child: GestureDetector(
                          onTap: () => _onHeartTapped(i),
                          child: _buildFallingHeart(heart),
                        ),
                      );
                    }),

                  // Efectos de captura
                  ..._caughtEffects.map((e) => Positioned(
                        left: e.x - 30,
                        top: e.y - 30,
                        child: _buildCaughtEffect(e),
                      )),

                  // Mensaje revelado
                  if (_showingMessage) _buildMessageOverlay(),
                ],
              );
            },
          ),
        ),
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
              'Atrapa Corazones',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.starWhite, letterSpacing: 1),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.roseGold.withOpacity(0.1),
          border: Border.all(color: AppColors.roseGold.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, size: 18, color: AppColors.roseGold.withOpacity(0.8)),
            const SizedBox(width: 8),
            Text(
              '$_caughtCount mensajes descubiertos',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.roseGold.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    );
    final pulseScale = 1.0 + _pulseController.value * 0.05;

    return Center(
      child: Opacity(
        opacity: fade.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Corazon grande animado
            Transform.scale(
              scale: pulseScale,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.roseGold.withOpacity(0.1),
                  border: Border.all(color: AppColors.roseGold.withOpacity(0.3), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.roseGold.withOpacity(0.1 + _pulseController.value * 0.1),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  size: 48,
                  color: AppColors.roseGold.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Atrapa Corazones',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.starWhite,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Cada corazon que atrapes\ntiene un mensaje secreto para ti',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: AppColors.paleLavender.withOpacity(0.6),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _startGame,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.roseGold.withOpacity(0.2),
                      AppColors.softLavender.withOpacity(0.15),
                    ],
                  ),
                  border: Border.all(color: AppColors.roseGold.withOpacity(0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.roseGold.withOpacity(0.15),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: AppColors.roseGold, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Jugar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.roseGold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallingHeart(_FallingHeart heart) {
    return Transform.rotate(
      angle: heart.rotation,
      child: Container(
        width: heart.size,
        height: heart.size,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: heart.glowColor.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: CustomPaint(
          size: Size(heart.size, heart.size),
          painter: _HeartShapePainter(color: heart.glowColor, opacity: 0.85),
        ),
      ),
    );
  }

  Widget _buildCaughtEffect(_CaughtEffect effect) {
    final scale = 1.0 + effect.progress * 2;
    final opacity = (1 - effect.progress).clamp(0.0, 1.0);
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: effect.color.withOpacity(opacity * 0.6),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageOverlay() {
    final fade = CurvedAnimation(parent: _revealController, curve: Curves.easeOut);
    final scale = CurvedAnimation(parent: _revealController, curve: Curves.elasticOut);

    return Positioned.fill(
      child: GestureDetector(
        onTap: _dismissMessage,
        child: Container(
          color: Colors.black.withOpacity(0.5 * fade.value),
          child: Center(
            child: Opacity(
              opacity: fade.value,
              child: Transform.scale(
                scale: 0.5 + scale.value * 0.5,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 36),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.roseGold.withOpacity(0.12),
                        AppColors.darkIndigo.withOpacity(0.9),
                        AppColors.softLavender.withOpacity(0.08),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.roseGold.withOpacity(0.35),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.roseGold.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Corazon atrapado
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.roseGold.withOpacity(0.15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.roseGold.withOpacity(0.2),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.roseGold,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Mensaje #$_caughtCount',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.roseGold.withOpacity(0.5),
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Mensaje secreto
                      Text(
                        _currentMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: AppColors.starWhite.withOpacity(0.95),
                          height: 1.6,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Hint para continuar
                      Text(
                        'toca para continuar',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.paleLavender.withOpacity(0.3),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MODELOS Y PAINTERS
// ============================================================

class _FallingHeart {
  double x, y, speed, size, wobblePhase, rotation, rotSpeed;
  Color glowColor;

  _FallingHeart({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.wobblePhase,
    required this.rotation,
    required this.rotSpeed,
    required this.glowColor,
  });
}

class _CaughtEffect {
  double x, y, progress;
  Color color;
  _CaughtEffect({required this.x, required this.y, required this.color, required this.progress});
}

class _HeartShapePainter extends CustomPainter {
  final Color color;
  final double opacity;
  _HeartShapePainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width * 0.45;

    final path = Path();
    path.moveTo(cx, cy + w * 0.7);
    path.cubicTo(cx - w * 1.2, cy - w * 0.1, cx - w * 0.6, cy - w * 1.1, cx, cy - w * 0.4);
    path.cubicTo(cx + w * 0.6, cy - w * 1.1, cx + w * 1.2, cy - w * 0.1, cx, cy + w * 0.7);

    // Glow detras
    final glowPaint = Paint()
      ..color = color.withOpacity(opacity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, glowPaint);

    // Corazon solido
    canvas.drawPath(path, paint);

    // Brillo
    final shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - w * 0.25, cy - w * 0.35), w * 0.15, shinePaint);
  }

  @override
  bool shouldRepaint(covariant _HeartShapePainter old) => false;
}
ENDOFFILE

echo "  Creado: lib/features/hearts_game/hearts_game_screen.dart"

# Agregar import y seccion al home
sed -i '' "s|import '../hug/hug_screen.dart';|import '../hug/hug_screen.dart';\nimport '../hearts_game/hearts_game_screen.dart';|" lib/features/home/home_screen.dart 2>/dev/null || sed -i "s|import '../hug/hug_screen.dart';|import '../hug/hug_screen.dart';\nimport '../hearts_game/hearts_game_screen.dart';|" lib/features/home/home_screen.dart

sed -i '' "s|screen: const HugScreen(),|screen: const HugScreen(),\n    ),\n    _SectionData(\n      title: 'Atrapa Corazones',\n      subtitle: 'Cada uno tiene un secreto',\n      icon: Icons.catching_pokemon,\n      color: Color(0xFFFF6B8A),\n      screen: const HeartsGameScreen(),|" lib/features/home/home_screen.dart 2>/dev/null || sed -i "s|screen: const HugScreen(),|screen: const HugScreen(),\n    ),\n    _SectionData(\n      title: 'Atrapa Corazones',\n      subtitle: 'Cada uno tiene un secreto',\n      icon: Icons.catching_pokemon,\n      color: Color(0xFFFF6B8A),\n      screen: const HeartsGameScreen(),|" lib/features/home/home_screen.dart

echo "  Actualizado: home_screen.dart"
echo ""
echo "Listo. Ejecuta: flutter run"
