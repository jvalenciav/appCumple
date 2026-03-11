#!/bin/bash
# ================================================================
# REESCRIBIR COMPLETO: pet_screen.dart con mejor diseno,
# cambiar mascota, accesorios, y visual mejorado
# Ejecuta desde la raiz de cynthia_app/: bash fix_pet_full.sh
# ================================================================

echo "Reescribiendo mascota virtual completa..."

mkdir -p lib/features/pet

cat > lib/features/pet/pet_screen.dart << 'ENDOFFILE'
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> with TickerProviderStateMixin {
  String? _petType;
  String _petName = '';
  Color _petColor = Colors.white;
  int _hunger = 80;
  int _happiness = 80;
  int _energy = 80;
  int _hygiene = 80;
  int _age = 0;
  bool _isSleeping = false;
  bool _petSelected = false;
  String _accessory = 'none';
  DateTime? _lastInteraction;

  late AnimationController _bounceController;
  late AnimationController _entranceController;
  late AnimationController _reactionController;
  late AnimationController _sleepController;
  late AnimationController _pulseController;
  String _reactionEmoji = '';
  bool _showReaction = false;
  bool _showAccessoryPicker = false;

  final List<_PetOption> _catalog = [
    _PetOption(type: 'whale', name: 'Ballenita', emoji: '🐋', color: AppColors.electricBlue, desc: 'Tu simbolo'),
    _PetOption(type: 'owl', name: 'Buhito', emoji: '🦉', color: AppColors.shimmerGold, desc: 'Mi simbolo'),
    _PetOption(type: 'dog', name: 'Perrito', emoji: '🐶', color: AppColors.warmGold, desc: 'Nos encantan'),
    _PetOption(type: 'cat', name: 'Gatito', emoji: '🐱', color: AppColors.softLavender, desc: 'Como los tuyos'),
    _PetOption(type: 'bunny', name: 'Conejito', emoji: '🐰', color: AppColors.roseGold, desc: 'Suavecito'),
    _PetOption(type: 'hamster', name: 'Hamster', emoji: '🐹', color: AppColors.paleLavender, desc: 'Chiquito'),
  ];

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

  final List<_AccessoryOption> _accessories = [
    _AccessoryOption(id: 'none', name: 'Ninguno', emoji: ''),
    _AccessoryOption(id: 'bow', name: 'Moño', emoji: '🎀'),
    _AccessoryOption(id: 'crown', name: 'Corona', emoji: '👑'),
    _AccessoryOption(id: 'hat', name: 'Gorrito', emoji: '🎩'),
    _AccessoryOption(id: 'glasses', name: 'Lentes', emoji: '🤓'),
    _AccessoryOption(id: 'flower', name: 'Flor', emoji: '🌸'),
    _AccessoryOption(id: 'heart', name: 'Corazon', emoji: '❤️'),
    _AccessoryOption(id: 'star', name: 'Estrella', emoji: '⭐'),
    _AccessoryOption(id: 'scarf', name: 'Bufanda', emoji: '🧣'),
  ];

  int _selectedColorIndex = 0;
  int _catalogPage = 0;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat(reverse: true);
    _entranceController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..forward();
    _reactionController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _sleepController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
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
        _accessory = prefs.getString('pet_accessory') ?? 'none';
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
    final hours = DateTime.now().difference(_lastInteraction!).inHours;
    if (hours > 0) {
      setState(() {
        _hunger = (_hunger - hours * 3).clamp(0, 100);
        _happiness = (_happiness - hours * 2).clamp(0, 100);
        _energy = _isSleeping ? (_energy + hours * 5).clamp(0, 100) : (_energy - hours * 2).clamp(0, 100);
        _hygiene = (_hygiene - hours * 1).clamp(0, 100);
        _age = DateTime.now().difference(DateTime(2026, 3, 1)).inDays.clamp(0, 9999);
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
    prefs.setString('pet_accessory', _accessory);
    prefs.setString('pet_last_interaction', DateTime.now().toIso8601String());
  }

  void _selectPet(String type) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Dale un nombre a tu mascota'), backgroundColor: AppColors.darkIndigo),
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
      _accessory = 'none';
      _lastInteraction = DateTime.now();
    });
    _savePet();
    HapticFeedback.mediumImpact();
  }

  void _changePet() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkIndigo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cambiar mascota?', style: TextStyle(color: AppColors.starWhite, fontSize: 16)),
        content: Text('Tu mascota actual se ira. Quieres elegir una nueva?',
            style: TextStyle(color: AppColors.paleLavender.withOpacity(0.7), fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('No', style: TextStyle(color: AppColors.paleLavender.withOpacity(0.5))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _petSelected = false;
                _nameController.clear();
              });
            },
            child: const Text('Si, cambiar', style: TextStyle(color: AppColors.roseGold)),
          ),
        ],
      ),
    );
  }

  void _feedPet() {
    if (_isSleeping) return;
    setState(() { _hunger = (_hunger + 25).clamp(0, 100); _happiness = (_happiness + 5).clamp(0, 100); });
    _showReactionAnim('🍖'); _savePet();
  }

  void _petPet() {
    if (_isSleeping) return;
    setState(() { _happiness = (_happiness + 20).clamp(0, 100); });
    _showReactionAnim('💕'); HapticFeedback.lightImpact(); _savePet();
  }

  void _playWithPet() {
    if (_isSleeping) return;
    if (_energy < 15) { _showReactionAnim('😴'); return; }
    setState(() { _happiness = (_happiness + 20).clamp(0, 100); _energy = (_energy - 15).clamp(0, 100); _hunger = (_hunger - 10).clamp(0, 100); });
    _showReactionAnim('🎾'); _savePet();
  }

  void _bathPet() {
    if (_isSleeping) return;
    setState(() { _hygiene = 100; _happiness = (_happiness + 5).clamp(0, 100); });
    _showReactionAnim('🫧'); _savePet();
  }

  void _toggleSleep() {
    setState(() { _isSleeping = !_isSleeping; });
    if (_isSleeping) {
      _sleepController.repeat(reverse: true);
      _showReactionAnim('💤');
    } else {
      _sleepController.stop(); _sleepController.reset();
      setState(() { _energy = (_energy + 30).clamp(0, 100); });
      _showReactionAnim('☀️');
    }
    _savePet();
  }

  void _setAccessory(String id) {
    setState(() { _accessory = id; _showAccessoryPicker = false; });
    HapticFeedback.selectionClick();
    _savePet();
  }

  void _showReactionAnim(String emoji) {
    setState(() { _reactionEmoji = emoji; _showReaction = true; });
    _reactionController.forward(from: 0).then((_) { if (mounted) setState(() => _showReaction = false); });
  }

  String _getMood() {
    final avg = (_hunger + _happiness + _energy + _hygiene) / 4;
    if (_isSleeping) return 'Durmiendo... zzz';
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
    _bounceController.dispose(); _entranceController.dispose();
    _reactionController.dispose(); _sleepController.dispose();
    _pulseController.dispose(); _nameController.dispose();
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
            animation: Listenable.merge([_entranceController, _bounceController, _reactionController, _sleepController, _pulseController]),
            builder: (context, _) {
              return Column(
                children: [
                  _buildAppBar(),
                  Expanded(child: _petSelected ? _buildPetView() : _buildCatalog()),
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
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.darkIndigo.withOpacity(0.5),
                border: Border.all(color: AppColors.softLavender.withOpacity(0.2))),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.starWhite),
            ),
          ),
          Expanded(
            child: Text(_petSelected ? _petName : 'Elige tu Mascota',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.starWhite, letterSpacing: 1)),
          ),
          if (_petSelected)
            GestureDetector(
              onTap: _changePet,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.darkIndigo.withOpacity(0.5),
                  border: Border.all(color: AppColors.roseGold.withOpacity(0.2))),
                child: Icon(Icons.swap_horiz_rounded, size: 18, color: AppColors.roseGold.withOpacity(0.7)),
              ),
            )
          else
            const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildCatalog() {
    final fade = CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);
    return Opacity(
      opacity: fade.value,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text('Escoge a tu companero', style: TextStyle(fontSize: 14, color: AppColors.paleLavender.withOpacity(0.5), fontStyle: FontStyle.italic)),
            const SizedBox(height: 20),
            // Grid de mascotas con emojis grandes
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.75),
              itemCount: _catalog.length,
              itemBuilder: (ctx, i) {
                final pet = _catalog[i];
                final isSelected = _catalogPage == i;
                return GestureDetector(
                  onTap: () => setState(() => _catalogPage = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: isSelected ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [pet.color.withOpacity(0.2), AppColors.darkIndigo.withOpacity(0.6)]) : null,
                      color: isSelected ? null : AppColors.darkIndigo.withOpacity(0.3),
                      border: Border.all(color: isSelected ? pet.color.withOpacity(0.5) : AppColors.paleLavender.withOpacity(0.08), width: isSelected ? 2 : 1),
                      boxShadow: isSelected ? [BoxShadow(color: pet.color.withOpacity(0.15), blurRadius: 12)] : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(pet.emoji, style: const TextStyle(fontSize: 36)),
                        const SizedBox(height: 6),
                        Text(pet.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? AppColors.starWhite : AppColors.paleLavender.withOpacity(0.6))),
                        Text(pet.desc, style: TextStyle(fontSize: 9, color: pet.color.withOpacity(isSelected ? 0.7 : 0.3))),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Color
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColors.darkIndigo.withOpacity(0.3),
                border: Border.all(color: AppColors.paleLavender.withOpacity(0.08))),
              child: Column(
                children: [
                  Text('Color de tu mascota', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.paleLavender.withOpacity(0.5))),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10, runSpacing: 10, alignment: WrapAlignment.center,
                    children: _colorOptions.asMap().entries.map((e) {
                      final isSelected = _selectedColorIndex == e.key;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColorIndex = e.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 38, height: 38,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: e.value.color,
                            border: Border.all(color: isSelected ? AppColors.starWhite : Colors.transparent, width: isSelected ? 3 : 0),
                            boxShadow: isSelected ? [BoxShadow(color: e.value.color.withOpacity(0.4), blurRadius: 8)] : null),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Nombre
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColors.darkIndigo.withOpacity(0.4),
                border: Border.all(color: AppColors.paleLavender.withOpacity(0.12))),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.starWhite, fontSize: 16),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Nombre de tu mascota', hintStyle: TextStyle(color: AppColors.paleLavender.withOpacity(0.25)), border: InputBorder.none,
                  prefixIcon: Icon(Icons.edit_rounded, size: 18, color: AppColors.paleLavender.withOpacity(0.2)),
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
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(colors: [_catalog[_catalogPage].color.withOpacity(0.3), AppColors.darkIndigo.withOpacity(0.5)]),
                  border: Border.all(color: _catalog[_catalogPage].color.withOpacity(0.4), width: 1.5),
                  boxShadow: [BoxShadow(color: _catalog[_catalogPage].color.withOpacity(0.15), blurRadius: 12)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_catalog[_catalogPage].emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 10),
                    Text('Adoptar ${_catalog[_catalogPage].name}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.starWhite, letterSpacing: 0.5)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPetView() {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 6),
            // Mood y edad en card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: AppColors.darkIndigo.withOpacity(0.4),
                  border: Border.all(color: AppColors.paleLavender.withOpacity(0.08))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(_isSleeping ? Icons.bedtime_rounded : Icons.mood_rounded, size: 16,
                        color: _isSleeping ? AppColors.paleLavender.withOpacity(0.4) : AppColors.shimmerGold.withOpacity(0.6)),
                      const SizedBox(width: 6),
                      Text(_getMood(), style: TextStyle(fontSize: 12, color: AppColors.shimmerGold.withOpacity(0.6), fontStyle: FontStyle.italic)),
                    ]),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.darkIndigo.withOpacity(0.5)),
                      child: Text('${_getStage()} | ${_getAgeText()}', style: TextStyle(fontSize: 10, color: AppColors.paleLavender.withOpacity(0.4))),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Barras de estado mejoradas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatBar('🍖', 'Hambre', _hunger, Colors.orange),
                  const SizedBox(width: 6),
                  _buildStatBar('💕', 'Amor', _happiness, AppColors.roseGold),
                  const SizedBox(width: 6),
                  _buildStatBar('⚡', 'Energia', _energy, AppColors.electricBlue),
                  const SizedBox(width: 6),
                  _buildStatBar('🫧', 'Higiene', _hygiene, AppColors.softLavender),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Mascota grande
            Expanded(
              child: GestureDetector(
                onTap: _petPet,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow debajo de mascota
                    Container(
                      width: 120, height: 30,
                      margin: const EdgeInsets.only(top: 140),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [BoxShadow(color: _petColor.withOpacity(0.1 + _pulseController.value * 0.05), blurRadius: 30, spreadRadius: 10)],
                      ),
                    ),
                    // Mascota con bounce
                    Transform.translate(
                      offset: Offset(0, sin(_bounceController.value * pi) * (_isSleeping ? 3 : 8)),
                      child: _buildPetAvatar(),
                    ),
                    // Zzz
                    if (_isSleeping)
                      Positioned(
                        top: 20,
                        right: MediaQuery.of(context).size.width * 0.22,
                        child: Opacity(
                          opacity: 0.3 + _sleepController.value * 0.5,
                          child: Transform.translate(
                            offset: Offset(0, -_sleepController.value * 20),
                            child: const Text('💤', style: TextStyle(fontSize: 30)),
                          ),
                        ),
                      ),
                    // Reaccion
                    if (_showReaction)
                      Positioned(
                        top: 10,
                        child: Opacity(
                          opacity: (1 - _reactionController.value).clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, -_reactionController.value * 70),
                            child: Transform.scale(
                              scale: 1.0 + _reactionController.value * 0.3,
                              child: Text(_reactionEmoji, style: const TextStyle(fontSize: 44)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (!_isSleeping)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('Toca para acariciar', style: TextStyle(fontSize: 10, color: AppColors.paleLavender.withOpacity(0.2), letterSpacing: 1)),
              ),
            // Botones de accion
            _buildActionButtons(),
            const SizedBox(height: 16),
          ],
        ),
        // Accessory picker overlay
        if (_showAccessoryPicker) _buildAccessoryPicker(),
      ],
    );
  }

  Widget _buildPetAvatar() {
    final stage = _getStage();
    double scale = stage == 'Bebe' ? 0.65 : stage == 'Pequeno' ? 0.8 : stage == 'Joven' ? 0.9 : 1.0;

    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Fondo circular con gradiente
            Container(
              width: 150, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [_petColor.withOpacity(_isSleeping ? 0.08 : 0.15), _petColor.withOpacity(0.02)]),
                border: Border.all(color: _petColor.withOpacity(_isSleeping ? 0.08 : 0.2), width: 1.5),
                boxShadow: [BoxShadow(color: _petColor.withOpacity(_isSleeping ? 0.03 : 0.1), blurRadius: 25, spreadRadius: 5)],
              ),
              child: CustomPaint(
                painter: _PetPainter(type: _petType ?? 'cat', color: _petColor, isSleeping: _isSleeping,
                  happiness: _happiness, hygiene: _hygiene, accessory: _accessory),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(String emoji, String label, int value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.darkIndigo.withOpacity(0.3),
          border: Border.all(color: color.withOpacity(value < 30 ? 0.4 : 0.08)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: 5, width: double.infinity,
                child: LinearProgressIndicator(
                  value: value / 100,
                  backgroundColor: AppColors.darkIndigo.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation(value < 30 ? Colors.red.withOpacity(0.7) : color.withOpacity(0.7)),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text('$value%', style: TextStyle(fontSize: 9, color: color.withOpacity(0.5), fontFamily: 'monospace')),
          ],
        ),
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
        color: _isSleeping ? AppColors.warmGold : AppColors.paleLavender, onTap: _toggleSleep),
      _ActionBtn(icon: Icons.checkroom_rounded, label: 'Accesorios', color: AppColors.roseGold,
        onTap: () => setState(() => _showAccessoryPicker = !_showAccessoryPicker)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions.map((a) {
          return GestureDetector(
            onTap: a.onTap,
            child: Column(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [a.color.withOpacity(0.15), AppColors.darkIndigo.withOpacity(0.3)]),
                    border: Border.all(color: a.color.withOpacity(0.25)),
                  ),
                  child: Icon(a.icon, color: a.color, size: 22),
                ),
                const SizedBox(height: 5),
                Text(a.label, style: TextStyle(fontSize: 9, color: a.color.withOpacity(0.6), letterSpacing: 0.3)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccessoryPicker() {
    return Positioned(
      bottom: 100, left: 16, right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.darkIndigo.withOpacity(0.95),
          border: Border.all(color: AppColors.roseGold.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Accesorios', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.roseGold.withOpacity(0.7), letterSpacing: 1)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
              children: _accessories.map((acc) {
                final isSelected = _accessory == acc.id;
                return GestureDetector(
                  onTap: () => _setAccessory(acc.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isSelected ? AppColors.roseGold.withOpacity(0.15) : AppColors.darkIndigo.withOpacity(0.4),
                      border: Border.all(color: isSelected ? AppColors.roseGold.withOpacity(0.5) : AppColors.paleLavender.withOpacity(0.08)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(acc.id == 'none' ? '❌' : acc.emoji, style: const TextStyle(fontSize: 22)),
                        Text(acc.name, style: TextStyle(fontSize: 8, color: AppColors.paleLavender.withOpacity(0.4))),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PET PAINTER
// ============================================================
class _PetPainter extends CustomPainter {
  final String type;
  final Color color;
  final bool isSleeping;
  final int happiness;
  final int hygiene;
  final String accessory;

  _PetPainter({required this.type, required this.color, required this.isSleeping,
    required this.happiness, required this.hygiene, required this.accessory});

  Color get _dark => Color.lerp(color, Colors.black, 0.25)!;
  Color get _light => Color.lerp(color, Colors.white, 0.3)!;
  Color get _veryLight => Color.lerp(color, Colors.white, 0.5)!;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Sombra
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 42), width: 55, height: 10), Paint()..color = Colors.black.withOpacity(0.1));

    switch (type) {
      case 'cat': _drawCat(canvas, cx, cy); break;
      case 'dog': _drawDog(canvas, cx, cy); break;
      case 'owl': _drawOwl(canvas, cx, cy); break;
      case 'whale': _drawWhale(canvas, cx, cy); break;
      case 'bunny': _drawBunny(canvas, cx, cy); break;
      case 'hamster': _drawHamster(canvas, cx, cy); break;
    }

    if (hygiene < 40) {
      final d = Paint()..color = const Color(0xFF795548).withOpacity(0.2);
      canvas.drawOval(Rect.fromCenter(center: Offset(cx + 20, cy + 16), width: 10, height: 7), d);
      canvas.drawOval(Rect.fromCenter(center: Offset(cx - 18, cy + 20), width: 8, height: 6), d);
    }

    _drawAccessory(canvas, cx, cy);
  }

  void _drawEyes(Canvas canvas, double cx, double cy, {double spacing = 12, double sz = 5.5, double yOff = 0}) {
    if (isSleeping) {
      final p = Paint()..color = const Color(0xFF1A1A2E)..style = PaintingStyle.stroke..strokeWidth = 2.2..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCenter(center: Offset(cx - spacing, cy + yOff), width: sz * 2, height: sz * 1.4), 0, -3.14159, false, p);
      canvas.drawArc(Rect.fromCenter(center: Offset(cx + spacing, cy + yOff), width: sz * 2, height: sz * 1.4), 0, -3.14159, false, p);
    } else {
      final ep = Paint()..color = const Color(0xFF1A1A2E);
      canvas.drawCircle(Offset(cx - spacing, cy + yOff), sz, ep);
      canvas.drawCircle(Offset(cx + spacing, cy + yOff), sz, ep);
      final wp = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(cx - spacing + 1.5, cy + yOff - 1.5), sz * 0.38, wp);
      canvas.drawCircle(Offset(cx + spacing + 1.5, cy + yOff - 1.5), sz * 0.38, wp);
      canvas.drawCircle(Offset(cx - spacing - 0.8, cy + yOff + 1.2), sz * 0.18, Paint()..color = Colors.white.withOpacity(0.5));
      canvas.drawCircle(Offset(cx + spacing - 0.8, cy + yOff + 1.2), sz * 0.18, Paint()..color = Colors.white.withOpacity(0.5));
    }
  }

  void _drawBlush(Canvas canvas, double cx, double cy, {double sp = 20, double yOff = 5}) {
    if (happiness > 65 && !isSleeping) {
      canvas.drawOval(Rect.fromCenter(center: Offset(cx - sp, cy + yOff), width: 11, height: 6), Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.28));
      canvas.drawOval(Rect.fromCenter(center: Offset(cx + sp, cy + yOff), width: 11, height: 6), Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.28));
    }
  }

  void _drawMouth(Canvas canvas, double cx, double cy, {double yOff = 15}) {
    if (isSleeping) return;
    final p = Paint()..color = const Color(0xFF1A1A2E)..style = PaintingStyle.stroke..strokeWidth = 1.6..strokeCap = StrokeCap.round;
    if (happiness > 60) canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + yOff), width: 13, height: 9), 0, 3.14159, false, p);
    else if (happiness > 30) canvas.drawLine(Offset(cx - 4, cy + yOff), Offset(cx + 4, cy + yOff), p);
    else canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + yOff + 3), width: 11, height: 7), 0, -3.14159, false, p);
  }

  void _drawAccessory(Canvas canvas, double cx, double cy) {
    switch (accessory) {
      case 'bow':
        final p = Paint()..color = const Color(0xFFFF4081);
        final path = Path()..moveTo(cx, cy - 38)..lineTo(cx - 12, cy - 46)..quadraticBezierTo(cx - 14, cy - 38, cx, cy - 38)
          ..lineTo(cx + 12, cy - 46)..quadraticBezierTo(cx + 14, cy - 38, cx, cy - 38);
        canvas.drawPath(path, p);
        canvas.drawCircle(Offset(cx, cy - 38), 3, Paint()..color = const Color(0xFFFF80AB));
        break;
      case 'crown':
        final p = Paint()..color = const Color(0xFFFFD700);
        final path = Path()..moveTo(cx - 16, cy - 36)..lineTo(cx - 14, cy - 50)..lineTo(cx - 6, cy - 42)
          ..lineTo(cx, cy - 52)..lineTo(cx + 6, cy - 42)..lineTo(cx + 14, cy - 50)..lineTo(cx + 16, cy - 36)..close();
        canvas.drawPath(path, p);
        canvas.drawCircle(Offset(cx, cy - 48), 2, Paint()..color = const Color(0xFFFF1744));
        break;
      case 'hat':
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 36), width: 40, height: 8), Paint()..color = const Color(0xFF1A1A2E));
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 12, cy - 56, 24, 22), const Radius.circular(4)), Paint()..color = const Color(0xFF1A1A2E));
        canvas.drawRect(Rect.fromLTWH(cx - 12, cy - 40, 24, 4), Paint()..color = const Color(0xFFFF4081));
        break;
      case 'glasses':
        final gp = Paint()..color = const Color(0xFF1A1A2E)..style = PaintingStyle.stroke..strokeWidth = 2;
        canvas.drawCircle(Offset(cx - 12, cy - 8), 9, gp);
        canvas.drawCircle(Offset(cx + 12, cy - 8), 9, gp);
        canvas.drawLine(Offset(cx - 3, cy - 8), Offset(cx + 3, cy - 8), gp);
        final lp = Paint()..color = const Color(0xFF90CAF9).withOpacity(0.15);
        canvas.drawCircle(Offset(cx - 12, cy - 8), 8, lp);
        canvas.drawCircle(Offset(cx + 12, cy - 8), 8, lp);
        break;
      case 'flower':
        final fc = const Color(0xFFFF8FAB);
        for (int i = 0; i < 5; i++) {
          final angle = (i * 72) * 3.14159 / 180;
          canvas.drawCircle(Offset(cx + 22 + cos(angle) * 6, cy - 28 + sin(angle) * 6), 4, Paint()..color = fc);
        }
        canvas.drawCircle(Offset(cx + 22, cy - 28), 3, Paint()..color = const Color(0xFFFFEB3B));
        break;
      case 'heart':
        final hp = Paint()..color = const Color(0xFFFF1744);
        final path = Path();
        final hx = cx + 22; final hy = cy - 32; final w = 7.0;
        path.moveTo(hx, hy + w * 0.6);
        path.cubicTo(hx - w * 1.1, hy - w * 0.1, hx - w * 0.5, hy - w * 1, hx, hy - w * 0.3);
        path.cubicTo(hx + w * 0.5, hy - w * 1, hx + w * 1.1, hy - w * 0.1, hx, hy + w * 0.6);
        canvas.drawPath(path, hp);
        break;
      case 'star':
        final sp = Paint()..color = const Color(0xFFFFD700);
        final path = Path();
        for (int i = 0; i < 5; i++) {
          final outerA = -3.14159 / 2 + (i * 2 * 3.14159 / 5);
          final innerA = outerA + 3.14159 / 5;
          final ox = cx + 22 + cos(outerA) * 8;
          final oy = cy - 32 + sin(outerA) * 8;
          final ix = cx + 22 + cos(innerA) * 3.5;
          final iy = cy - 32 + sin(innerA) * 3.5;
          if (i == 0) path.moveTo(ox, oy); else path.lineTo(ox, oy);
          path.lineTo(ix, iy);
        }
        path.close();
        canvas.drawPath(path, sp);
        break;
      case 'scarf':
        final sc = Paint()..color = const Color(0xFFFF4081);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 22, cy + 24, 44, 8), const Radius.circular(4)), sc);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx + 10, cy + 30, 10, 18), const Radius.circular(4)), sc);
        final stripe = Paint()..color = Colors.white.withOpacity(0.2);
        canvas.drawRect(Rect.fromLTWH(cx - 18, cy + 27, 36, 2), stripe);
        break;
    }
  }

  void _drawCat(Canvas canvas, double cx, double cy) {
    final tp = Paint()..color = _dark..style = PaintingStyle.stroke..strokeWidth = 6..strokeCap = StrokeCap.round;
    canvas.drawPath(Path()..moveTo(cx + 25, cy + 20)..cubicTo(cx + 50, cy + 12, cx + 52, cy - 10, cx + 42, cy - 20), tp);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 14), width: 56, height: 42), Paint()..color = color);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 21, cy + 25, 13, 16), const Radius.circular(6)), Paint()..color = color);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx + 8, cy + 25, 13, 16), const Radius.circular(6)), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 14, cy + 40), width: 11, height: 6), Paint()..color = _veryLight);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 14, cy + 40), width: 11, height: 6), Paint()..color = _veryLight);
    canvas.drawCircle(Offset(cx, cy - 10), 28, Paint()..color = color);
    final el = Path()..moveTo(cx - 22, cy - 26)..lineTo(cx - 32, cy - 52)..lineTo(cx - 8, cy - 32)..close();
    final er = Path()..moveTo(cx + 22, cy - 26)..lineTo(cx + 32, cy - 52)..lineTo(cx + 8, cy - 32)..close();
    canvas.drawPath(el, Paint()..color = color); canvas.drawPath(er, Paint()..color = color);
    final iel = Path()..moveTo(cx - 20, cy - 28)..lineTo(cx - 28, cy - 47)..lineTo(cx - 12, cy - 32)..close();
    final ier = Path()..moveTo(cx + 20, cy - 28)..lineTo(cx + 28, cy - 47)..lineTo(cx + 12, cy - 32)..close();
    canvas.drawPath(iel, Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.35));
    canvas.drawPath(ier, Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.35));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 18), width: 13, height: 7), Paint()..color = _light.withOpacity(0.25));
    final wp = Paint()..color = Colors.white.withOpacity(0.4)..strokeWidth = 0.8..strokeCap = StrokeCap.round;
    for (final dy in [-3.0, 0.0, 3.0]) {
      canvas.drawLine(Offset(cx - 13, cy + dy), Offset(cx - 40, cy + dy - 4), wp);
      canvas.drawLine(Offset(cx + 13, cy + dy), Offset(cx + 40, cy + dy - 4), wp);
    }
    canvas.drawPath(Path()..moveTo(cx, cy + 1)..lineTo(cx - 4, cy - 3)..lineTo(cx + 4, cy - 3)..close(), Paint()..color = const Color(0xFFFF8FAB));
    _drawEyes(canvas, cx, cy, yOff: -12, spacing: 11);
    _drawBlush(canvas, cx, cy, yOff: -2, sp: 21);
    _drawMouth(canvas, cx, cy, yOff: 5);
  }

  void _drawDog(Canvas canvas, double cx, double cy) {
    final tp = Paint()..color = _dark..style = PaintingStyle.stroke..strokeWidth = 7..strokeCap = StrokeCap.round;
    canvas.drawPath(Path()..moveTo(cx + 22, cy + 8)..cubicTo(cx + 38, cy - 5, cx + 46, cy - 25, cx + 36, cy - 33), tp);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 14), width: 58, height: 40), Paint()..color = color);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 23, cy + 24, 15, 18), const Radius.circular(7)), Paint()..color = color);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx + 8, cy + 24, 15, 18), const Radius.circular(7)), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 15, cy + 41), width: 12, height: 7), Paint()..color = _veryLight);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 15, cy + 41), width: 12, height: 7), Paint()..color = _veryLight);
    canvas.drawCircle(Offset(cx, cy - 10), 30, Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 28, cy - 6), width: 20, height: 36), Paint()..color = _dark);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 28, cy - 6), width: 20, height: 36), Paint()..color = _dark);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 26, height: 20), Paint()..color = _light);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 3), width: 10, height: 7), Paint()..color = const Color(0xFF3E2723));
    canvas.drawCircle(Offset(cx - 1.5, cy - 4.5), 1.8, Paint()..color = Colors.white.withOpacity(0.3));
    if (!isSleeping && happiness > 50) {
      canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 11), width: 8, height: 12), Paint()..color = const Color(0xFFEF9A9A));
    }
    _drawEyes(canvas, cx, cy, yOff: -14, spacing: 13, sz: 5);
    _drawBlush(canvas, cx, cy, yOff: 0, sp: 23);
    _drawMouth(canvas, cx, cy, yOff: 6);
  }

  void _drawOwl(Canvas canvas, double cx, double cy) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 8), width: 52, height: 56), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 16), width: 32, height: 32), Paint()..color = _veryLight.withOpacity(0.35));
    final wl = Path()..moveTo(cx - 22, cy - 2)..quadraticBezierTo(cx - 46, cy + 8, cx - 33, cy + 30)..quadraticBezierTo(cx - 26, cy + 18, cx - 22, cy + 12);
    final wr = Path()..moveTo(cx + 22, cy - 2)..quadraticBezierTo(cx + 46, cy + 8, cx + 33, cy + 30)..quadraticBezierTo(cx + 26, cy + 18, cx + 22, cy + 12);
    canvas.drawPath(wl, Paint()..color = _dark); canvas.drawPath(wr, Paint()..color = _dark);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 9, cy + 36), width: 12, height: 7), Paint()..color = const Color(0xFFFFB74D));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 9, cy + 36), width: 12, height: 7), Paint()..color = const Color(0xFFFFB74D));
    canvas.drawCircle(Offset(cx, cy - 14), 26, Paint()..color = color);
    canvas.drawPath(Path()..moveTo(cx - 16, cy - 28)..lineTo(cx - 26, cy - 48)..lineTo(cx - 6, cy - 33)..close(), Paint()..color = _dark);
    canvas.drawPath(Path()..moveTo(cx + 16, cy - 28)..lineTo(cx + 26, cy - 48)..lineTo(cx + 6, cy - 33)..close(), Paint()..color = _dark);
    canvas.drawCircle(Offset(cx - 11, cy - 14), 13, Paint()..color = _light.withOpacity(0.35));
    canvas.drawCircle(Offset(cx + 11, cy - 14), 13, Paint()..color = _light.withOpacity(0.35));
    canvas.drawPath(Path()..moveTo(cx - 4, cy - 4)..lineTo(cx, cy + 4)..lineTo(cx + 4, cy - 4)..close(), Paint()..color = const Color(0xFFFFB74D));
    _drawEyes(canvas, cx, cy, yOff: -16, spacing: 11, sz: 5.5);
    _drawBlush(canvas, cx, cy, yOff: -6, sp: 20);
  }

  void _drawWhale(Canvas canvas, double cx, double cy) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 4), width: 76, height: 52), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 12), width: 50, height: 28), Paint()..color = _veryLight.withOpacity(0.35));
    final t = Path()..moveTo(cx + 34, cy + 3)..quadraticBezierTo(cx + 50, cy - 4, cx + 52, cy - 18)
      ..quadraticBezierTo(cx + 48, cy - 6, cx + 46, cy)..quadraticBezierTo(cx + 48, cy + 8, cx + 52, cy + 20)
      ..quadraticBezierTo(cx + 50, cy + 10, cx + 34, cy + 6);
    canvas.drawPath(t, Paint()..color = _dark);
    final fl = Path()..moveTo(cx - 18, cy + 8)..quadraticBezierTo(cx - 40, cy + 16, cx - 33, cy + 28)..quadraticBezierTo(cx - 23, cy + 20, cx - 16, cy + 13);
    canvas.drawPath(fl, Paint()..color = _dark);
    if (!isSleeping) {
      final wc = const Color(0xFF90CAF9).withOpacity(0.45);
      canvas.drawCircle(Offset(cx - 2, cy - 26), 3.5, Paint()..color = wc);
      canvas.drawCircle(Offset(cx - 6, cy - 34), 3, Paint()..color = wc.withOpacity(0.35));
      canvas.drawCircle(Offset(cx + 4, cy - 35), 2.5, Paint()..color = wc.withOpacity(0.25));
    }
    _drawEyes(canvas, cx, cy, yOff: -6, spacing: 14, sz: 5);
    _drawBlush(canvas, cx, cy, yOff: 4, sp: 23);
    _drawMouth(canvas, cx, cy, yOff: 10);
  }

  void _drawBunny(Canvas canvas, double cx, double cy) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 13, cy - 46), width: 17, height: 42), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 13, cy - 46), width: 17, height: 42), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 13, cy - 46), width: 8, height: 32), Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.3));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 13, cy - 46), width: 8, height: 32), Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.3));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 14), width: 50, height: 42), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 18), width: 28, height: 26), Paint()..color = _veryLight.withOpacity(0.25));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 15, cy + 34), width: 14, height: 9), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 15, cy + 34), width: 14, height: 9), Paint()..color = color);
    canvas.drawCircle(Offset(cx + 23, cy + 20), 7, Paint()..color = _veryLight);
    canvas.drawCircle(Offset(cx, cy - 10), 26, Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 2), width: 7, height: 5), Paint()..color = const Color(0xFFFF8FAB));
    _drawEyes(canvas, cx, cy, yOff: -14, spacing: 10, sz: 5);
    _drawBlush(canvas, cx, cy, yOff: -4, sp: 19);
    _drawMouth(canvas, cx, cy, yOff: 3);
  }

  void _drawHamster(Canvas canvas, double cx, double cy) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 10), width: 56, height: 48), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 16), width: 34, height: 28), Paint()..color = _veryLight.withOpacity(0.35));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 16, cy + 32), width: 12, height: 8), Paint()..color = _dark);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 16, cy + 32), width: 12, height: 8), Paint()..color = _dark);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 22, cy + 12), width: 9, height: 7), Paint()..color = color);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 22, cy + 12), width: 9, height: 7), Paint()..color = color);
    canvas.drawCircle(Offset(cx, cy - 10), 28, Paint()..color = color);
    final cc = Color.lerp(color, const Color(0xFFFF8FAB), 0.22)!;
    canvas.drawCircle(Offset(cx - 24, cy - 2), 13, Paint()..color = cc);
    canvas.drawCircle(Offset(cx + 24, cy - 2), 13, Paint()..color = cc);
    canvas.drawCircle(Offset(cx - 22, cy - 28), 10, Paint()..color = _dark);
    canvas.drawCircle(Offset(cx + 22, cy - 28), 10, Paint()..color = _dark);
    canvas.drawCircle(Offset(cx - 22, cy - 28), 6, Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.3));
    canvas.drawCircle(Offset(cx + 22, cy - 28), 6, Paint()..color = const Color(0xFFFF8FAB).withOpacity(0.3));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 20), width: 18, height: 10), Paint()..color = _dark.withOpacity(0.25));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 2), width: 6, height: 4.5), Paint()..color = const Color(0xFFFF8FAB));
    final wp = Paint()..color = Colors.white.withOpacity(0.35)..strokeWidth = 0.7..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 9, cy - 1), Offset(cx - 28, cy - 4), wp);
    canvas.drawLine(Offset(cx - 9, cy + 1), Offset(cx - 28, cy + 3), wp);
    canvas.drawLine(Offset(cx + 9, cy - 1), Offset(cx + 28, cy - 4), wp);
    canvas.drawLine(Offset(cx + 9, cy + 1), Offset(cx + 28, cy + 3), wp);
    _drawEyes(canvas, cx, cy, yOff: -12, spacing: 10, sz: 4.5);
    _drawBlush(canvas, cx, cy, yOff: 0, sp: 24);
    _drawMouth(canvas, cx, cy, yOff: 4);
  }

  @override
  bool shouldRepaint(covariant _PetPainter old) => true;
}

class _PetOption {
  final String type, name, emoji, desc;
  final Color color;
  const _PetOption({required this.type, required this.name, required this.emoji, required this.color, required this.desc});
}

class _ColorOption {
  final String name; final Color color;
  const _ColorOption({required this.name, required this.color});
}

class _AccessoryOption {
  final String id, name, emoji;
  const _AccessoryOption({required this.id, required this.name, required this.emoji});
}

class _ActionBtn {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.color, required this.onTap});
}
ENDOFFILE

echo "  Reescrito: lib/features/pet/pet_screen.dart"
echo ""
echo "Listo. Ejecuta: flutter run"
