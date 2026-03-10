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
      date: '26 Nov 2025',
      title: 'Vamos a jugar',
      description: 'Tu primer mensaje invitandome a jugar. No alcance, pero ese dia empezamos a hablar de verdad. Gracias por acordarte de mi.',
      icon: Icons.sports_esports_rounded,
      color: AppColors.softLavender,
    ),
    TimelineMoment(
      date: '14 Dic 2025',
      title: 'Me gustas',
      description: 'Vi tus fotos, tus pecas, tu pelo cortito. Se me salio un "me gustas" y lo corregi a "te queda"... pero ambos sabemos que era verdad.',
      icon: Icons.visibility_rounded,
      color: AppColors.electricBlue,
    ),
    TimelineMoment(
      date: '16 Dic 2025',
      title: 'Mi cumple contigo',
      description: 'Mi primer cumple donde recibi un mensaje tuyo. "Vales demasiado" me escribiste. Ese dia lo guarde como uno de los mas bonitos.',
      icon: Icons.cake_rounded,
      color: AppColors.shimmerGold,
    ),
    TimelineMoment(
      date: '20 Dic 2025',
      title: 'Primera videollamada',
      description: '3 horas viendonos la cara por primera vez. Despues de tanto intentar, al fin contestaste. Y el mundo cambio.',
      icon: Icons.videocam_rounded,
      color: AppColors.warmGold,
    ),
    TimelineMoment(
      date: '1 Ene 2026',
      title: 'Ano nuevo juntos',
      description: 'Videollamada de 8 horas. Empezamos el ano nuevo viendono. No hay mejor forma de empezar un ano que contigo.',
      icon: Icons.celebration_rounded,
      color: AppColors.paleLavender,
    ),
    TimelineMoment(
      date: '14 Feb 2026',
      title: '13 horas en llamada',
      description: 'San Valentin. 13 horas de videollamada. Record mundial. Porque contigo el tiempo no existe.',
      icon: Icons.call_rounded,
      color: AppColors.roseGold,
    ),
    TimelineMoment(
      date: 'Hoy',
      title: 'Tu cumple',
      description: 'Feliz cumple Cynthia. Esta app es mi forma de decirte que cada momento contigo ha valido todo. Te quiero demasiado.',
      icon: Icons.auto_awesome_rounded,
      color: AppColors.warmGold,
    ),
    TimelineMoment(
      date: 'Pronto',
      title: '0 Kilometros',
      description: 'El dia que por fin te abrace de verdad. Sin pantallas, sin distancia. Solo tu y yo.',
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
      animation: _controller,
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

