#!/bin/bash
# ================================================================
# FIX: Hacer el mensaje final mas grande y visible
# Ejecuta desde la raiz de cynthia_app/: bash fix_footer.sh
# ================================================================

echo "Mejorando mensaje final..."

# Reemplazar toda la funcion _buildFooter con una version mas prominente
# Usamos python porque el bloque es grande y sed no es ideal para multilinea

python3 << 'PYEOF'
import re

filepath = "lib/features/effort/effort_screen.dart"

with open(filepath, "r") as f:
    content = f.read()

old_footer = '''  Widget _buildFooter() {
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
                'Cada linea de este codigo fue escrita\\npensando en ti, Cynthia.\\nTu vales cada segundo de esfuerzo.',
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
  }'''

new_footer = '''  Widget _buildFooter() {
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );
    final glowIntensity = 0.15 + _pulseController.value * 0.15;

    return Opacity(
      opacity: fade.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.shimmerGold.withOpacity(0.08),
                AppColors.darkIndigo.withOpacity(0.6),
                AppColors.roseGold.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: AppColors.shimmerGold.withOpacity(0.2 + glowIntensity),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shimmerGold.withOpacity(glowIntensity * 0.4),
                blurRadius: 25,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.roseGold.withOpacity(glowIntensity * 0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Corazon con glow
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.roseGold.withOpacity(0.1),
                  border: Border.all(
                    color: AppColors.roseGold.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.roseGold.withOpacity(glowIntensity),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: AppColors.roseGold.withOpacity(0.8),
                  size: 24,
                ),
              ),
              const SizedBox(height: 20),
              // Mensaje principal - grande y claro
              Text(
                'Cada linea de este codigo\\nfue escrita pensando en ti,',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.starWhite.withOpacity(0.9),
                  height: 1.6,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              // Nombre Cynthia destacado
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      AppColors.shimmerGold,
                      AppColors.roseGold,
                      AppColors.shimmerGold,
                    ],
                  ).createShader(bounds);
                },
                child: const Text(
                  'Cynthia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Linea decorativa
              Container(
                width: 50,
                height: 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.shimmerGold.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Mensaje secundario
              Text(
                'Tu vales cada segundo de esfuerzo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.starWhite.withOpacity(0.8),
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              // Firma Valencia
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.shimmerGold.withOpacity(0.08),
                  border: Border.all(
                    color: AppColors.shimmerGold.withOpacity(0.15),
                  ),
                ),
                child: Text(
                  'con todo mi esfuerzo  —  Valencia',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.shimmerGold.withOpacity(0.7),
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }'''

if old_footer in content:
    content = content.replace(old_footer, new_footer)
    with open(filepath, "w") as f:
        f.write(content)
    print("  Fixed: effort_screen.dart - mensaje final ahora es grande y visible")
else:
    print("  WARN: No se encontro el footer exacto. Verificar manualmente.")

PYEOF

echo ""
echo "Listo. Ejecuta: flutter run"
