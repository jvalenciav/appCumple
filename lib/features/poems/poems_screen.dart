import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/starfield_background.dart';

class PoemsScreen extends StatefulWidget {
  const PoemsScreen({super.key});

  @override
  State<PoemsScreen> createState() => _PoemsScreenState();
}

class _PoemsScreenState extends State<PoemsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late PageController _pageController;
  int _currentPage = 0;

  // ============================================================
  // VALENCIA: Reemplaza con tus poemas reales estilo programador
  // ============================================================
  final List<PoemData> _poems = [
    PoemData(
      title: 'function quererte()',
      lines: [
        '// Este código no tiene bugs',
        '// porque fue escrito con el corazón',
        '',
        'function quererte() {',
        '  let distancia = 1051; // km',
        '  let amor = Infinity;',
        '',
        '  while (amor > distancia) {',
        '    pensar_en_ti();',
        '    contar_estrellas();',
        '    esperar_el_reencuentro();',
        '  }',
        '',
        '  // Este while nunca termina',
        '  // porque amor siempre será',
        '  // mayor que cualquier distancia.',
        '  return "Te quiero demasiado, Cynthia";',
        '}',
      ],
    ),
    PoemData(
      title: 'class Cynthia',
      lines: [
        'class Cynthia extends Universo {',
        '',
        '  final String sonrisa = "infinita";',
        '  final int belleza = Integer.MAX;',
        '  final bool esIncreíble = true;',
        '',
        '  @override',
        '  String toString() {',
        '    return "La razón por la que',
        '           todo tiene sentido";',
        '  }',
        '',
        '  void existir() {',
        '    // Con solo existir,',
        '    // ya cambiaste mi mundo.',
        '    hacerFelizAValencia();',
        '  }',
        '}',
      ],
    ),
    PoemData(
      title: 'try { vivir_sin_ti }',
      lines: [
        'try {',
        '  vivir_sin_ti();',
        '} catch (DolorError e) {',
        '  // Error: No se puede ejecutar.',
        '  // Dependencia crítica: Cynthia',
        '  // Estado: Indispensable',
        '',
        '  print("No hay versión de mi vida");',
        '  print("que funcione sin ella.");',
        '',
        '} finally {',
        '  // Nota del desarrollador:',
        '  // No intenten correr este código.',
        '  // Cynthia no es opcional.',
        '  // Es el sistema operativo',
        '  // de mi felicidad.',
        '}',
      ],
    ),
    PoemData(
      title: 'git log --amor',
      lines: [
        'commit a1b2c3d',
        'Author: Valencia <buho@universe>',
        'Date: El día que te conocí',
        '',
        '  feat: agregar razón para vivir',
        '',
        'commit d4e5f6g',
        'Author: Valencia <buho@universe>',
        'Date: Cada noche desde entonces',
        '',
        '  fix: reparar corazón roto',
        '  (merge: Cynthia → mi_vida)',
        '',
        'commit h7i8j9k',
        'Author: Valencia <buho@universe>',
        'Date: Hoy y siempre',
        '',
        '  release: amor v∞.0.0',
        '  No breaking changes. Solo felicidad.',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceController.dispose();
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
              const SizedBox(height: 20),
              Expanded(child: _buildPoemPages()),
              _buildPageDots(),
              const SizedBox(height: 20),
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
                  color: AppColors.shimmerGold.withOpacity(0.2),
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
              'Poemas del Programador',
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

  Widget _buildPoemPages() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (i) => setState(() => _currentPage = i),
      physics: const BouncingScrollPhysics(),
      itemCount: _poems.length,
      itemBuilder: (context, index) => _buildPoemCard(index),
    );
  }

  Widget _buildPoemCard(int index) {
    final poem = _poems[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF0A0E1A), // Fondo tipo terminal
          border: Border.all(
            color: AppColors.shimmerGold.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shimmerGold.withOpacity(0.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de título tipo terminal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: AppColors.darkIndigo.withOpacity(0.5),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.shimmerGold.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Dots de terminal
                  _terminalDot(Colors.red.shade400),
                  const SizedBox(width: 6),
                  _terminalDot(Colors.amber.shade400),
                  const SizedBox(width: 6),
                  _terminalDot(Colors.green.shade400),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      poem.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: AppColors.shimmerGold.withOpacity(0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Contenido del poema
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: poem.lines.asMap().entries.map((entry) {
                    final line = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.5),
                      child: _buildCodeLine(line),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.shimmerGold.withOpacity(0.05),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 12,
                    color: AppColors.roseGold.withOpacity(0.5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'compiled with love',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: AppColors.paleLavender.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeLine(String line) {
    if (line.isEmpty) return const SizedBox(height: 12);

    Color textColor = AppColors.starWhite.withOpacity(0.85);
    FontWeight weight = FontWeight.w400;

    if (line.startsWith('//') || line.startsWith('  //')) {
      textColor = const Color(0xFF6A9955); // Verde comentario
    } else if (line.contains('function') ||
        line.contains('class') ||
        line.contains('try') ||
        line.contains('catch') ||
        line.contains('finally') ||
        line.contains('while') ||
        line.contains('@override') ||
        line.contains('return') ||
        line.contains('commit') ||
        line.contains('Author:') ||
        line.contains('Date:')) {
      textColor = AppColors.softLavender;
      weight = FontWeight.w500;
    } else if (line.contains('"') || line.contains("'")) {
      textColor = const Color(0xFFCE9178); // Naranja string
    } else if (line.contains('let ') ||
        line.contains('final ') ||
        line.contains('const ') ||
        line.contains('feat:') ||
        line.contains('fix:') ||
        line.contains('release:')) {
      textColor = const Color(0xFF569CD6); // Azul keyword
    }

    return Text(
      line,
      style: TextStyle(
        fontSize: 13,
        fontFamily: 'monospace',
        color: textColor,
        fontWeight: weight,
        height: 1.5,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _terminalDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.8),
      ),
    );
  }

  Widget _buildPageDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_poems.length, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? AppColors.shimmerGold
                : AppColors.starWhite.withOpacity(0.2),
          ),
        );
      }),
    );
  }
}

class PoemData {
  final String title;
  final List<String> lines;

  const PoemData({required this.title, required this.lines});
}

