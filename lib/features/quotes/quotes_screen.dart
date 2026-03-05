import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  late AnimationController _entranceController;
  late AnimationController _glowController;
  int _currentPage = 0;

  // TODO: Reemplazar con las 25 frases literarias reales y justificaciones de Valencia
  final List<_Quote> _quotes = [
    _Quote(
      text:
          'Te quiero sin saber cómo, ni cuándo, ni de dónde. Te quiero directamente sin problemas ni orgullo.',
      author: 'Pablo Neruda',
      book: 'Cien Sonetos de Amor',
      why:
          'Porque así es como te quiero. Sin lógica, sin razón, sin manual. Solo te quiero, y punto.',
    ),
    _Quote(
      text:
          'Cada átomo de mi cuerpo es un universo en sí, y en cada uno existes tú.',
      author: 'Walt Whitman',
      book: 'Hojas de Hierba',
      why:
          'Porque estás en cada parte de mí. En lo que escribo, en lo que pienso, en lo que sueño.',
    ),
    _Quote(
      text:
          'Eres mi hoy y todos mis mañanas.',
      author: 'Leo Christopher',
      book: '',
      why:
          'Porque no hay futuro que me imagine sin ti.',
    ),
    _Quote(
      text:
          'La amaba contra toda razón, contra toda promesa de un destino mejor.',
      author: 'Charles Dickens',
      book: 'Grandes Esperanzas',
      why:
          'Porque a 1,051 km, la razón dice que es difícil. Pero el corazón dice que es inevitable.',
    ),
    _Quote(
      text:
          'No soy nada especial, de esto estoy seguro. Soy solamente un hombre común con pensamientos comunes, y he llevado una vida común. No hay monumentos dedicados a mí, y mi nombre pronto será olvidado, pero he amado a otra persona con todo mi corazón y mi alma, y para mí, eso siempre ha sido suficiente.',
      author: 'Nicholas Sparks',
      book: 'El Diario de Noah',
      why:
          'Porque no necesito ser extraordinario para el mundo. Solo necesito serlo para ti.',
    ),
    _Quote(
      text:
          'Eres lo mejor que me ha pasado.',
      author: 'Gabriel García Márquez',
      book: 'El Amor en los Tiempos del Cólera',
      why:
          'Simple. Directo. Verdadero. Como tú.',
    ),
    _Quote(
      text:
          'Si tuviera que volver a nacer, te buscaría mucho antes.',
      author: 'Eduardo Galeano',
      book: 'El Libro de los Abrazos',
      why:
          'Porque mi único arrepentimiento es no haberte encontrado antes.',
    ),
    // Agrega las 18 restantes aquí...
  ];

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 80,
        enableShootingStars: false,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([_entranceController, _glowController]),
            builder: (context, _) {
              final fadeIn = CurvedAnimation(
                parent: _entranceController,
                curve: Curves.easeOut,
              );

              return Opacity(
                opacity: fadeIn.value,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.warmGold.withOpacity(0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.paleLavender.withOpacity(0.7),
                                size: 20,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              const Text(
                                'Frases',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.starWhite,
                                  letterSpacing: 3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Palabras que nos definen',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.warmGold.withOpacity(0.5),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const SizedBox(width: 44),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Counter
                    Text(
                      '${_currentPage + 1} / ${_quotes.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: AppColors.paleLavender.withOpacity(0.3),
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quote cards con PageView
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemCount: _quotes.length,
                        itemBuilder: (context, index) {
                          return _buildQuoteCard(_quotes[index], index);
                        },
                      ),
                    ),

                    // Indicador de scroll
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chevron_left,
                            color: _currentPage > 0
                                ? AppColors.paleLavender.withOpacity(0.4)
                                : Colors.transparent,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'desliza para más',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                              color: AppColors.paleLavender.withOpacity(0.3),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            color: _currentPage < _quotes.length - 1
                                ? AppColors.paleLavender.withOpacity(0.4)
                                : Colors.transparent,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteCard(_Quote quote, int index) {
    final glowIntensity = 0.05 + _glowController.value * 0.1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.warmGold.withOpacity(0.06),
              AppColors.darkIndigo.withOpacity(0.5),
              AppColors.midnightBlue.withOpacity(0.3),
            ],
          ),
          border: Border.all(
            color: AppColors.warmGold.withOpacity(0.12 + glowIntensity),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.warmGold.withOpacity(glowIntensity * 0.3),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono de comillas
              Icon(
                Icons.format_quote_rounded,
                color: AppColors.warmGold.withOpacity(0.3),
                size: 36,
              ),

              const SizedBox(height: 20),

              // La frase
              Expanded(
                flex: 3,
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      '"${quote.text}"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: AppColors.starWhite,
                        height: 1.8,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Autor y libro
              Text(
                '— ${quote.author}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.shimmerGold.withOpacity(0.8),
                  letterSpacing: 1,
                ),
              ),
              if (quote.book.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  quote.book,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: AppColors.paleLavender.withOpacity(0.4),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Separador
              Container(
                width: 30,
                height: 0.5,
                color: AppColors.warmGold.withOpacity(0.2),
              ),

              const SizedBox(height: 20),

              // "Por qué la elegí" — la justificación de Valencia
              Expanded(
                flex: 2,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'POR QUÉ LA ELEGÍ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warmGold.withOpacity(0.4),
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          quote.why,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: AppColors.paleLavender.withOpacity(0.7),
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
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

class _Quote {
  final String text;
  final String author;
  final String book;
  final String why;

  const _Quote({
    required this.text,
    required this.author,
    required this.book,
    required this.why,
  });
}

