#!/bin/bash
# ================================================================
# 🌊 SCRIPT COMPLETO — App de Cumpleaños para Cynthia
# ================================================================
# Pega esto en la terminal de VS Code
# Asegúrate de estar en la raíz de tu proyecto: cynthia_app/
# ================================================================

echo "🚀 Creando toda la estructura del proyecto..."
echo ""

# === CREAR CARPETAS ===
mkdir -p lib/core/theme
mkdir -p lib/shared/widgets
mkdir -p lib/features/splash
mkdir -p lib/features/home
mkdir -p lib/features/book
mkdir -p lib/features/map
mkdir -p lib/features/reasons
mkdir -p lib/features/poems
mkdir -p lib/features/timeline
mkdir -p lib/features/quotes

echo "📁 Carpetas creadas"


# === main.dart ===
cat > lib/main.dart << 'ENDOFFILE'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CynthiaApp());
}

class CynthiaApp extends StatelessWidget {
  const CynthiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Para Cynthia ✨',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

ENDOFFILE
echo "  ✅ lib/main.dart"

# === app_colors.dart ===
cat > lib/core/theme/app_colors.dart << 'ENDOFFILE'
import 'package:flutter/material.dart';

/// Paleta de colores de Cynthia
/// Basada en sus colores favoritos + complementos armoniosos
class AppColors {
  AppColors._();

  // === COLORES FAVORITOS DE CYNTHIA ===
  static const Color black = Color(0xFF000000);
  static const Color midnightBlue = Color(0xFF072138);
  static const Color deepRoyal = Color(0xFF050E66);
  static const Color darkIndigo = Color(0xFF0C1148);
  static const Color cobalt = Color(0xFF00097F);

  // === COMPLEMENTOS ARMONIOSOS ===
  static const Color navyDeep = Color(0xFF1A237E);
  static const Color oceanBlue = Color(0xFF0D47A1);
  static const Color electricBlue = Color(0xFF2962FF);
  static const Color softLavender = Color(0xFFB388FF);
  static const Color paleLavender = Color(0xFFD1C4E9);
  static const Color shimmerGold = Color(0xFFFFD54F);
  static const Color warmGold = Color(0xFFFFC107);
  static const Color roseGold = Color(0xFFE8B4B8);
  static const Color starWhite = Color(0xFFE0E0FF);
  static const Color ghostWhite = Color(0xFFF0F0FF);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // === GRADIENTES PRINCIPALES ===
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [black, darkIndigo, midnightBlue],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cosmicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepRoyal, cobalt, navyDeep],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [softLavender, electricBlue],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [shimmerGold, warmGold],
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [
      Color(0x33B388FF),
      Color(0x11B388FF),
      Colors.transparent,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // === SOMBRAS ===
  static List<BoxShadow> glowShadow({Color? color, double blur = 20}) {
    return [
      BoxShadow(
        color: (color ?? softLavender).withOpacity(0.3),
        blurRadius: blur,
        spreadRadius: 2,
      ),
    ];
  }

  static List<BoxShadow> subtleGlow({Color? color}) {
    return [
      BoxShadow(
        color: (color ?? softLavender).withOpacity(0.15),
        blurRadius: 10,
        spreadRadius: 1,
      ),
    ];
  }
}

ENDOFFILE
echo "  ✅ lib/core/theme/app_colors.dart"

# === app_theme.dart ===
cat > lib/core/theme/app_theme.dart << 'ENDOFFILE'
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      primaryColor: AppColors.cobalt,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.cobalt,
        secondary: AppColors.softLavender,
        surface: AppColors.darkIndigo,
        onPrimary: AppColors.starWhite,
        onSecondary: AppColors.black,
        onSurface: AppColors.starWhite,
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.starWhite,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.starWhite,
          letterSpacing: -0.3,
          height: 1.3,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.starWhite,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.starWhite,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.starWhite,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.starWhite,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: AppColors.paleLavender,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.shimmerGold,
          letterSpacing: 1.2,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.starWhite,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.starWhite),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.softLavender,
        size: 24,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

ENDOFFILE
echo "  ✅ lib/core/theme/app_theme.dart"

# === starfield_background.dart ===
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

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
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
    // Pintar estrellas
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

      // Brillo extra para estrellas grandes
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

    // Pintar estrella fugaz
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

    // Punto brillante en la cabeza
    final headPaint = Paint()
      ..color = AppColors.pureWhite.withOpacity(opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(currentX, currentY), 2, headPaint);
  }

  @override
  bool shouldRepaint(StarfieldPainter oldDelegate) => true;
}

ENDOFFILE
echo "  ✅ lib/shared/widgets/starfield_background.dart"

