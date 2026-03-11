#!/bin/bash
# ================================================================
# AGREGAR: Nuestra Mascota - Tamagotchi virtual
# Ejecuta desde la raiz de cynthia_app/: bash fix_pet.sh
# ================================================================

echo "Creando Nuestra Mascota..."

mkdir -p lib/features/pet

cat > lib/features/pet/pet_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

// Necesitas agregar en pubspec.yaml:
// dependencies:
//   shared_preferences: ^2.2.3
import 'package:shared_preferences/shared_preferences.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> with TickerProviderStateMixin {
  // Estado de la mascota
  String? _petType;
  String _petName = '';
  Color _petColor = Colors.white;
  int _hunger = 80;     // 0-100
  int _happiness = 80;
  int _energy = 80;
  int _hygiene = 80;
  int _age = 0;         // dias
  bool _isSleeping = false;
  bool _petSelected = false;
  DateTime? _lastInteraction;

  // Animaciones
  late AnimationController _bounceController;
  late AnimationController _entranceController;
  late AnimationController _reactionController;
  late AnimationController _sleepController;
  String _reactionEmoji = '';
  bool _showReaction = false;

  // Catalogo de mascotas
  final List<_PetOption> _catalog = [
    _PetOption(type: 'whale', name: 'Ballenita', icon: Icons.water_rounded, color: AppColors.electricBlue, desc: 'Tu simbolo'),
    _PetOption(type: 'owl', name: 'Buhito', icon: Icons.nightlight_round, color: AppColors.shimmerGold, desc: 'Mi simbolo'),
    _PetOption(type: 'dog', name: 'Perrito', icon: Icons.pets_rounded, color: AppColors.warmGold, desc: 'Nos encantan'),
    _PetOption(type: 'cat', name: 'Gatito', icon: Icons.pest_control_rodent_rounded, color: AppColors.softLavender, desc: 'Como los tuyos'),
    _PetOption(type: 'bunny', name: 'Conejito', icon: Icons.cruelty_free_rounded, color: AppColors.roseGold, desc: 'Suavecito'),
    _PetOption(type: 'hamster', name: 'Hamster', icon: Icons.emoji_nature_rounded, color: AppColors.paleLavender, desc: 'Chiquito'),
  ];

  // Colores disponibles
  final List<_ColorOption> _colorOptions = [
    _ColorOption(name: 'Blanco', color: const Color(0xFFF5F5F5)),
    _ColorOption(name: 'Dorado', color: const Color(0xFFFFD54F)),
    _ColorOption(name: 'Rosa', color: const Color(0xFFFF8FAB)),
    _ColorOption(name: 'Azul', color: const Color(0xFF90CAF9)),
    _ColorOption(name: 'Lavanda', color: const Color(0xFFCE93D8)),
    _ColorOption(name: 'Menta', color: const Color(0xFF80CBC4)),
    _ColorOption(name: 'Durazno', color: const Color(0xFFFFCC80)),
    _ColorOption(name: 'Gris', color: const Color(0xFFBDBDBD)),
  ];

  int _selectedColorIndex = 0;
  int _catalogPage = 0;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _reactionController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _sleepController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _loadPet();
  }

  Future<void> _loadPet() async {
    final prefs = await SharedPreferences.getInstance();
    final type = prefs.getString('pet_type');
    if (type != null) {
      setState(() {
        _petSelected = true;
        _petType = type;
        _petName = prefs.getString('pet_name') ?? 'Mascota';
        _petColor = Color(prefs.getInt('pet_color') ?? 0xFFF5F5F5);
        _hunger = prefs.getInt('pet_hunger') ?? 80;
        _happiness = prefs.getInt('pet_happiness') ?? 80;
        _energy = prefs.getInt('pet_energy') ?? 80;
        _hygiene = prefs.getInt('pet_hygiene') ?? 80;
        _age = prefs.getInt('pet_age') ?? 0;
        _isSleeping = prefs.getBool('pet_sleeping') ?? false;

        final lastStr = prefs.getString('pet_last_interaction');
        if (lastStr != null) {
          _lastInteraction = DateTime.tryParse(lastStr);
          _applyTimePassed();
        }
      });
      if (_isSleeping) _sleepController.repeat(reverse: true);
    }
  }

  void _applyTimePassed() {
    if (_lastInteraction == null) return;
    final now = DateTime.now();
    final hours = now.difference(_lastInteraction!).inHours;
    if (hours > 0) {
      setState(() {
        _hunger = (_hunger - hours * 3).clamp(0, 100);
        _happiness = (_happiness - hours * 2).clamp(0, 100);
        _energy = _isSleeping ? (_energy + hours * 5).clamp(0, 100) : (_energy - hours * 2).clamp(0, 100);
        _hygiene = (_hygiene - hours * 1).clamp(0, 100);
        _age = now.difference(DateTime(2026, 3, 1)).inDays.clamp(0, 9999);
        if (_isSleeping && _energy >= 90) _isSleeping = false;
      });
    }
  }

  Future<void> _savePet() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pet_type', _petType ?? '');
    prefs.setString('pet_name', _petName);
    prefs.setInt('pet_color', _petColor.value);
    prefs.setInt('pet_hunger', _hunger);
    prefs.setInt('pet_happiness', _happiness);
    prefs.setInt('pet_energy', _energy);
    prefs.setInt('pet_hygiene', _hygiene);
    prefs.setInt('pet_age', _age);
    prefs.setBool('pet_sleeping', _isSleeping);
    prefs.setString('pet_last_interaction', DateTime.now().toIso8601String());
  }

  void _selectPet(String type) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dale un nombre a tu mascota'),
          backgroundColor: AppColors.darkIndigo,
        ),
      );
      return;
    }
    setState(() {
      _petType = type;
      _petName = _nameController.text.trim();
      _petColor = _colorOptions[_selectedColorIndex].color;
      _petSelected = true;
      _hunger = 80;
      _happiness = 100;
      _energy = 80;
      _hygiene = 100;
      _age = 0;
      _lastInteraction = DateTime.now();
    });
    _savePet();
    HapticFeedback.mediumImpact();
  }

  void _feedPet() {
    if (_isSleeping) return;
    setState(() {
      _hunger = (_hunger + 25).clamp(0, 100);
      _happiness = (_happiness + 5).clamp(0, 100);
    });
    _showReactionAnim('🍖');
    _savePet();
  }

  void _petPet() {
    if (_isSleeping) return;
    setState(() {
      _happiness = (_happiness + 20).clamp(0, 100);
    });
    _showReactionAnim('💕');
    HapticFeedback.lightImpact();
    _savePet();
  }

  void _playWithPet() {
    if (_isSleeping) return;
    if (_energy < 15) {
      _showReactionAnim('😴');
      return;
    }
    setState(() {
      _happiness = (_happiness + 20).clamp(0, 100);
      _energy = (_energy - 15).clamp(0, 100);
      _hunger = (_hunger - 10).clamp(0, 100);
    });
    _showReactionAnim('🎾');
    _savePet();
  }

  void _bathPet() {
    if (_isSleeping) return;
    setState(() {
      _hygiene = 100;
      _happiness = (_happiness + 5).clamp(0, 100);
    });
    _showReactionAnim('🫧');
    _savePet();
  }

  void _toggleSleep() {
    setState(() {
      _isSleeping = !_isSleeping;
    });
    if (_isSleeping) {
      _sleepController.repeat(reverse: true);
      _showReactionAnim('💤');
    } else {
      _sleepController.stop();
      _sleepController.reset();
      setState(() {
        _energy = (_energy + 30).clamp(0, 100);
      });
      _showReactionAnim('☀️');
    }
    _savePet();
  }

  void _showReactionAnim(String emoji) {
    setState(() {
      _reactionEmoji = emoji;
      _showReaction = true;
    });
    _reactionController.forward(from: 0).then((_) {
      if (mounted) setState(() => _showReaction = false);
    });
  }

  String _getMood() {
    final avg = (_hunger + _happiness + _energy + _hygiene) / 4;
    if (_isSleeping) return 'Durmiendo...';
    if (avg >= 80) return 'Muy feliz!';
    if (avg >= 60) return 'Contento';
    if (avg >= 40) return 'Normal';
    if (avg >= 20) return 'Triste...';
    return 'Necesita atencion!';
  }

  String _getAgeText() {
    if (_age == 0) return 'Recien nacido';
    if (_age == 1) return '1 dia';
    if (_age < 7) return '$_age dias';
    if (_age < 30) return '${_age ~/ 7} semanas';
    return '${_age ~/ 30} meses';
  }

  String _getStage() {
    if (_age < 3) return 'Bebe';
    if (_age < 14) return 'Pequeno';
    if (_age < 30) return 'Joven';
    return 'Adulto';
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _entranceController.dispose();
    _reactionController.dispose();
    _sleepController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 60,
        enableShootingStars: false,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _entranceController,
              _bounceController,
              _reactionController,
              _sleepController,
            ]),
            builder: (context, _) {
              return Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: _petSelected ? _buildPetView() : _buildCatalog(),
                  ),
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
                border: Border.all(color: AppColors.softLavender.withOpacity(0.2)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.starWhite),
            ),
          ),
          Expanded(
            child: Text(
              _petSelected ? _petName : 'Elige tu Mascota',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.starWhite, letterSpacing: 1),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  // ============================================================
  // CATALOGO DE MASCOTAS
  // ============================================================
  Widget _buildCatalog() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'Escoge a tu companero',
            style: TextStyle(fontSize: 14, color: AppColors.paleLavender.withOpacity(0.5), fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 20),
          // Grid de mascotas
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: _catalog.length,
            itemBuilder: (ctx, i) {
              final pet = _catalog[i];
              final isSelected = _catalogPage == i;
              return GestureDetector(
                onTap: () => setState(() => _catalogPage = i),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isSelected ? pet.color.withOpacity(0.15) : AppColors.darkIndigo.withOpacity(0.4),
                    border: Border.all(
                      color: isSelected ? pet.color.withOpacity(0.5) : AppColors.paleLavender.withOpacity(0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(pet.icon, color: pet.color, size: 32),
                      const SizedBox(height: 6),
                      Text(pet.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.starWhite)),
                      Text(pet.desc, style: TextStyle(fontSize: 9, color: pet.color.withOpacity(0.5))),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          // Selector de color
          Text('Color:', style: TextStyle(fontSize: 12, color: AppColors.paleLavender.withOpacity(0.5))),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _colorOptions.asMap().entries.map((e) {
              final isSelected = _selectedColorIndex == e.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedColorIndex = e.key),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: e.value.color,
                    border: Border.all(
                      color: isSelected ? AppColors.starWhite : Colors.transparent,
                      width: isSelected ? 3 : 0,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Nombre
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.darkIndigo.withOpacity(0.5),
              border: Border.all(color: AppColors.paleLavender.withOpacity(0.15)),
            ),
            child: TextField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.starWhite, fontSize: 16),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Nombre de tu mascota',
                hintStyle: TextStyle(color: AppColors.paleLavender.withOpacity(0.3)),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Boton adoptar
          GestureDetector(
            onTap: () => _selectPet(_catalog[_catalogPage].type),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [
                  _catalog[_catalogPage].color.withOpacity(0.3),
                  AppColors.darkIndigo.withOpacity(0.5),
                ]),
                border: Border.all(color: _catalog[_catalogPage].color.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_rounded, color: _catalog[_catalogPage].color, size: 20),
                  const SizedBox(width: 10),
                  Text('Adoptar ${_catalog[_catalogPage].name}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.starWhite)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ============================================================
  // VISTA DE LA MASCOTA
  // ============================================================
  Widget _buildPetView() {
    return Column(
      children: [
        // Mood y edad
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_getMood(), style: TextStyle(fontSize: 13, color: AppColors.shimmerGold.withOpacity(0.6), fontStyle: FontStyle.italic)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.darkIndigo.withOpacity(0.5),
                ),
                child: Text('${_getStage()} - ${_getAgeText()}',
                    style: TextStyle(fontSize: 10, color: AppColors.paleLavender.withOpacity(0.4))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Barras de estado
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _buildStatBar('🍖', _hunger, Colors.orange),
              const SizedBox(width: 8),
              _buildStatBar('💕', _happiness, AppColors.roseGold),
              const SizedBox(width: 8),
              _buildStatBar('⚡', _energy, AppColors.electricBlue),
              const SizedBox(width: 8),
              _buildStatBar('🫧', _hygiene, AppColors.softLavender),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Mascota
        Expanded(
          child: GestureDetector(
            onTap: _petPet,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Mascota con bounce
                Transform.translate(
                  offset: Offset(0, sin(_bounceController.value * pi) * (_isSleeping ? 3 : 8)),
                  child: _buildPetAvatar(),
                ),
                // Zzz si esta durmiendo
                if (_isSleeping)
                  Positioned(
                    top: 40,
                    right: MediaQuery.of(context).size.width * 0.25,
                    child: Opacity(
                      opacity: 0.3 + _sleepController.value * 0.5,
                      child: Transform.translate(
                        offset: Offset(0, -_sleepController.value * 15),
                        child: const Text('💤', style: TextStyle(fontSize: 28)),
                      ),
                    ),
                  ),
                // Reaccion
                if (_showReaction)
                  Positioned(
                    top: 30,
                    child: Opacity(
                      opacity: (1 - _reactionController.value).clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, -_reactionController.value * 60),
                        child: Text(_reactionEmoji, style: const TextStyle(fontSize: 40)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Texto de toque
        if (!_isSleeping)
          Text('Toca para acariciar', style: TextStyle(fontSize: 11, color: AppColors.paleLavender.withOpacity(0.25))),
        const SizedBox(height: 12),
        // Botones de accion
        _buildActionButtons(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPetAvatar() {
    final stage = _getStage();
    double scale = stage == 'Bebe' ? 0.7 : stage == 'Pequeno' ? 0.85 : stage == 'Joven' ? 0.95 : 1.0;

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _petColor.withOpacity(_isSleeping ? 0.15 : 0.25),
          border: Border.all(
            color: _petColor.withOpacity(_isSleeping ? 0.15 : 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _petColor.withOpacity(_isSleeping ? 0.05 : 0.15),
              blurRadius: 25,
              spreadRadius: 5,
            ),
          ],
        ),
        child: CustomPaint(
          painter: _PetPainter(
            type: _petType ?? 'cat',
            color: _petColor,
            isSleeping: _isSleeping,
            happiness: _happiness,
            hygiene: _hygiene,
          ),
        ),
      ),
    );
  }

  Widget _buildStatBar(String emoji, int value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: AppColors.darkIndigo.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation(color.withOpacity(0.7)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final actions = [
      _ActionBtn(icon: Icons.restaurant_rounded, label: 'Comer', color: Colors.orange, onTap: _feedPet),
      _ActionBtn(icon: Icons.sports_tennis_rounded, label: 'Jugar', color: AppColors.shimmerGold, onTap: _playWithPet),
      _ActionBtn(icon: Icons.bathtub_rounded, label: 'Banar', color: AppColors.softLavender, onTap: _bathPet),
      _ActionBtn(icon: _isSleeping ? Icons.wb_sunny_rounded : Icons.bedtime_rounded,
          label: _isSleeping ? 'Despertar' : 'Dormir',
          color: _isSleeping ? AppColors.warmGold : AppColors.paleLavender,
          onTap: _toggleSleep),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions.map((a) {
          return GestureDetector(
            onTap: a.onTap,
            child: Column(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: a.color.withOpacity(0.12),
                    border: Border.all(color: a.color.withOpacity(0.25)),
                  ),
                  child: Icon(a.icon, color: a.color, size: 24),
                ),
                const SizedBox(height: 6),
                Text(a.label, style: TextStyle(fontSize: 10, color: a.color.withOpacity(0.6))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================
// PET PAINTER - dibuja la mascota segun tipo
// ============================================================
class _PetPainter extends CustomPainter {
  final String type;
  final Color color;
  final bool isSleeping;
  final int happiness;
  final int hygiene;

  _PetPainter({required this.type, required this.color, required this.isSleeping, required this.happiness, required this.hygiene});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final bodyPaint = Paint()..color = color;
    final darkPaint = Paint()..color = Color.lerp(color, Colors.black, 0.3)!;

    // Cuerpo principal (circulo)
    canvas.drawCircle(Offset(cx, cy + 5), 38, bodyPaint);

    switch (type) {
      case 'whale':
        // Cola
        final tailPath = Path()
          ..moveTo(cx + 30, cy + 15)
          ..quadraticBezierTo(cx + 55, cy + 5, cx + 50, cy - 10)
          ..quadraticBezierTo(cx + 55, cy + 20, cx + 45, cy + 30)
          ..quadraticBezierTo(cx + 40, cy + 20, cx + 30, cy + 15);
        canvas.drawPath(tailPath, darkPaint);
        // Chorro de agua
        if (!isSleeping) {
          final waterPaint = Paint()..color = const Color(0xFF90CAF9).withOpacity(0.5);
          canvas.drawCircle(Offset(cx, cy - 35), 3, waterPaint);
          canvas.drawCircle(Offset(cx - 5, cy - 42), 2.5, waterPaint);
          canvas.drawCircle(Offset(cx + 5, cy - 42), 2.5, waterPaint);
        }
        break;
      case 'owl':
        // Orejas/plumas
        final earPath = Path()
          ..moveTo(cx - 20, cy - 25)
          ..lineTo(cx - 28, cy - 45)
          ..lineTo(cx - 10, cy - 30);
        canvas.drawPath(earPath, darkPaint);
        final earPath2 = Path()
          ..moveTo(cx + 20, cy - 25)
          ..lineTo(cx + 28, cy - 45)
          ..lineTo(cx + 10, cy - 30);
        canvas.drawPath(earPath2, darkPaint);
        // Pico
        final beakPaint = Paint()..color = const Color(0xFFFFB74D);
        final beakPath = Path()
          ..moveTo(cx - 5, cy + 5)
          ..lineTo(cx, cy + 12)
          ..lineTo(cx + 5, cy + 5);
        canvas.drawPath(beakPath, beakPaint);
        break;
      case 'dog':
        // Orejas caidas
        canvas.drawOval(Rect.fromCenter(center: Offset(cx - 30, cy - 5), width: 20, height: 35), darkPaint);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx + 30, cy - 5), width: 20, height: 35), darkPaint);
        // Nariz
        canvas.drawCircle(Offset(cx, cy + 8), 5, Paint()..color = const Color(0xFF5D4037));
        // Lengua
        if (!isSleeping && happiness > 50) {
          canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 18), width: 8, height: 10), Paint()..color = const Color(0xFFEF9A9A));
        }
        break;
      case 'cat':
        // Orejas puntiagudas
        final earL = Path()..moveTo(cx - 22, cy - 22)..lineTo(cx - 32, cy - 48)..lineTo(cx - 8, cy - 28)..close();
        final earR = Path()..moveTo(cx + 22, cy - 22)..lineTo(cx + 32, cy - 48)..lineTo(cx + 8, cy - 28)..close();
        canvas.drawPath(earL, bodyPaint);
        canvas.drawPath(earR, bodyPaint);
        // Interior orejas
        final innerEarPaint = Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.5);
        final iearL = Path()..moveTo(cx - 22, cy - 24)..lineTo(cx - 28, cy - 42)..lineTo(cx - 12, cy - 28)..close();
        final iearR = Path()..moveTo(cx + 22, cy - 24)..lineTo(cx + 28, cy - 42)..lineTo(cx + 12, cy - 28)..close();
        canvas.drawPath(iearL, innerEarPaint);
        canvas.drawPath(iearR, innerEarPaint);
        // Bigotes
        final whiskerPaint = Paint()..color = Colors.white.withOpacity(0.4)..strokeWidth = 1;
        canvas.drawLine(Offset(cx - 15, cy + 5), Offset(cx - 40, cy), whiskerPaint);
        canvas.drawLine(Offset(cx - 15, cy + 8), Offset(cx - 40, cy + 10), whiskerPaint);
        canvas.drawLine(Offset(cx + 15, cy + 5), Offset(cx + 40, cy), whiskerPaint);
        canvas.drawLine(Offset(cx + 15, cy + 8), Offset(cx + 40, cy + 10), whiskerPaint);
        // Nariz
        final nosePath = Path()..moveTo(cx, cy + 5)..lineTo(cx - 4, cy + 1)..lineTo(cx + 4, cy + 1)..close();
        canvas.drawPath(nosePath, Paint()..color = const Color(0xFFFF8FAB));
        break;
      case 'bunny':
        // Orejas largas
        canvas.drawOval(Rect.fromCenter(center: Offset(cx - 14, cy - 50), width: 16, height: 40), bodyPaint);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx + 14, cy - 50), width: 16, height: 40), bodyPaint);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx - 14, cy - 50), width: 8, height: 30), Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.4));
        canvas.drawOval(Rect.fromCenter(center: Offset(cx + 14, cy - 50), width: 8, height: 30), Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.4));
        // Nariz
        canvas.drawCircle(Offset(cx, cy + 5), 4, Paint()..color = const Color(0xFFFF8FAB));
        break;
      case 'hamster':
        // Cachetes gordos
        canvas.drawCircle(Offset(cx - 28, cy + 5), 15, Paint()..color = Color.lerp(color, const Color(0xFFFF8FAB), 0.3)!);
        canvas.drawCircle(Offset(cx + 28, cy + 5), 15, Paint()..color = Color.lerp(color, const Color(0xFFFF8FAB), 0.3)!);
        // Orejas redondas
        canvas.drawCircle(Offset(cx - 25, cy - 28), 10, darkPaint);
        canvas.drawCircle(Offset(cx + 25, cy - 28), 10, darkPaint);
        canvas.drawCircle(Offset(cx - 25, cy - 28), 6, Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.4));
        canvas.drawCircle(Offset(cx + 25, cy - 28), 6, Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.4));
        // Nariz
        canvas.drawCircle(Offset(cx, cy + 5), 3, Paint()..color = const Color(0xFFFF8FAB));
        break;
    }

    // Ojos (para todos)
    final eyePaint = Paint()..color = const Color(0xFF1A1A1A);
    if (isSleeping) {
      final closedPaint = Paint()..color = const Color(0xFF1A1A1A)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCenter(center: Offset(cx - 12, cy - 8), width: 10, height: 8), 0, -pi, false, closedPaint);
      canvas.drawArc(Rect.fromCenter(center: Offset(cx + 12, cy - 8), width: 10, height: 8), 0, -pi, false, closedPaint);
    } else {
      canvas.drawCircle(Offset(cx - 12, cy - 8), 5, eyePaint);
      canvas.drawCircle(Offset(cx + 12, cy - 8), 5, eyePaint);
      // Brillos
      canvas.drawCircle(Offset(cx - 10, cy - 10), 2, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(cx + 14, cy - 10), 1.5, Paint()..color = Colors.white);
    }

    // Boca
    if (!isSleeping) {
      final smilePaint = Paint()..color = const Color(0xFF1A1A1A)..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round;
      if (happiness > 60) {
        canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + 12), width: 14, height: 10), 0, pi, false, smilePaint);
      } else if (happiness > 30) {
        canvas.drawLine(Offset(cx - 5, cy + 14), Offset(cx + 5, cy + 14), smilePaint);
      } else {
        canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + 18), width: 12, height: 8), 0, -pi, false, smilePaint);
      }
    }

    // Manchas de suciedad
    if (hygiene < 40) {
      final dirtPaint = Paint()..color = const Color(0xFF795548).withOpacity(0.3);
      canvas.drawCircle(Offset(cx + 20, cy + 15), 5, dirtPaint);
      canvas.drawCircle(Offset(cx - 18, cy + 20), 4, dirtPaint);
      canvas.drawCircle(Offset(cx + 5, cy + 25), 3, dirtPaint);
    }

    // Rubor
    if (happiness > 70 && !isSleeping) {
      canvas.drawCircle(Offset(cx - 22, cy + 2), 6, Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.25));
      canvas.drawCircle(Offset(cx + 22, cy + 2), 6, Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.25));
    }
  }

  @override
  bool shouldRepaint(covariant _PetPainter old) => true;
}

