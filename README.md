# eu — Personal Information Wallet

Calm, minimal Flutter app (Android + iOS) for storing and quickly accessing health info, emergency contacts, and addresses.

## Setup

1. Install [Flutter](https://flutter.dev/docs/get-started/install)
2. From this directory:
   ```bash
   flutter pub get
   flutter create . --project-name eu   # adds android/ios if missing
   ```
3. Set API base URL:
   - Edit `lib/core/config/config.dart` → `defaultApiBaseUrl` (dummy/local)
   - Or: `flutter run --dart-define=API_BASE_URL=http://your-api:8080`

## Run

```bash
# Android
flutter run

# iOS (macOS only)
flutter run -d ios

# With custom API URL
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

**Acompanhar ao vivo (enquanto prompts/IA editam o código):** rode o app num terminal e deixe aberto. Quando os arquivos forem salvos, no mesmo terminal pressione **`r`** (hot reload) ou **`R`** (hot restart) para ver as mudanças. Ou use o script:

```bash
./run_dev.sh
```

## Structure

- `lib/core/` — theme, routing, storage, widgets
- `lib/data/` — API client, DTOs, repositories
- `lib/state/` — Riverpod controllers
- `lib/screens/` — UI screens
- `lib/utils/` — constants

## Docs

See `docs/` for rules, architecture, design, and API contract.
