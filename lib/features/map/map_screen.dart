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
      detail: 'Aquí vive la esencia de lo que somos. Cada mensaje, cada llamada, cada "te quiero" flotan en esta nebulosa como partículas de luz infinita.',
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
      animation: Listenable.merge([_entranceController, _orbitController]),
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

