#!/usr/bin/env bash
# Roda o app em modo dev para acompanhar ao vivo (hot reload).
# Requer Flutter no PATH: https://flutter.dev/docs/get-started/install
set -e
cd "$(dirname "$0")"
flutter pub get
flutter run "$@"
