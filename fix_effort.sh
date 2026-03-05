#!/bin/bash
# ================================================================
# AGREGAR: Pantalla "El Esfuerzo por Ti"
# Ejecuta desde la raiz de cynthia_app/: bash fix_effort.sh
# ================================================================

echo "Creando pantalla El Esfuerzo por Ti..."

# 1. Crear carpeta
mkdir -p lib/features/effort

# 2. Crear effort_screen.dart
cat > lib/features/effort/effort_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class EffortScreen extends StatefulWidget {
  const EffortScreen({super.key});

  @override
  State<EffortScreen> createState() => _EffortScreenState();
}

class _EffortScreenState extends State<EffortScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _countController;
  late AnimationController _pulseController;

  // ============================================================
  // Estadisticas reales del proyecto
  // ============================================================
  final List<_StatData> _stats = [
    _StatData(
      value: 3500,
      label: 'Lineas de codigo',
      subtitle: 'escritas pensando en ti',
      icon: Icons.code_rounded,
      color: AppColors.electricBlue,
    ),
    _StatData(
      value: 12,
      label: 'Archivos creados',
      subtitle: 'cada uno con un pedazo de mi',
      icon: Icons.folder_rounded,
      color: AppColors.shimmerGold,
    ),
    _StatData(
      value: 8,
      label: 'Pantallas unicas',
      subtitle: 'mundos enteros para ti',
      icon: Icons.phone_android_rounded,
      color: AppColors.softLavender,
    ),
    _StatData(
      value: 55,
      label: 'Animaciones',
      subtitle: 'para que cada momento brille',
      icon: Icons.animation_rounded,
      color: AppColors.roseGold,
    ),
    _StatData(
      value: 200,
      label: 'Estrellas animadas',
      subtitle: 'en tu cielo personal',
      icon: Icons.star_rounded,
      color: AppColors.warmGold,
    ),
    _StatData(
      value: 107732,
      label: 'Caracteres escritos',
      subtitle: 'y cada uno dice te quiero',
      icon: Icons.text_fields_rounded,
      color: AppColors.paleLavender,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _countController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _countController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _countController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 100,
        enableShootingStars: true,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _entranceController,
              _countController,
              _pulseController,
            ]),
            builder: (context, _) {
              return Column(
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 10),
                  _buildHeader(),
                  const SizedBox(height: 24),
                  Expanded(child: _buildStatsList()),
                  _buildFooter(),
                  const SizedBox(height: 24),
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
          const Expanded(
            child: Text(
              'El Esfuerzo por Ti',
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

  Widget _buildHeader() {
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: fade.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            // Icono de corazon con codigo
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.electricBlue.withOpacity(0.1),
                border: Border.all(
                  color: AppColors.electricBlue.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricBlue
                        .withOpacity(0.1 + _pulseController.value * 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.terminal_rounded,
                color: AppColors.electricBlue,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Detras de cada estrella,\ncada animacion, cada palabra...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: AppColors.paleLavender.withOpacity(0.6),
                height: 1.6,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'hay alguien que te quiere demasiado.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.shimmerGold.withOpacity(0.7),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _stats.length,
      itemBuilder: (context, index) {
        final delay = (0.15 + index * 0.08).clamp(0.0, 0.6);
        final end = (delay + 0.4).clamp(0.0, 1.0);

        final slideIn = CurvedAnimation(
          parent: _entranceController,
          curve: Interval(delay, end, curve: Curves.easeOut),
        );

        return Opacity(
          opacity: slideIn.value,
          child: Transform.translate(
            offset: Offset(40 * (1 - slideIn.value), 0),
            child: _buildStatCard(_stats[index]),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(_StatData stat) {
    // Animar el conteo
    final countValue = (_countController.value * stat.value).round();
    final glowIntensity = 0.05 + _pulseController.value * 0.08;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            stat.color.withOpacity(0.08),
            AppColors.darkIndigo.withOpacity(0.4),
            Colors.transparent,
          ],
        ),
        border: Border.all(
          color: stat.color.withOpacity(0.12 + glowIntensity),
        ),
        boxShadow: [
          BoxShadow(
            color: stat.color.withOpacity(glowIntensity * 0.4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: stat.color.withOpacity(0.1),
              border: Border.all(
                color: stat.color.withOpacity(0.25),
              ),
            ),
            child: Icon(stat.icon, color: stat.color, size: 22),
          ),
          const SizedBox(width: 16),
          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Numero animado
                Text(
                  _formatNumber(countValue),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: stat.color,
                    fontFamily: 'monospace',
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.starWhite,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat.subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: stat.color.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      final str = number.toString();
      final result = StringBuffer();
      for (int i = 0; i < str.length; i++) {
        if (i > 0 && (str.length - i) % 3 == 0) {
          result.write(',');
        }
        result.write(str[i]);
      }
      return result.toString();
    }
    return number.toString();
  }

  Widget _buildFooter() {
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: fade.value * 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.shimmerGold.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.favorite_rounded,
                color: AppColors.roseGold.withOpacity(0.4),
                size: 18,
              ),
              const SizedBox(height: 8),
              Text(
                'Cada linea de este codigo fue escrita\npensando en ti, Cynthia.\nTu vales cada segundo de esfuerzo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppColors.paleLavender.withOpacity(0.5),
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '- Valencia',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.shimmerGold.withOpacity(0.4),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatData {
  final int value;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatData({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
ENDOFFILE

echo "  Creado: lib/features/effort/effort_screen.dart"

# 3. Agregar al home_screen.dart - agregar import y la seccion
# Agregar import
sed -i '' "s|import '../timeline/timeline_screen.dart';|import '../timeline/timeline_screen.dart';\nimport '../effort/effort_screen.dart';|" lib/features/home/home_screen.dart 2>/dev/null || sed -i "s|import '../timeline/timeline_screen.dart';|import '../timeline/timeline_screen.dart';\nimport '../effort/effort_screen.dart';|" lib/features/home/home_screen.dart

# Agregar la seccion antes del cierre de _sections
# Buscamos la linea de "Frases" y agregamos despues del bloque
sed -i '' "s|screen: const QuotesScreen(),|screen: const QuotesScreen(),\n    ),\n    _SectionData(\n      title: 'El Esfuerzo',\n      subtitle: 'Todo lo que escribi por ti',\n      icon: Icons.terminal_rounded,\n      color: AppColors.electricBlue,\n      screen: const EffortScreen(),|" lib/features/home/home_screen.dart 2>/dev/null || sed -i "s|screen: const QuotesScreen(),|screen: const QuotesScreen(),\n    ),\n    _SectionData(\n      title: 'El Esfuerzo',\n      subtitle: 'Todo lo que escribi por ti',\n      icon: Icons.terminal_rounded,\n      color: AppColors.electricBlue,\n      screen: const EffortScreen(),|" lib/features/home/home_screen.dart

echo "  Actualizado: lib/features/home/home_screen.dart"
echo ""
echo "Listo - nueva seccion agregada. Ejecuta: flutter run"
