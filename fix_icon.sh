#!/bin/bash
# ================================================================
# Configurar icono de la app con tu logo
# Ejecuta desde la raiz de cynthia_app/: bash fix_icon.sh
# ================================================================

echo "Configurando icono de la app..."

# 1. Agregar dependencia de flutter_launcher_icons en pubspec.yaml
# Primero verificar si ya existe
if grep -q "flutter_launcher_icons" pubspec.yaml 2>/dev/null; then
  echo "  flutter_launcher_icons ya existe en pubspec.yaml"
else
  # Agregar al final del pubspec.yaml
  cat >> pubspec.yaml << 'YAMLEOF'

dev_dependencies:
  flutter_launcher_icons: ^0.14.3

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon.png"
  adaptive_icon_background: "#072138"
  adaptive_icon_foreground: "assets/icon.png"
YAMLEOF
  echo "  Agregado flutter_launcher_icons a pubspec.yaml"
fi

# 2. Crear carpeta assets si no existe
mkdir -p assets

# 3. Verificar que el logo existe
if [ -f "assets/icon.png" ]; then
  echo "  Logo encontrado: assets/icon.png"
else
  echo ""
  echo "  IMPORTANTE: Necesitas copiar tu logo a assets/icon.png"
  echo "  Si tu logo tiene otro nombre, renombralo:"
  echo "    Ejemplo: cp assets/tu_logo.png assets/icon.png"
  echo ""
  echo "  Archivos en assets/:"
  ls -la assets/ 2>/dev/null || echo "    (carpeta vacia)"
fi

echo ""
echo "Ahora ejecuta estos comandos en orden:"
echo ""
echo "  1. Copia tu logo: cp assets/TU_LOGO.png assets/icon.png"
echo "     (cambia TU_LOGO.png por el nombre real de tu archivo)"
echo ""
echo "  2. flutter pub get"
echo ""
echo "  3. dart run flutter_launcher_icons"
echo ""
echo "  4. flutter build apk --release"
echo ""
echo "Listo - tu app tendra el icono personalizado"
