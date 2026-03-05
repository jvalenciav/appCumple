import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _entranceController;
  late AnimationController _particleController;
  int _currentPage = 0;

  // ============================================================
  // VALENCIA: Personaliza cada página con tu contenido real
  // Cada BookPageData tiene: título, contenido, ícono y color
  // ============================================================
  final List<BookPageData> _pages = [
    BookPageData(
      title: 'Capítulo 1',
      heading: 'El Primer Hola',
      content:
          'Hubo un momento exacto en el que todo cambió. Un mensaje, una notificación, '
          'y de pronto el universo se reordenó para que nuestros caminos se cruzaran.\n\n'
          'No fue casualidad. Fue el código del destino ejecutándose a la perfección.',
      icon: Icons.chat_bubble_rounded,
      accentColor: AppColors.softLavender,
    ),
    BookPageData(
      title: 'Capítulo 2',
      heading: 'Las 2 AM',
      content:
          'Las noches dejaron de ser oscuras cuando empezamos a hablar hasta que el sol '
          'salía. Cada llamada de 6 horas era un universo entero comprimido en ondas de sonido.\n\n'
          'Tu voz se convirtió en mi canción favorita. La que nunca quiero que termine.',
      icon: Icons.nightlight_round,
      accentColor: AppColors.electricBlue,
    ),
    BookPageData(
      title: 'Capítulo 3',
      heading: 'La Distancia',
      content:
          '1,051 kilómetros. Un número que a cualquiera le parecería imposible, '
          'pero para nosotros es solo el espacio entre dos corazones que laten sincronizados.\n\n'
          'La distancia no nos separa. Nos da razones para amarnos con más fuerza.',
      icon: Icons.location_on_rounded,
      accentColor: AppColors.shimmerGold,
    ),
    BookPageData(
      title: 'Capítulo 4',
      heading: 'Tu Risa',
      content:
          'Si pudiera compilar un programa que reprodujera tu risa en loop infinito, '
          'sería el código más valioso jamás escrito.\n\n'
          'Tu risa es el sonido que le da sentido a todo. Es la prueba de que la felicidad tiene frecuencia.',
      icon: Icons.emoji_emotions_rounded,
      accentColor: AppColors.roseGold,
    ),
    BookPageData(
      title: 'Capítulo 5',
      heading: 'Gaming Nights',
      content:
          'Nuestras noches de gaming no son solo partidas — son rituales sagrados. '
          'Cada victoria juntos, cada derrota ridícula, cada momento donde nos reímos hasta no poder más.\n\n'
          'Tú eres mi jugadora favorita. En todos los juegos. En todos los niveles.',
      icon: Icons.sports_esports_rounded,
      accentColor: AppColors.electricBlue,
    ),
    BookPageData(
      title: 'Capítulo 6',
      heading: 'El Búho y la Ballena',
      content:
          'Yo soy el búho que observa desde lo alto, buscando luz en la oscuridad. '
          'Tú eres la ballena: inmensa, profunda, majestuosa.\n\n'
          'Uno vuela, la otra nada. Pero ambos comparten el mismo cielo y el mismo océano.',
      icon: Icons.water_rounded,
      accentColor: AppColors.softLavender,
    ),
    BookPageData(
      title: 'Capítulo 7',
      heading: 'Tu Arte',
      content:
          'Eres estudiante de diseño y cada trazo que haces es una extensión de tu alma. '
          'Yo escribo código, tú creas mundos visuales.\n\n'
          'Juntos somos el proyecto más hermoso: función y forma en perfecta armonía.',
      icon: Icons.palette_rounded,
      accentColor: AppColors.warmGold,
    ),
    BookPageData(
      title: 'Capítulo 8',
      heading: 'Los Silencios',
      content:
          'A veces no necesitamos palabras. Solo estar ahí, en silencio, '
          'conectados a una llamada donde el silencio dice más que cualquier frase.\n\n'
          'Contigo aprendí que la calma también es un lenguaje de amor.',
      icon: Icons.volume_off_rounded,
      accentColor: AppColors.paleLavender,
    ),
    BookPageData(
      title: 'Capítulo 9',
      heading: 'Promesas',
      content:
          'Te prometo que cada línea de código que escriba tendrá un pedazo de ti. '
          'Que cada noche será nuestra. Que la distancia será solo un número.\n\n'
          'Te prometo que este búho siempre volará hacia donde estés.',
      icon: Icons.handshake_rounded,
      accentColor: AppColors.shimmerGold,
    ),
    BookPageData(
      title: 'Capítulo 10',
      heading: 'El Futuro',
      content:
          'Un día los 1,051 km serán cero. Un día despertaré viéndote a los ojos en persona, '
          'no a través de una pantalla.\n\n'
          'Y cuando llegue ese día, te abrazaré tan fuerte que el universo entero lo va a sentir.',
      icon: Icons.auto_awesome_rounded,
      accentColor: AppColors.roseGold,
    ),
    BookPageData(
      title: 'Capítulo ∞',
      heading: 'Sin Final',
      content:
          'Esta historia no tiene último capítulo. Porque cada día contigo es una página nueva.\n\n'
          'Feliz cumpleaños, Cynthia.\n\n'
          'Con todo mi código, mi alma y mi corazón:\n'
          'Te quiero demasiado. 🦉❤️🐋',
      icon: Icons.all_inclusive_rounded,
      accentColor: AppColors.shimmerGold,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _particleController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 80,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _entranceController,
            builder: (context, _) {
              return Column(
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 10),
                  _buildPageIndicator(),
                  const SizedBox(height: 10),
                  Expanded(child: _buildPageView()),
                  const SizedBox(height: 20),
                  _buildSwipeHint(),
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
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: fade.value,
      child: Padding(
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
                    color: AppColors.softLavender.withOpacity(0.2),
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
                'Nuestro Libro',
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
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? _pages[_currentPage].accentColor
                : AppColors.starWhite.withOpacity(0.2),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _pages[_currentPage].accentColor.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildPageView() {
    final slideIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: slideIn.value,
      child: Transform.translate(
        offset: Offset(0, 50 * (1 - slideIn.value)),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (page) => setState(() => _currentPage = page),
          physics: const BouncingScrollPhysics(),
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            return _buildPage(index);
          },
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    final page = _pages[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              page.accentColor.withOpacity(0.08),
              AppColors.darkIndigo.withOpacity(0.7),
              AppColors.midnightBlue.withOpacity(0.5),
            ],
          ),
          border: Border.all(
            color: page.accentColor.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: page.accentColor.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Número de capítulo
              Text(
                page.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: page.accentColor.withOpacity(0.6),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 16),
              // Ícono
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: page.accentColor.withOpacity(0.1),
                  border: Border.all(
                    color: page.accentColor.withOpacity(0.25),
                  ),
                ),
                child: Icon(
                  page.icon,
                  color: page.accentColor,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              // Heading
              Text(
                page.heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.starWhite,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              // Línea decorativa
              Container(
                width: 40,
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      page.accentColor,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    page.content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: AppColors.starWhite.withOpacity(0.85),
                      height: 1.7,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              // Número de página
              const SizedBox(height: 10),
              Text(
                '${index + 1} / ${_pages.length}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: AppColors.paleLavender.withOpacity(0.4),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeHint() {
    final fade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    return Opacity(
      opacity: fade.value * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swipe_rounded,
            size: 16,
            color: AppColors.paleLavender.withOpacity(0.5),
          ),
          const SizedBox(width: 6),
          Text(
            'Desliza para leer',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.paleLavender.withOpacity(0.5),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class BookPageData {
  final String title;
  final String heading;
  final String content;
  final IconData icon;
  final Color accentColor;

  const BookPageData({
    required this.title,
    required this.heading,
    required this.content,
    required this.icon,
    required this.accentColor,
  });
}

