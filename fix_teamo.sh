#!/bin/bash
# ================================================================
# FIX: Cambiar "Te amo" por "Te quiero demasiado"
# Ejecuta desde la raiz de cynthia_app/: bash fix_teamo.sh
# ================================================================

echo "Actualizando frases..."

# book_screen.dart
sed -i '' "s/Te amo infinitamente. 🦉❤️🐋/Te quiero demasiado. 🦉❤️🐋/g" lib/features/book/book_screen.dart 2>/dev/null || sed -i "s/Te amo infinitamente. 🦉❤️🐋/Te quiero demasiado. 🦉❤️🐋/g" lib/features/book/book_screen.dart
echo "  Fixed: book_screen.dart"

# home_screen.dart
sed -i '' 's/Por las que te amo/Por las que te quiero/g' lib/features/home/home_screen.dart 2>/dev/null || sed -i 's/Por las que te amo/Por las que te quiero/g' lib/features/home/home_screen.dart
echo "  Fixed: home_screen.dart"

# map_screen.dart
sed -i '' 's/cada \"te amo\" flotan/cada \"te quiero\" flotan/g' lib/features/map/map_screen.dart 2>/dev/null || sed -i 's/cada \"te amo\" flotan/cada \"te quiero\" flotan/g' lib/features/map/map_screen.dart
echo "  Fixed: map_screen.dart"

# poems_screen.dart - cambiar el return y la funcion
sed -i '' 's/function amarTe/function quererte/g' lib/features/poems/poems_screen.dart 2>/dev/null || sed -i 's/function amarTe/function quererte/g' lib/features/poems/poems_screen.dart
sed -i '' 's/return \"Te amo, Cynthia\"/return \"Te quiero demasiado, Cynthia\"/g' lib/features/poems/poems_screen.dart 2>/dev/null || sed -i 's/return \"Te amo, Cynthia\"/return \"Te quiero demasiado, Cynthia\"/g' lib/features/poems/poems_screen.dart
echo "  Fixed: poems_screen.dart"

# timeline_screen.dart
sed -i '' 's/Te Dije Te Amo/Te Dije Te Quiero/g' lib/features/timeline/timeline_screen.dart 2>/dev/null || sed -i 's/Te Dije Te Amo/Te Dije Te Quiero/g' lib/features/timeline/timeline_screen.dart
echo "  Fixed: timeline_screen.dart"

echo ""
echo "Listo - todo actualizado"
