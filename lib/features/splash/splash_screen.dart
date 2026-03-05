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
          animation: Listenable.merge([
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

