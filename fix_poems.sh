#!/bin/bash
# ================================================================
# FIX: Pulir pantalla de Poemas - solo 2 poemas + mensaje especial
# Ejecuta desde la raiz de cynthia_app/: bash fix_poems.sh
# ================================================================

echo "Puliendo pantalla de Poemas..."

python3 << 'PYEOF'
filepath = "lib/features/poems/poems_screen.dart"

with open(filepath, "r") as f:
    content = f.read()

# Reemplazar TODA la lista de poemas + agregar pagina especial
# Buscar desde el inicio de la lista hasta el cierre

old_poems = """  final List<PoemData> _poems = [
    PoemData(
      title: 'function amarTe()',
      lines: [
        '// Este c\u00f3digo no tiene bugs',
        '// porque fue escrito con el coraz\u00f3n',
        '',
        'function amarTe() {',
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
        '  // porque amor siempre ser\u00e1',
        '  // mayor que cualquier distancia.',
        '  return \"Te amo, Cynthia\";',
        '}',
      ],
    ),
    PoemData(
      title: 'class Cynthia',
      lines: [
        'class Cynthia extends Universo {',
        '',
        '  final String sonrisa = \"infinita\";',
        '  final int belleza = Integer.MAX;',
        '  final bool esIncre\u00edble = true;',
        '',
        '  @override',
        '  String toString() {',
        '    return \"La raz\u00f3n por la que',
        '           todo tiene sentido\";',
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
        '  // Dependencia cr\u00edtica: Cynthia',
        '  // Estado: Indispensable',
        '',
        '  print(\"No hay versi\u00f3n de mi vida\");',
        '  print(\"que funcione sin ella.\");',
        '',
        '} finally {',
        '  // Nota del desarrollador:',
        '  // No intenten correr este c\u00f3digo.',
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
        'Date: El d\u00eda que te conoc\u00ed',
        '',
        '  feat: agregar raz\u00f3n para vivir',
        '',
        'commit d4e5f6g',
        'Author: Valencia <buho@universe>',
        'Date: Cada noche desde entonces',
        '',
        '  fix: reparar coraz\u00f3n roto',
        '  (merge: Cynthia \u2192 mi_vida)',
        '',
        'commit h7i8j9k',
        'Author: Valencia <buho@universe>',
        'Date: Hoy y siempre',
        '',
        '  release: amor v\u221e.0.0',
        '  No breaking changes. Solo felicidad.',
      ],
    ),
  ];"""

new_poems = """  final List<PoemData> _poems = [
    PoemData(
      title: 'function quererte()',
      lines: [
        '// Este codigo no tiene bugs',
        '// porque fue escrito con el corazon',
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
        '  // porque amor siempre sera',
        '  // mayor que cualquier distancia.',
        '  return \"Te quiero demasiado, Cynthia\";',
        '}',
      ],
    ),
    PoemData(
      title: 'class Cynthia',
      lines: [
        'class Cynthia extends Universo {',
        '',
        '  final String sonrisa = \"infinita\";',
        '  final int belleza = Integer.MAX;',
        '  final bool esIncreible = true;',
        '',
        '  @override',
        '  String toString() {',
        '    return \"La razon por la que',
        '           todo tiene sentido\";',
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
  ];

  // Pagina especial al final
  static const bool _hasSpecialPage = true;"""

if old_poems in content:
    content = content.replace(old_poems, new_poems)
else:
    print("  WARN: No encontre la lista exacta de poemas. Intentando alternativa...")
    # Si ya se habia aplicado el fix de te amo antes
    content = content.split("final List<PoemData> _poems = [")[0]
    # Rebuild - mejor reescribir el archivo completo
    pass

# Ahora modificar el PageView para agregar la pagina especial
# Cambiar itemCount para incluir +1

content = content.replace(
    """      itemCount: _poems.length,
      itemBuilder: (context, index) => _buildPoemCard(index),""",
    """      itemCount: _poems.length + 1,
      itemBuilder: (context, index) {
        if (index == _poems.length) return _buildSpecialPage();
        return _buildPoemCard(index);
      },"""
)

# Cambiar los dots tambien
content = content.replace(
    """      children: List.generate(_poems.length, (i) {""",
    """      children: List.generate(_poems.length + 1, (i) {"""
)

# Agregar el metodo _buildSpecialPage antes del cierre de la clase
# Lo insertamos antes de la clase PoemData

special_page = """
  Widget _buildSpecialPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.shimmerGold.withOpacity(0.08),
              AppColors.darkIndigo.withOpacity(0.6),
              AppColors.roseGold.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: AppColors.shimmerGold.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shimmerGold.withOpacity(0.08),
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono de libro
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.shimmerGold.withOpacity(0.1),
                  border: Border.all(
                    color: AppColors.shimmerGold.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.shimmerGold.withOpacity(0.7),
                  size: 32,
                ),
              ),
              const SizedBox(height: 28),
              // Mensaje principal
              Text(
                'Tu libro de poemas\\nse esta preparando...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.starWhite.withOpacity(0.9),
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              // Linea decorativa
              Container(
                width: 50,
                height: 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.shimmerGold.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Mensaje secundario
              Text(
                'Este te lo tengo que\\ndar en persona.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                  color: AppColors.shimmerGold.withOpacity(0.7),
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 28),
              // Emoji/icono
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    size: 16,
                    color: AppColors.roseGold.withOpacity(0.4),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'pronto...',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.paleLavender.withOpacity(0.4),
                      letterSpacing: 3,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.favorite_rounded,
                    size: 16,
                    color: AppColors.roseGold.withOpacity(0.4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

"""

content = content.replace(
    """class PoemData {""",
    special_page + """class PoemData {"""
)

with open(filepath, "w") as f:
    f.write(content)

print("  Fixed: poems_screen.dart")
print("    - Solo 2 poemas (quererte + class Cynthia)")
print("    - Pagina especial: tu libro se esta preparando...")
PYEOF

echo ""
echo "Listo. Ejecuta: flutter run"
