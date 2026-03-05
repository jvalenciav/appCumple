import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';
import '../book/book_screen.dart';
import '../reasons/reasons_screen.dart';
import '../poems/poems_screen.dart';
import '../timeline/timeline_screen.dart';
import '../effort/effort_screen.dart';
import '../hug/hug_screen.dart';
import '../hearts_game/hearts_game_screen.dart';
import '../canvas/canvas_screen.dart';
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
      subtitle: 'Por las que te quiero',
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
    _SectionData(
      title: 'El Esfuerzo',
      subtitle: 'Todo lo que escribi por ti',
      icon: Icons.terminal_rounded,
      color: AppColors.electricBlue,
      screen: const EffortScreen(),
    ),
    _SectionData(
      title: 'Abrazo Virtual',
      subtitle: 'Juntanos con un toque',
      icon: Icons.people_rounded,
      color: AppColors.roseGold,
      screen: const HugScreen(),
    ),
    _SectionData(
      title: 'Atrapa Corazones',
      subtitle: 'Cada uno tiene un secreto',
      icon: Icons.catching_pokemon,
      color: Color(0xFFFF6B8A),
      screen: const HeartsGameScreen(),
    ),
    _SectionData(
      title: 'Tu Lienzo',
      subtitle: 'Dibuja lo que sientas',
      icon: Icons.palette_rounded,
      color: AppColors.softLavender,
      screen: const CanvasScreen(),
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
            animation: Listenable.merge([
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