// ============================================================
// MODELOS
// ============================================================
class _PetOption {
  final String type, name, desc;
  final IconData icon;
  final Color color;
  const _PetOption({required this.type, required this.name, required this.icon, required this.color, required this.desc});
}

class _ColorOption {
  final String name;
  final Color color;
  const _ColorOption({required this.name, required this.color});
}

class _ActionBtn {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.color, required this.onTap});
}
ENDOFFILE

echo "  Creado: lib/features/pet/pet_screen.dart"

# Agregar import y seccion al home
sed -i '' "s|import '../canvas/canvas_screen.dart';|import '../canvas/canvas_screen.dart';\nimport '../pet/pet_screen.dart';|" lib/features/home/home_screen.dart 2>/dev/null || sed -i "s|import '../canvas/canvas_screen.dart';|import '../canvas/canvas_screen.dart';\nimport '../pet/pet_screen.dart';|" lib/features/home/home_screen.dart

sed -i '' "s|screen: const CanvasScreen(),|screen: const CanvasScreen(),\n    ),\n    _SectionData(\n      title: 'Nuestra Mascota',\n      subtitle: 'Cuida a tu companero',\n      icon: Icons.pets_rounded,\n      color: AppColors.warmGold,\n      screen: const PetScreen(),|" lib/features/home/home_screen.dart 2>/dev/null || sed -i "s|screen: const CanvasScreen(),|screen: const CanvasScreen(),\n    ),\n    _SectionData(\n      title: 'Nuestra Mascota',\n      subtitle: 'Cuida a tu companero',\n      icon: Icons.pets_rounded,\n      color: AppColors.warmGold,\n      screen: const PetScreen(),|" lib/features/home/home_screen.dart

echo "  Actualizado: home_screen.dart"
echo ""
echo "IMPORTANTE: Agrega esta dependencia a tu pubspec.yaml:"
echo "  dependencies:"
echo "    shared_preferences: ^2.2.3"
echo ""
echo "Luego ejecuta: flutter pub get && flutter run"