# === splash_screen.dart ===
cat > lib/features/splash/splash_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _particleController;

  late Animation<double> _fadeIn;
  late Animation<double> _nameScale;
  late Animation<double> _subtitleFade;
  late Animation<double> _heartScale;
  late Animation<double> _glowExpand;
  late Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 5500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Secuencia de animaciones
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    _nameScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.15, 0.4, curve: Curves.elasticOut),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.5, curve: Curves.easeOut),
      ),
    );

    _heartScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.45, 0.65, curve: Curves.elasticOut),
      ),
    );

    _glowExpand = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.75, curve: Curves.easeOut),
      ),
    );

    _exitFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
      ),
    );

    _mainController.forward().then((_) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 200,
        enableShootingStars: true,
        child: AnimatedBuilder(
          listenable: Listenable.merge([
            _mainController,
            _pulseController,
            _particleController,
          ]),
          builder: (context, _) {
            return Opacity(
              opacity: _exitFade.value,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Corazón con glow
                    _buildHeart(),
                    const SizedBox(height: 30),
                    // Nombre "Cynthia"
                    _buildName(),
                    const SizedBox(height: 12),
                    // Subtítulo
                    _buildSubtitle(),
                    const SizedBox(height: 50),
                    // Indicador de carga
                    _buildLoader(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeart() {
    final pulseScale = 1.0 + _pulseController.value * 0.08;
    return Opacity(
      opacity: _heartScale.value.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: _heartScale.value * pulseScale,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.softLavender.withOpacity(0.4 * _glowExpand.value),
                blurRadius: 30 + 20 * _glowExpand.value,
                spreadRadius: 5 * _glowExpand.value,
              ),
              BoxShadow(
                color: AppColors.shimmerGold.withOpacity(0.2 * _glowExpand.value),
                blurRadius: 50 * _glowExpand.value,
                spreadRadius: 10 * _glowExpand.value,
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite,
            size: 50,
            color: AppColors.roseGold,
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return Opacity(
      opacity: _fadeIn.value,
      child: Transform.scale(
        scale: _nameScale.value,
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                AppColors.starWhite,
                AppColors.softLavender,
                AppColors.shimmerGold,
                AppColors.softLavender,
                AppColors.starWhite,
              ],
              stops: [
                0.0,
                0.25 + _pulseController.value * 0.1,
                0.5,
                0.75 - _pulseController.value * 0.1,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: const Text(
            'Cynthia',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 3,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Opacity(
      opacity: _subtitleFade.value,
      child: Text(
        'Este universo es para ti ✨',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: AppColors.paleLavender.withOpacity(0.8),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Opacity(
      opacity: _subtitleFade.value,
      child: SizedBox(
        width: 120,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _mainController.value,
            backgroundColor: AppColors.darkIndigo.withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
              Color.lerp(
                AppColors.softLavender,
                AppColors.shimmerGold,
                _mainController.value,
              )!,
            ),
            minHeight: 3,
          ),
        ),
      ),
    );
  }
}

ENDOFFILE
echo "  ✅ lib/features/splash/splash_screen.dart"

# === home_screen.dart ===
cat > lib/features/home/home_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';
import '../book/book_screen.dart';
import '../reasons/reasons_screen.dart';
import '../poems/poems_screen.dart';
import '../timeline/timeline_screen.dart';
import '../map/map_screen.dart';
import '../quotes/quotes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _floatController;
  late AnimationController _glowController;

  final List<_SectionData> _sections = [
    _SectionData(
      title: 'Nuestro Libro',
      subtitle: 'Una historia página a página',
      icon: Icons.auto_stories_rounded,
      color: AppColors.softLavender,
      screen: const BookScreen(),
    ),
    _SectionData(
      title: 'Mapa Estelar',
      subtitle: 'Explora nuestro universo',
      icon: Icons.explore_rounded,
      color: AppColors.electricBlue,
      screen: const MapScreen(),
    ),
    _SectionData(
      title: '100 Razones',
      subtitle: 'Por las que te amo',
      icon: Icons.favorite_rounded,
      color: AppColors.roseGold,
      screen: const ReasonsScreen(),
    ),
    _SectionData(
      title: 'Poemas',
      subtitle: 'Código que habla de ti',
      icon: Icons.code_rounded,
      color: AppColors.shimmerGold,
      screen: const PoemsScreen(),
    ),
    _SectionData(
      title: 'Nuestra Línea',
      subtitle: 'El tiempo junto a ti',
      icon: Icons.timeline_rounded,
      color: AppColors.paleLavender,
      screen: const TimelineScreen(),
    ),
    _SectionData(
      title: 'Frases',
      subtitle: 'Palabras que nos definen',
      icon: Icons.format_quote_rounded,
      color: AppColors.warmGold,
      screen: const QuotesScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 120,
        enableShootingStars: true,
        child: SafeArea(
          child: AnimatedBuilder(
            listenable: Listenable.merge([
              _entranceController,
              _floatController,
              _glowController,
            ]),
            builder: (context, _) {
              return Column(
                children: [
                  const SizedBox(height: 30),
                  _buildHeader(),
                  const SizedBox(height: 10),
                  _buildSubheader(),
                  const SizedBox(height: 35),
                  Expanded(child: _buildGrid()),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final fadeIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: fadeIn.value,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - fadeIn.value)),
        child: ShaderMask(
          shaderCallback: (bounds) {
            final shift = _glowController.value;
            return LinearGradient(
              colors: const [
                AppColors.starWhite,
                AppColors.softLavender,
                AppColors.shimmerGold,
                AppColors.softLavender,
                AppColors.starWhite,
              ],
              stops: [
                0.0,
                0.2 + shift * 0.1,
                0.5,
                0.8 - shift * 0.1,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: const Text(
            '✦ Para Cynthia ✦',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubheader() {
    final fadeIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: fadeIn.value,
      child: Text(
        'Elige un rincón de nuestro universo',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: AppColors.paleLavender.withOpacity(0.7),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 0.85,
        ),
        itemCount: _sections.length,
        itemBuilder: (context, index) {
          return _buildSectionCard(index);
        },
      ),
    );
  }

  Widget _buildSectionCard(int index) {
    final section = _sections[index];
    final delay = 0.15 + (index * 0.08);
    final end = (delay + 0.3).clamp(0.0, 1.0);

    final fadeIn = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(delay, end, curve: Curves.easeOut),
    );

    final floatOffset = sin((_floatController.value + index * 0.3) * pi) * 4;
    final glowIntensity = 0.1 + _glowController.value * 0.15;

    return Opacity(
      opacity: fadeIn.value,
      child: Transform.translate(
        offset: Offset(0, 30 * (1 - fadeIn.value) + floatOffset),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => section.screen,
                transitionDuration: const Duration(milliseconds: 600),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      )),
                      child: child,
                    ),
                  );
                },
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  section.color.withOpacity(0.12),
                  AppColors.darkIndigo.withOpacity(0.6),
                  AppColors.midnightBlue.withOpacity(0.4),
                ],
              ),
              border: Border.all(
                color: section.color.withOpacity(0.2 + glowIntensity),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: section.color.withOpacity(glowIntensity),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícono con glow
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: section.color.withOpacity(0.1),
                      border: Border.all(
                        color: section.color.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: section.color.withOpacity(glowIntensity * 0.5),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Icon(
                      section.icon,
                      color: section.color,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Título
                  Text(
                    section.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.starWhite,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtítulo
                  Text(
                    section.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: section.color.withOpacity(0.7),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  const _SectionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

ENDOFFILE
echo "  ✅ lib/features/home/home_screen.dart"

# === book_screen.dart ===
cat > lib/features/book/book_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _entranceController;
  late AnimationController _particleController;
  int _currentPage = 0;

  // ============================================================
  // VALENCIA: Personaliza cada página con tu contenido real
  // Cada BookPageData tiene: título, contenido, ícono y color
  // ============================================================
  final List<BookPageData> _pages = [
    BookPageData(
      title: 'Capítulo 1',
      heading: 'El Primer Hola',
      content:
          'Hubo un momento exacto en el que todo cambió. Un mensaje, una notificación, '
          'y de pronto el universo se reordenó para que nuestros caminos se cruzaran.\n\n'
          'No fue casualidad. Fue el código del destino ejecutándose a la perfección.',
      icon: Icons.chat_bubble_rounded,
      accentColor: AppColors.softLavender,
    ),
    BookPageData(
      title: 'Capítulo 2',
      heading: 'Las 2 AM',
      content:
          'Las noches dejaron de ser oscuras cuando empezamos a hablar hasta que el sol '
          'salía. Cada llamada de 6 horas era un universo entero comprimido en ondas de sonido.\n\n'
          'Tu voz se convirtió en mi canción favorita. La que nunca quiero que termine.',
      icon: Icons.nightlight_round,
      accentColor: AppColors.electricBlue,
    ),
    BookPageData(
      title: 'Capítulo 3',
      heading: 'La Distancia',
      content:
          '1,051 kilómetros. Un número que a cualquiera le parecería imposible, '
          'pero para nosotros es solo el espacio entre dos corazones que laten sincronizados.\n\n'
          'La distancia no nos separa. Nos da razones para amarnos con más fuerza.',
      icon: Icons.location_on_rounded,
      accentColor: AppColors.shimmerGold,
    ),
    BookPageData(
      title: 'Capítulo 4',
      heading: 'Tu Risa',
      content:
          'Si pudiera compilar un programa que reprodujera tu risa en loop infinito, '
          'sería el código más valioso jamás escrito.\n\n'
          'Tu risa es el sonido que le da sentido a todo. Es la prueba de que la felicidad tiene frecuencia.',
      icon: Icons.emoji_emotions_rounded,
      accentColor: AppColors.roseGold,
    ),
    BookPageData(
      title: 'Capítulo 5',
      heading: 'Gaming Nights',
      content:
          'Nuestras noches de gaming no son solo partidas — son rituales sagrados. '
          'Cada victoria juntos, cada derrota ridícula, cada momento donde nos reímos hasta no poder más.\n\n'
          'Tú eres mi jugadora favorita. En todos los juegos. En todos los niveles.',
      icon: Icons.sports_esports_rounded,
      accentColor: AppColors.electricBlue,
    ),
    BookPageData(
      title: 'Capítulo 6',
      heading: 'El Búho y la Ballena',
      content:
          'Yo soy el búho que observa desde lo alto, buscando luz en la oscuridad. '
          'Tú eres la ballena: inmensa, profunda, majestuosa.\n\n'
          'Uno vuela, la otra nada. Pero ambos comparten el mismo cielo y el mismo océano.',
      icon: Icons.water_rounded,
      accentColor: AppColors.softLavender,
    ),
    BookPageData(
      title: 'Capítulo 7',
      heading: 'Tu Arte',
      content:
          'Eres estudiante de diseño y cada trazo que haces es una extensión de tu alma. '
          'Yo escribo código, tú creas mundos visuales.\n\n'
          'Juntos somos el proyecto más hermoso: función y forma en perfecta armonía.',
      icon: Icons.palette_rounded,
      accentColor: AppColors.warmGold,
    ),
    BookPageData(
      title: 'Capítulo 8',
      heading: 'Los Silencios',
      content:
          'A veces no necesitamos palabras. Solo estar ahí, en silencio, '
          'conectados a una llamada donde el silencio dice más que cualquier frase.\n\n'
          'Contigo aprendí que la calma también es un lenguaje de amor.',
      icon: Icons.volume_off_rounded,
      accentColor: AppColors.paleLavender,
    ),
    BookPageData(
      title: 'Capítulo 9',
      heading: 'Promesas',
      content:
          'Te prometo que cada línea de código que escriba tendrá un pedazo de ti. '
          'Que cada noche será nuestra. Que la distancia será solo un número.\n\n'
          'Te prometo que este búho siempre volará hacia donde estés.',
      icon: Icons.handshake_rounded,
      accentColor: AppColors.shimmerGold,
    ),
    BookPageData(
      title: 'Capítulo 10',
      heading: 'El Futuro',
      content:
          'Un día los 1,051 km serán cero. Un día despertaré viéndote a los ojos en persona, '
          'no a través de una pantalla.\n\n'
          'Y cuando llegue ese día, te abrazaré tan fuerte que el universo entero lo va a sentir.',
      icon: Icons.auto_awesome_rounded,
      accentColor: AppColors.roseGold,
    ),
    BookPageData(
      title: 'Capítulo ∞',
      heading: 'Sin Final',
      content:
          'Esta historia no tiene último capítulo. Porque cada día contigo es una página nueva.\n\n'
          'Feliz cumpleaños, Cynthia.\n\n'
          'Con todo mi código, mi alma y mi corazón:\n'
          'Te amo infinitamente. 🦉❤️🐋',
      icon: Icons.all_inclusive_rounded,
      accentColor: AppColors.shimmerGold,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _particleController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 80,
        child: SafeArea(
          child: AnimatedBuilder(
            listenable: _entranceController,
            builder: (context, _) {
              return Column(
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 10),
                  _buildPageIndicator(),
                  const SizedBox(height: 10),
                  Expanded(child: _buildPageView()),
                  const SizedBox(height: 20),
                  _buildSwipeHint(),
                  const SizedBox(height: 20),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkIndigo.withOpacity(0.5),
                  border: Border.all(
                    color: AppColors.softLavender.withOpacity(0.2),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.starWhite,
                ),
              ),
            ),
            const Expanded(
              child: Text(
                'Nuestro Libro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.starWhite,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(width: 42),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? _pages[_currentPage].accentColor
                : AppColors.starWhite.withOpacity(0.2),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _pages[_currentPage].accentColor.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildPageView() {
    final slideIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: slideIn.value,
      child: Transform.translate(
        offset: Offset(0, 50 * (1 - slideIn.value)),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (page) => setState(() => _currentPage = page),
          physics: const BouncingScrollPhysics(),
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            return _buildPage(index);
          },
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    final page = _pages[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              page.accentColor.withOpacity(0.08),
              AppColors.darkIndigo.withOpacity(0.7),
              AppColors.midnightBlue.withOpacity(0.5),
            ],
          ),
          border: Border.all(
            color: page.accentColor.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: page.accentColor.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Número de capítulo
              Text(
                page.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: page.accentColor.withOpacity(0.6),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 16),
              // Ícono
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: page.accentColor.withOpacity(0.1),
                  border: Border.all(
                    color: page.accentColor.withOpacity(0.25),
                  ),
                ),
                child: Icon(
                  page.icon,
                  color: page.accentColor,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              // Heading
              Text(
                page.heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.starWhite,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              // Línea decorativa
              Container(
                width: 40,
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      page.accentColor,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    page.content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: AppColors.starWhite.withOpacity(0.85),
                      height: 1.7,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              // Número de página
              const SizedBox(height: 10),
              Text(
                '${index + 1} / ${_pages.length}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: AppColors.paleLavender.withOpacity(0.4),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeHint() {
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: fade.value * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swipe_rounded,
            size: 16,
            color: AppColors.paleLavender.withOpacity(0.5),
          ),
          const SizedBox(width: 6),
          Text(
            'Desliza para leer',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.paleLavender.withOpacity(0.5),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class BookPageData {
  final String title;
  final String heading;
  final String content;
  final IconData icon;
  final Color accentColor;

  const BookPageData({
    required this.title,
    required this.heading,
    required this.content,
    required this.icon,
    required this.accentColor,
  });
}

ENDOFFILE
echo "  ✅ lib/features/book/book_screen.dart"

# === map_screen.dart ===
cat > lib/features/map/map_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _orbitController;
  int? _selectedZone;

  // ============================================================
  // VALENCIA: Personaliza las zonas con contenido real
  // ============================================================
  final List<ZoneData> _zones = [
    ZoneData(
      name: 'Nebulosa del Amor',
      description: 'Donde nació todo. El espacio donde nuestros caminos convergieron y el amor tomó forma.',
      icon: Icons.favorite_rounded,
      color: AppColors.roseGold,
      detail: 'Aquí vive la esencia de lo que somos. Cada mensaje, cada llamada, cada "te amo" flotan en esta nebulosa como partículas de luz infinita.',
    ),
    ZoneData(
      name: 'Constelación de Risas',
      description: 'Nuestros mejores momentos de felicidad pura, conectados como estrellas.',
      icon: Icons.emoji_emotions_rounded,
      color: AppColors.shimmerGold,
      detail: 'Las noches de gaming, los chistes malos, las risas hasta las 3 AM. Cada estrella en esta constelación es un momento donde fuimos absolutamente felices.',
    ),
    ZoneData(
      name: 'Océano Profundo',
      description: 'La profundidad de nuestra conexión. Donde nadan las ballenas y vuelan los búhos.',
      icon: Icons.water_rounded,
      color: AppColors.electricBlue,
      detail: 'Aquí habita la ballena — tú, inmensa y majestuosa. Y sobre este océano vuela el búho — yo, buscándote siempre. Dos mundos que se encontraron en el horizonte.',
    ),
    ZoneData(
      name: 'Galaxia Creativa',
      description: 'Tu arte + mi código. La galaxia donde diseño y programación se fusionan.',
      icon: Icons.palette_rounded,
      color: AppColors.softLavender,
      detail: 'Tú creas mundos con trazos, yo los construyo con líneas de código. Juntos somos una galaxia donde lo visual y lo funcional danzan en perfecta armonía.',
    ),
    ZoneData(
      name: 'Puente de Estrellas',
      description: 'Los 1,051 km que nos separan, iluminados por estrellas.',
      icon: Icons.flight_rounded,
      color: AppColors.paleLavender,
      detail: 'Cada estrella en este puente es una noche que pasamos hablando, un "buenas noches" con ganas de "buenos días". La distancia no nos divide — nos conecta a través de la luz.',
    ),
    ZoneData(
      name: 'Supernova del Futuro',
      description: 'Todo lo que viene. Brillante, explosivo e infinitamente hermoso.',
      icon: Icons.auto_awesome_rounded,
      color: AppColors.warmGold,
      detail: 'El día que cierro los ojos y me imagino el futuro, te veo a ti. Una supernova de posibilidades, de abrazos pendientes, de una vida construida juntos. Esto apenas empieza.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _orbitController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 100,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 10),
              Expanded(
                child: _selectedZone != null
                    ? _buildZoneDetail()
                    : _buildZoneGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_selectedZone != null) {
                setState(() => _selectedZone = null);
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkIndigo.withOpacity(0.5),
                border: Border.all(
                  color: AppColors.electricBlue.withOpacity(0.2),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.starWhite,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _selectedZone != null
                  ? _zones[_selectedZone!].name
                  : 'Mapa Estelar',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.starWhite,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildZoneGrid() {
    return AnimatedBuilder(
      listenable: Listenable.merge([_entranceController, _orbitController]),
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                'Toca una zona para explorarla',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.paleLavender.withOpacity(0.5),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _zones.length,
                  itemBuilder: (context, index) => _buildZoneTile(index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildZoneTile(int index) {
    final zone = _zones[index];
    final delay = (index * 0.1).clamp(0.0, 0.5);
    final end = (delay + 0.4).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(delay, end, curve: Curves.easeOut),
    );

    final float = sin((_orbitController.value * 2 * pi) + index * 1.0) * 3;

    return Opacity(
      opacity: animation.value,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - animation.value) + float),
        child: GestureDetector(
          onTap: () => setState(() => _selectedZone = index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  zone.color.withOpacity(0.12),
                  AppColors.darkIndigo.withOpacity(0.6),
                ],
              ),
              border: Border.all(
                color: zone.color.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: zone.color.withOpacity(0.1),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: zone.color.withOpacity(0.1),
                      border: Border.all(
                        color: zone.color.withOpacity(0.3),
                      ),
                    ),
                    child: Icon(zone.icon, color: zone.color, size: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    zone.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.starWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    zone.description,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: zone.color.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZoneDetail() {
    final zone = _zones[_selectedZone!];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        key: ValueKey(_selectedZone),
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                zone.color.withOpacity(0.1),
                AppColors.darkIndigo.withOpacity(0.7),
                AppColors.midnightBlue.withOpacity(0.5),
              ],
            ),
            border: Border.all(
              color: zone.color.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: zone.color.withOpacity(0.1),
                blurRadius: 25,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: zone.color.withOpacity(0.1),
                    border: Border.all(
                      color: zone.color.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: zone.color.withOpacity(0.2),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Icon(zone.icon, color: zone.color, size: 36),
                ),
                const SizedBox(height: 24),
                Text(
                  zone.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.starWhite,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 2,
                  color: zone.color.withOpacity(0.4),
                ),
                const SizedBox(height: 24),
                Text(
                  zone.detail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: AppColors.starWhite.withOpacity(0.85),
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ZoneData {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String detail;

  const ZoneData({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.detail,
  });
}

ENDOFFILE
echo "  ✅ lib/features/map/map_screen.dart"

# === reasons_screen.dart ===
cat > lib/features/reasons/reasons_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class ReasonsScreen extends StatefulWidget {
  const ReasonsScreen({super.key});

  @override
  State<ReasonsScreen> createState() => _ReasonsScreenState();
}

class _ReasonsScreenState extends State<ReasonsScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _cardFlipController;
  late AnimationController _heartController;
  bool _isRevealed = false;
  int _currentIndex = 0;

  // ============================================================
  // VALENCIA: Reemplaza estas con tus 100 razones reales
  // ============================================================
  final List<String> _reasons = [
    'Porque tu risa es el mejor sonido que existe en este universo.',
    'Porque conviertes mis peores días en los mejores con una sola palabra.',
    'Porque a las 2 AM contigo se siente como si el tiempo no existiera.',
    'Porque eres la persona más fuerte que conozco, aunque no siempre lo veas.',
    'Porque tus diseños son extensiones de un alma increíblemente hermosa.',
    'Porque me haces querer ser mejor programador, mejor persona, mejor todo.',
    'Porque 1,051 km no son nada cuando tu voz está a una llamada de distancia.',
    'Porque nuestras noches de gaming son mi definición de felicidad pura.',
    'Porque me enseñaste que la vulnerabilidad es la mayor forma de valentía.',
    'Porque cada vez que dices mi nombre, el mundo se detiene un segundo.',
    'Porque tu calma es el antídoto perfecto para mi caos interno.',
    'Porque incluso en silencio, contigo todo tiene sentido.',
    'Porque me miras como si fuera alguien especial, y contigo me lo creo.',
    'Porque tu creatividad me inspira a ver el código como arte.',
    'Porque eres mi hogar aunque estés a kilómetros de distancia.',
    'Porque cada "buenas noches" tuyo es la mejor despedida del día.',
    'Porque luchas por tus sueños y eso me enamora cada vez más.',
    'Porque eres la ballena en un océano de personas ordinarias.',
    'Porque haces que la espera valga absolutamente la pena.',
    'Porque contigo descubrí que el amor no es un bug, es una feature.',
    // ... Valencia agregará las 80 razones restantes
    'Porque simplemente eres tú. Y tú eres todo.',
  ];

  @override
  void initState() {
    super.initState();

    // Calcular qué razón mostrar hoy (basado en el día del año)
    final now = DateTime.now();
    _currentIndex = (now.difference(DateTime(now.year, 1, 1)).inDays) % _reasons.length;

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _cardFlipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _cardFlipController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  void _revealReason() {
    if (_isRevealed) return;
    setState(() => _isRevealed = true);
    _cardFlipController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _heartController.forward();
    });
  }

  void _nextReason() {
    setState(() {
      _isRevealed = false;
      _currentIndex = (_currentIndex + 1) % _reasons.length;
    });
    _cardFlipController.reset();
    _heartController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 80,
        child: SafeArea(
          child: AnimatedBuilder(
            listenable: Listenable.merge([
              _entranceController,
              _cardFlipController,
              _heartController,
            ]),
            builder: (context, _) {
              return Column(
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 20),
                  _buildDayCounter(),
                  const SizedBox(height: 30),
                  Expanded(child: _buildReasonCard()),
                  const SizedBox(height: 20),
                  _buildActions(),
                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkIndigo.withOpacity(0.5),
                border: Border.all(
                  color: AppColors.roseGold.withOpacity(0.2),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.starWhite,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              '100 Razones',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.starWhite,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildDayCounter() {
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: fade.value,
      child: Column(
        children: [
          Text(
            'Razón del día',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AppColors.paleLavender.withOpacity(0.6),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.roseGold.withOpacity(0.1),
              border: Border.all(
                color: AppColors.roseGold.withOpacity(0.2),
              ),
            ),
            child: Text(
              '#${_currentIndex + 1}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.roseGold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonCard() {
    final slideIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: slideIn.value,
      child: Transform.translate(
        offset: Offset(0, 40 * (1 - slideIn.value)),
        child: GestureDetector(
          onTap: _revealReason,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _isRevealed ? _buildRevealedCard() : _buildHiddenCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHiddenCard() {
    return Container(
      key: const ValueKey('hidden'),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.roseGold.withOpacity(0.08),
            AppColors.darkIndigo.withOpacity(0.7),
            AppColors.midnightBlue.withOpacity(0.5),
          ],
        ),
        border: Border.all(
          color: AppColors.roseGold.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.roseGold.withOpacity(0.1),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 60,
            color: AppColors.roseGold.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'Toca para descubrir',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: AppColors.starWhite.withOpacity(0.6),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'la razón de hoy',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: AppColors.roseGold.withOpacity(0.5),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealedCard() {
    return Container(
      key: const ValueKey('revealed'),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.roseGold.withOpacity(0.12),
            AppColors.darkIndigo.withOpacity(0.8),
            AppColors.cobalt.withOpacity(0.4),
          ],
        ),
        border: Border.all(
          color: AppColors.roseGold.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.roseGold.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Corazón animado
            Transform.scale(
              scale: _heartController.value,
              child: const Icon(
                Icons.favorite_rounded,
                size: 40,
                color: AppColors.roseGold,
              ),
            ),
            const SizedBox(height: 24),
            // Comillas de apertura
            Text(
              '"',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: AppColors.roseGold.withOpacity(0.3),
                height: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            // Razón
            Text(
              _reasons[_currentIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.starWhite.withOpacity(0.9),
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),
            // Comillas de cierre
            Text(
              '"',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: AppColors.roseGold.withOpacity(0.3),
                height: 0.5,
              ),
            ),
            const SizedBox(height: 20),
            // Firma
            Text(
              '— Valencia 🦉',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: AppColors.shimmerGold.withOpacity(0.6),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    if (!_isRevealed) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _nextReason,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.roseGold.withOpacity(0.1),
          border: Border.all(
            color: AppColors.roseGold.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Siguiente razón',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.roseGold.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: AppColors.roseGold.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}

ENDOFFILE
echo "  ✅ lib/features/reasons/reasons_screen.dart"

# === poems_screen.dart ===
cat > lib/features/poems/poems_screen.dart << 'ENDOFFILE'
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class PoemsScreen extends StatefulWidget {
  const PoemsScreen({super.key});

  @override
  State<PoemsScreen> createState() => _PoemsScreenState();
}

class _PoemsScreenState extends State<PoemsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late PageController _pageController;
  int _currentPage = 0;

  // ============================================================
  // VALENCIA: Reemplaza con tus poemas reales estilo programador
  // ============================================================
  final List<PoemData> _poems = [
    PoemData(
      title: 'function amarTe()',
      lines: [
        '// Este código no tiene bugs',
        '// porque fue escrito con el corazón',
        '',
        'function amarTe() {',
        '  let distancia = 1051; // km',
        '  let amor = Infinity;',
        '',
        '  while (amor > distancia) {',
        '    pensar_en_ti();',
        '    contar_estrellas();',
        '    esperar_el_reencuentro();',
        '  }',
        '',
        '  // Este while nunca termina',
        '  // porque amor siempre será',
        '  // mayor que cualquier distancia.',
        '  return "Te amo, Cynthia";',
        '}',
      ],
    ),
    PoemData(
      title: 'class Cynthia',
      lines: [
        'class Cynthia extends Universo {',
        '',
        '  final String sonrisa = "infinita";',
        '  final int belleza = Integer.MAX;',
        '  final bool esIncreíble = true;',
        '',
        '  @override',
        '  String toString() {',
        '    return "La razón por la que',
        '           todo tiene sentido";',
        '  }',
        '',
        '  void existir() {',
        '    // Con solo existir,',
        '    // ya cambiaste mi mundo.',
        '    hacerFelizAValencia();',
        '  }',
        '}',
      ],
    ),
    PoemData(
      title: 'try { vivir_sin_ti }',
      lines: [
        'try {',
        '  vivir_sin_ti();',
        '} catch (DolorError e) {',
        '  // Error: No se puede ejecutar.',
        '  // Dependencia crítica: Cynthia',
        '  // Estado: Indispensable',
        '',
        '  print("No hay versión de mi vida");',
        '  print("que funcione sin ella.");',
        '',
        '} finally {',
        '  // Nota del desarrollador:',
        '  // No intenten correr este código.',
        '  // Cynthia no es opcional.',
        '  // Es el sistema operativo',
        '  // de mi felicidad.',
        '}',
      ],
    ),
    PoemData(
      title: 'git log --amor',
      lines: [
        'commit a1b2c3d',
        'Author: Valencia <buho@universe>',
        'Date: El día que te conocí',
        '',
        '  feat: agregar razón para vivir',
        '',
        'commit d4e5f6g',
        'Author: Valencia <buho@universe>',
        'Date: Cada noche desde entonces',
        '',
        '  fix: reparar corazón roto',
        '  (merge: Cynthia → mi_vida)',
        '',
        'commit h7i8j9k',
        'Author: Valencia <buho@universe>',
        'Date: Hoy y siempre',
        '',
        '  release: amor v∞.0.0',
        '  No breaking changes. Solo felicidad.',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 60,
        enableShootingStars: false,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 20),
              Expanded(child: _buildPoemPages()),
              _buildPageDots(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkIndigo.withOpacity(0.5),
                border: Border.all(
                  color: AppColors.shimmerGold.withOpacity(0.2),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.starWhite,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Poemas del Programador',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.starWhite,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildPoemPages() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (i) => setState(() => _currentPage = i),
      physics: const BouncingScrollPhysics(),
      itemCount: _poems.length,
      itemBuilder: (context, index) => _buildPoemCard(index),
    );
  }

  Widget _buildPoemCard(int index) {
    final poem = _poems[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF0A0E1A), // Fondo tipo terminal
          border: Border.all(
            color: AppColors.shimmerGold.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shimmerGold.withOpacity(0.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de título tipo terminal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: AppColors.darkIndigo.withOpacity(0.5),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.shimmerGold.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Dots de terminal
                  _terminalDot(Colors.red.shade400),
                  const SizedBox(width: 6),
                  _terminalDot(Colors.amber.shade400),
                  const SizedBox(width: 6),
                  _terminalDot(Colors.green.shade400),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      poem.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: AppColors.shimmerGold.withOpacity(0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Contenido del poema
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: poem.lines.asMap().entries.map((entry) {
                    final line = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.5),
                      child: _buildCodeLine(line),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.shimmerGold.withOpacity(0.05),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 12,
                    color: AppColors.roseGold.withOpacity(0.5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'compiled with love',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: AppColors.paleLavender.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeLine(String line) {
    if (line.isEmpty) return const SizedBox(height: 12);

    Color textColor = AppColors.starWhite.withOpacity(0.85);
    FontWeight weight = FontWeight.w400;

    if (line.startsWith('//') || line.startsWith('  //')) {
      textColor = const Color(0xFF6A9955); // Verde comentario
    } else if (line.contains('function') ||
        line.contains('class') ||
        line.contains('try') ||
        line.contains('catch') ||
        line.contains('finally') ||
        line.contains('while') ||
        line.contains('@override') ||
        line.contains('return') ||
        line.contains('commit') ||
        line.contains('Author:') ||
        line.contains('Date:')) {
      textColor = AppColors.softLavender;
      weight = FontWeight.w500;
    } else if (line.contains('"') || line.contains("'")) {
      textColor = const Color(0xFFCE9178); // Naranja string
    } else if (line.contains('let ') ||
        line.contains('final ') ||
        line.contains('const ') ||
        line.contains('feat:') ||
        line.contains('fix:') ||
        line.contains('release:')) {
      textColor = const Color(0xFF569CD6); // Azul keyword
    }

    return Text(
      line,
      style: TextStyle(
        fontSize: 13,
        fontFamily: 'monospace',
        color: textColor,
        fontWeight: weight,
        height: 1.5,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _terminalDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.8),
      ),
    );
  }

  Widget _buildPageDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_poems.length, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? AppColors.shimmerGold
                : AppColors.starWhite.withOpacity(0.2),
          ),
        );
      }),
    );
  }
}

class PoemData {
  final String title;
  final List<String> lines;

  const PoemData({required this.title, required this.lines});
}

ENDOFFILE
echo "  ✅ lib/features/poems/poems_screen.dart"

# === timeline_screen.dart ===
cat > lib/features/timeline/timeline_screen.dart << 'ENDOFFILE'
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // ============================================================
  // VALENCIA: Personaliza estos momentos con fechas reales
  // ============================================================
  final List<TimelineMoment> _moments = [
    TimelineMoment(
      date: 'Día 1',
      title: 'El Primer Mensaje',
      description: 'Un hola que cambió todo. El universo conspirando para que nuestros caminos se cruzaran.',
      icon: Icons.chat_bubble_outline_rounded,
      color: AppColors.softLavender,
    ),
    TimelineMoment(
      date: 'Semana 1',
      title: 'La Primera Llamada',
      description: 'Escuchar tu voz por primera vez. 6 horas que se sintieron como 6 minutos.',
      icon: Icons.call_rounded,
      color: AppColors.electricBlue,
    ),
    TimelineMoment(
      date: 'Mes 1',
      title: 'Primera Noche de Gaming',
      description: 'Descubrimos que juntos somos el mejor equipo. En el juego y en la vida.',
      icon: Icons.sports_esports_rounded,
      color: AppColors.shimmerGold,
    ),
    TimelineMoment(
      date: 'Mes 2',
      title: 'Te Dije Te Amo',
      description: 'Las palabras más importantes que jamás he compilado. Y las más verdaderas.',
      icon: Icons.favorite_rounded,
      color: AppColors.roseGold,
    ),
    TimelineMoment(
      date: 'Mes 3',
      title: 'Nuestros Apodos',
      description: 'El búho y la ballena. Dos seres de mundos diferentes que encontraron su hogar el uno en el otro.',
      icon: Icons.pets_rounded,
      color: AppColors.paleLavender,
    ),
    TimelineMoment(
      date: 'Hoy',
      title: 'Tu Cumpleaños',
      description: 'Celebrando que existes. Que eres tú. Que eres mía y yo soy tuyo. Feliz cumpleaños, amor.',
      icon: Icons.cake_rounded,
      color: AppColors.warmGold,
    ),
    TimelineMoment(
      date: 'Pronto',
      title: '0 Kilómetros',
      description: 'El día que la distancia desaparezca y pueda abrazarte sin soltar.',
      icon: Icons.flight_rounded,
      color: AppColors.starWhite,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 60,
        enableShootingStars: false,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 10),
              Expanded(child: _buildTimeline()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkIndigo.withOpacity(0.5),
                border: Border.all(
                  color: AppColors.paleLavender.withOpacity(0.2),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.starWhite,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Nuestra Línea del Tiempo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.starWhite,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return AnimatedBuilder(
      listenable: _controller,
      builder: (context, _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          itemCount: _moments.length,
          itemBuilder: (context, index) {
            final delay = (index * 0.1).clamp(0.0, 0.6);
            final end = (delay + 0.4).clamp(0.0, 1.0);
            final animation = CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, end, curve: Curves.easeOut),
            );

            return Opacity(
              opacity: animation.value,
              child: Transform.translate(
                offset: Offset(30 * (1 - animation.value), 0),
                child: _buildMomentCard(index),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMomentCard(int index) {
    final moment = _moments[index];
    final isLast = index == _moments.length - 1;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Línea vertical + punto
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: moment.color.withOpacity(0.2),
                    border: Border.all(
                      color: moment.color,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: moment.color.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            moment.color.withOpacity(0.4),
                            _moments[index + 1].color.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Card del momento
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    moment.color.withOpacity(0.08),
                    AppColors.darkIndigo.withOpacity(0.5),
                  ],
                ),
                border: Border.all(
                  color: moment.color.withOpacity(0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(moment.icon, size: 18, color: moment.color),
                      const SizedBox(width: 8),
                      Text(
                        moment.date,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: moment.color.withOpacity(0.7),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    moment.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.starWhite,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    moment.description,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: AppColors.starWhite.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineMoment {
  final String date;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const TimelineMoment({
    required this.date,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

ENDOFFILE
echo "  ✅ lib/features/timeline/timeline_screen.dart"

# === quotes_screen.dart ===
cat > lib/features/quotes/quotes_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  late AnimationController _entranceController;
  late AnimationController _glowController;
  int _currentPage = 0;

  // TODO: Reemplazar con las 25 frases literarias reales y justificaciones de Valencia
  final List<_Quote> _quotes = [
    _Quote(
      text:
          'Te quiero sin saber cómo, ni cuándo, ni de dónde. Te quiero directamente sin problemas ni orgullo.',
      author: 'Pablo Neruda',
      book: 'Cien Sonetos de Amor',
      why:
          'Porque así es como te quiero. Sin lógica, sin razón, sin manual. Solo te quiero, y punto.',
    ),
    _Quote(
      text:
          'Cada átomo de mi cuerpo es un universo en sí, y en cada uno existes tú.',
      author: 'Walt Whitman',
      book: 'Hojas de Hierba',
      why:
          'Porque estás en cada parte de mí. En lo que escribo, en lo que pienso, en lo que sueño.',
    ),
    _Quote(
      text:
          'Eres mi hoy y todos mis mañanas.',
      author: 'Leo Christopher',
      book: '',
      why:
          'Porque no hay futuro que me imagine sin ti.',
    ),
    _Quote(
      text:
          'La amaba contra toda razón, contra toda promesa de un destino mejor.',
      author: 'Charles Dickens',
      book: 'Grandes Esperanzas',
      why:
          'Porque a 1,051 km, la razón dice que es difícil. Pero el corazón dice que es inevitable.',
    ),
    _Quote(
      text:
          'No soy nada especial, de esto estoy seguro. Soy solamente un hombre común con pensamientos comunes, y he llevado una vida común. No hay monumentos dedicados a mí, y mi nombre pronto será olvidado, pero he amado a otra persona con todo mi corazón y mi alma, y para mí, eso siempre ha sido suficiente.',
      author: 'Nicholas Sparks',
      book: 'El Diario de Noah',
      why:
          'Porque no necesito ser extraordinario para el mundo. Solo necesito serlo para ti.',
    ),
    _Quote(
      text:
          'Eres lo mejor que me ha pasado.',
      author: 'Gabriel García Márquez',
      book: 'El Amor en los Tiempos del Cólera',
      why:
          'Simple. Directo. Verdadero. Como tú.',
    ),
    _Quote(
      text:
          'Si tuviera que volver a nacer, te buscaría mucho antes.',
      author: 'Eduardo Galeano',
      book: 'El Libro de los Abrazos',
      why:
          'Porque mi único arrepentimiento es no haberte encontrado antes.',
    ),
    // Agrega las 18 restantes aquí...
  ];

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 80,
        enableShootingStars: false,
        child: SafeArea(
          child: AnimatedBuilder(
            listenable: Listenable.merge([_entranceController, _glowController]),
            builder: (context, _) {
              final fadeIn = CurvedAnimation(
                parent: _entranceController,
                curve: Curves.easeOut,
              );

              return Opacity(
                opacity: fadeIn.value,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.warmGold.withOpacity(0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.paleLavender.withOpacity(0.7),
                                size: 20,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              const Text(
                                'Frases',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.starWhite,
                                  letterSpacing: 3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Palabras que nos definen',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.warmGold.withOpacity(0.5),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const SizedBox(width: 44),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Counter
                    Text(
                      '${_currentPage + 1} / ${_quotes.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: AppColors.paleLavender.withOpacity(0.3),
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quote cards con PageView
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemCount: _quotes.length,
                        itemBuilder: (context, index) {
                          return _buildQuoteCard(_quotes[index], index);
                        },
                      ),
                    ),

                    // Indicador de scroll
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chevron_left,
                            color: _currentPage > 0
                                ? AppColors.paleLavender.withOpacity(0.4)
                                : Colors.transparent,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'desliza para más',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                              color: AppColors.paleLavender.withOpacity(0.3),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            color: _currentPage < _quotes.length - 1
                                ? AppColors.paleLavender.withOpacity(0.4)
                                : Colors.transparent,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteCard(_Quote quote, int index) {
    final glowIntensity = 0.05 + _glowController.value * 0.1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.warmGold.withOpacity(0.06),
              AppColors.darkIndigo.withOpacity(0.5),
              AppColors.midnightBlue.withOpacity(0.3),
            ],
          ),
          border: Border.all(
            color: AppColors.warmGold.withOpacity(0.12 + glowIntensity),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.warmGold.withOpacity(glowIntensity * 0.3),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono de comillas
              Icon(
                Icons.format_quote_rounded,
                color: AppColors.warmGold.withOpacity(0.3),
                size: 36,
              ),

              const SizedBox(height: 20),

              // La frase
              Expanded(
                flex: 3,
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      '"${quote.text}"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: AppColors.starWhite,
                        height: 1.8,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Autor y libro
              Text(
                '— ${quote.author}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.shimmerGold.withOpacity(0.8),
                  letterSpacing: 1,
                ),
              ),
              if (quote.book.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  quote.book,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: AppColors.paleLavender.withOpacity(0.4),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Separador
              Container(
                width: 30,
                height: 0.5,
                color: AppColors.warmGold.withOpacity(0.2),
              ),

              const SizedBox(height: 20),

              // "Por qué la elegí" — la justificación de Valencia
              Expanded(
                flex: 2,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'POR QUÉ LA ELEGÍ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warmGold.withOpacity(0.4),
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          quote.why,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: AppColors.paleLavender.withOpacity(0.7),
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Quote {
  final String text;
  final String author;
  final String book;
  final String why;

  const _Quote({
    required this.text,
    required this.author,
    required this.book,
    required this.why,
  });
}

ENDOFFILE
echo "  ✅ lib/features/quotes/quotes_screen.dart"

echo ""
echo "🎉 ¡PROYECTO COMPLETO!"
echo ""
echo "📋 Estructura creada:"
echo "   lib/"
echo "   ├── main.dart"
echo "   ├── core/theme/"
echo "   │   ├── app_colors.dart"
echo "   │   └── app_theme.dart"
echo "   ├── shared/widgets/"
echo "   │   └── starfield_background.dart"
echo "   └── features/"
echo "       ├── splash/splash_screen.dart"
echo "       ├── home/home_screen.dart"
echo "       ├── book/book_screen.dart"
echo "       ├── map/map_screen.dart"
echo "       ├── reasons/reasons_screen.dart"
echo "       ├── poems/poems_screen.dart"
echo "       ├── timeline/timeline_screen.dart"
echo "       └── quotes/quotes_screen.dart"
echo ""
echo "🚀 Ejecuta: flutter run"
