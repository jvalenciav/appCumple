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
            animation: Listenable.merge([
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

