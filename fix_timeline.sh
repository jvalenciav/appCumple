#!/bin/bash
# ================================================================
# FIX: Reescribir timeline con momentos REALES de su conversacion
# Ejecuta desde la raiz de cynthia_app/: bash fix_timeline.sh
# ================================================================

echo "Reescribiendo timeline con momentos reales..."

python3 << 'PYEOF'
filepath = "lib/features/timeline/timeline_screen.dart"

with open(filepath, "r") as f:
    content = f.read()

old_moments = """  final List<TimelineMoment> _moments = [
    TimelineMoment(
      date: 'D\u00eda 1',
      title: 'El Primer Mensaje',
      description: 'Un hola que cambi\u00f3 todo. El universo conspirando para que nuestros caminos se cruzaran.',
      icon: Icons.chat_bubble_outline_rounded,
      color: AppColors.softLavender,
    ),
    TimelineMoment(
      date: 'Semana 1',
      title: 'La Primera Llamada',
      description: 'Escuchar tu voz por primera vez. 6 horas que se sintieron como 6 minutos.',
      icon: Icons.call_rounded,
      color: AppColors.electricBlue,
    ),
    TimelineMoment(
      date: 'Mes 1',
      title: 'Primera Noche de Gaming',
      description: 'Descubrimos que juntos somos el mejor equipo. En el juego y en la vida.',
      icon: Icons.sports_esports_rounded,
      color: AppColors.shimmerGold,
    ),
    TimelineMoment(
      date: 'Mes 2',
      title: 'Te Dije Te Amo',
      description: 'Las palabras m\u00e1s importantes que jam\u00e1s he compilado. Y las m\u00e1s verdaderas.',
      icon: Icons.favorite_rounded,
      color: AppColors.roseGold,
    ),
    TimelineMoment(
      date: 'Mes 3',
      title: 'Nuestros Apodos',
      description: 'El b\u00faho y la ballena. Dos seres de mundos diferentes que encontraron su hogar el uno en el otro.',
      icon: Icons.pets_rounded,
      color: AppColors.paleLavender,
    ),
    TimelineMoment(
      date: 'Hoy',
      title: 'Tu Cumplea\u00f1os',
      description: 'Celebrando que existes. Que eres t\u00fa. Que eres m\u00eda y yo soy tuyo. Feliz cumplea\u00f1os, amor.',
      icon: Icons.cake_rounded,
      color: AppColors.warmGold,
    ),
    TimelineMoment(
      date: 'Pronto',
      title: '0 Kil\u00f3metros',
      description: 'El d\u00eda que la distancia desaparezca y pueda abrazarte sin soltar.',
      icon: Icons.flight_rounded,
      color: AppColors.starWhite,
    ),
  ];"""

new_moments = """  final List<TimelineMoment> _moments = [
    TimelineMoment(
      date: '26 Nov 2025',
      title: 'Vamos a jugar',
      description: 'Tu primer mensaje invitandome a jugar. No alcance, pero ese dia empezamos a hablar de verdad. Gracias por acordarte de mi.',
      icon: Icons.sports_esports_rounded,
      color: AppColors.softLavender,
    ),
    TimelineMoment(
      date: '14 Dic 2025',
      title: 'Te quiero pollo / Te quiero fea',
      description: 'Las 2:24 AM. Nuestro primer te quiero. Tu me dijiste pollo, yo te dije fea. Asi de bonito y raro empezo todo.',
      icon: Icons.favorite_border_rounded,
      color: AppColors.roseGold,
    ),
    TimelineMoment(
      date: '14 Dic 2025',
      title: 'Me gustas',
      description: 'Vi tus fotos, tus pecas, tu pelo cortito. Se me salio un \"me gustas\" y lo corregi a \"te queda\"... pero ambos sabemos que era verdad.',
      icon: Icons.visibility_rounded,
      color: AppColors.electricBlue,
    ),
    TimelineMoment(
      date: '16 Dic 2025',
      title: 'Mi cumple contigo',
      description: 'Mi primer cumple donde recibi un mensaje tuyo. \"Vales demasiado\" me escribiste. Ese dia lo guarde como uno de los mas bonitos.',
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
      date: '26 Feb 2026',
      title: 'Tu mi novia, yo tu novio',
      description: 'Te lo dije: tu seras mi novia y yo tu novio... si me aceptas obviamente. Y aqui estamos.',
      icon: Icons.favorite_rounded,
      color: AppColors.shimmerGold,
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
  ];"""

if old_moments in content:
    content = content.replace(old_moments, new_moments)
    with open(filepath, "w") as f:
        f.write(content)
    print("  Fixed: timeline_screen.dart - 10 momentos reales")
else:
    print("  WARN: No encontre la lista exacta. Reescribiendo...")
    # Fallback - buscar de otra forma
    import re
    pattern = r"final List<TimelineMoment> _moments = \[.*?\];"
    match = re.search(pattern, content, re.DOTALL)
    if match:
        content = content[:match.start()] + new_moments.lstrip() + content[match.end():]
        with open(filepath, "w") as f:
            f.write(content)
        print("  Fixed: timeline_screen.dart via regex")
    else:
        print("  ERROR: No se pudo encontrar la lista. Verificar manualmente.")

PYEOF

echo ""
echo "Listo. Ejecuta: flutter run"
