#!/bin/bash
# ================================================================
# FIX: Reescribir effort_screen.dart con datos actuales
# Ejecuta desde la raiz de cynthia_app/: bash fix_effort2.sh
# ================================================================

echo "Reescribiendo pantalla El Esfuerzo por Ti..."

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

  final List<_StatData> _stats = [
    _StatData(
      value: 5500,
      label: 'Lineas de codigo',
      subtitle: 'escritas pensando en ti',
      icon: Icons.code_rounded,
      color: AppColors.electricBlue,
    ),
    _StatData(
      value: 170000,
      label: 'Caracteres escritos',
      subtitle: 'y cada uno dice te quiero',
      icon: Icons.text_fields_rounded,
      color: AppColors.shimmerGold,
    ),
    _StatData(
      value: 16,
      label: 'Archivos creados',
      subtitle: 'cada uno con un pedazo de mi',
      icon: Icons.folder_rounded,
      color: AppColors.warmGold,
    ),
    _StatData(
      value: 12,
      label: 'Pantallas unicas',
      subtitle: 'mundos enteros solo para ti',
      icon: Icons.phone_android_rounded,
      color: AppColors.softLavender,
    ),
    _StatData(
      value: 65,
      label: 'Animaciones',
      subtitle: 'para que cada momento brille',
      icon: Icons.animation_rounded,
      color: AppColors.roseGold,
    ),
    _StatData(
      value: 200,
      label: 'Estrellas en tu cielo',
      subtitle: 'cada una brilla diferente como tu',
      icon: Icons.star_rounded,
      color: AppColors.paleLavender,
    ),
    _StatData(
      value: 25,
      label: 'Mensajes secretos',
      subtitle: 'escondidos en corazones',
      icon: Icons.favorite_rounded,
      color: const Color(0xFFFF6B8A),
    ),
    _StatData(
      value: 100,
      label: 'Razones para quererte',
      subtitle: 'y me quedaron cortas',
      icon: Icons.list_alt_rounded,
      color: AppColors.electricBlue,
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
                  const SizedBox(height: 20),
                  Expanded(child: _buildStatsList()),
                  _buildFooter(),
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
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.electricBlue.withOpacity(0.1),
                border: Border.all(
                  color: AppColors.electricBlue.withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricBlue
                        .withOpacity(0.1 + _pulseController.value * 0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.terminal_rounded,
                color: AppColors.electricBlue,
                size: 26,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Detras de cada estrella,\ncada animacion, cada palabra...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: AppColors.paleLavender.withOpacity(0.5),
                height: 1.5,
                fontStyle: FontStyle.italic,
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
        final delay = (0.15 + index * 0.07).clamp(0.0, 0.6);
        final end = (delay + 0.35).clamp(0.0, 1.0);

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
    final countValue = (_countController.value * stat.value).round();
    final glowIntensity = 0.05 + _pulseController.value * 0.06;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            stat.color.withOpacity(0.07),
            AppColors.darkIndigo.withOpacity(0.4),
            Colors.transparent,
          ],
        ),
        border: Border.all(
          color: stat.color.withOpacity(0.10 + glowIntensity),
        ),
        boxShadow: [
          BoxShadow(
            color: stat.color.withOpacity(glowIntensity * 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: stat.color.withOpacity(0.1),
              border: Border.all(
                color: stat.color.withOpacity(0.2),
              ),
            ),
            child: Icon(stat.icon, color: stat.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatNumber(countValue),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: stat.color,
                    fontFamily: 'monospace',
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  stat.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.starWhite,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  stat.subtitle,
                  style: TextStyle(
                    fontSize: 10,
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
      opacity: fade.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.shimmerGold.withOpacity(0.06),
                AppColors.darkIndigo.withOpacity(0.4),
              ],
            ),
            border: Border.all(
              color: AppColors.shimmerGold.withOpacity(0.15),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 16,
                color: AppColors.roseGold.withOpacity(0.5),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Cada linea fue escrita pensando en ti, Cynthia.\nTu vales cada segundo.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: AppColors.starWhite.withOpacity(0.6),
                    height: 1.5,
                    fontStyle: FontStyle.italic,
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

echo "  Reescrito: lib/features/effort/effort_screen.dart"
echo ""
echo "Listo. Ejecuta: flutter run"
