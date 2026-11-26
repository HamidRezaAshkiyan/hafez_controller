# AGENTS.md — Hafez Controller (`hafez_controller`)

## Overview
**Hafez Controller** (`v2.0.0+2`) is the official Flutter mobile remote-control app for the **[Hafez](https://github.com/HamidRezaAshkiyan/Hafez)** Windows mosque display software. Over local Wi-Fi, it pairs via QR code (or manual login), maintains real-time state sync over **SignalR** (`/hub/hafez`) and **REST API**, and controls notifications/tickers, emergency alerts, Quran/Mafatih/Personal Duas playback, live camera feeds, and gallery folders in Persian RTL Material 3 UI.

## Tech Stack & Requirements
- **Framework / SDK:** Flutter 3.x (CI uses `3.29.3` stable), Dart SDK `>=3.3.0 <4.0.0`, Java 17 (for Android Gradle builds).
- **State Management:** `flutter_riverpod` (`^2.6.1`).
- **Networking & Realtime:** `http` (`^1.2.2`), `signalr_netcore` (`^1.4.0`).
- **Hardware & Persistence:** `mobile_scanner` (`^6.0.7`) for QR pairing, `shared_preferences` (`^2.3.5`) for connection & theme persistence.
- **UI & Localization:** Material 3, `flutter_localizations` + `intl`, hardcoded `fa_IR` Persian RTL locale, bundled `Vazir` font (`assets/fonts/Vazir-Regular.ttf`).
- **Linting & Tests:** `flutter_lints` (`^5.0.0`), `flutter_test`.

## Repository Structure
```text
hafez_controller/
├── pubspec.yaml                            # Dependencies, assets, Vazir font, version 2.0.0+2
├── analysis_options.yaml                   # Dart analyzer & flutter_lints config
├── lib/
│   ├── main.dart                           # Entry point (ProviderScope, MaterialApp, fa_IR, Material 3)
│   ├── data/
│   │   ├── models.dart                     # HafezConnectionConfig, HafezLiveState, SureItem, DuaItem, etc.
│   │   └── hafez_api_client.dart           # REST endpoints & SignalR HubConnection client
│   ├── state/
│   │   └── hafez_controller_provider.dart  # Riverpod state notifier (connection, live state, catalogs, theme)
│   └── pages/
│       ├── home.dart                       # Main control dashboard (connection status, tabs/actions)
│       ├── qr_scanner_page.dart            # QR pairing scanner (mobile_scanner)
│       ├── book_controller.dart            # Quran, Mafatih & Personal Dua playback controller
│       ├── notification_controller.dart    # Notification groups, tickers & emergency alerts
│       └── settings_page.dart              # Manual host/port/login & dark/light theme settings
├── test/
│   ├── models_test.dart                    # JSON/model parsing unit tests
│   └── widget_test.dart                    # Widget smoke tests
├── android/ & ios/                         # Platform runner projects
├── assets/                                 # Vazir-Regular.ttf font & Hafez.png icon
└── .github/workflows/                      # ci.yml (analyze, test, apk) & release.yml
```

## Architecture & Key Flows
- **Entry Point (`lib/main.dart`):** Wraps `HafezControllerApp` in Riverpod's `ProviderScope`, watches `themeMode` from `hafezControllerProvider`, enforces `Locale('fa', 'IR')` RTL with `Vazir` font, and renders `HomePage`.
- **Pairing & Auth (`qr_scanner_page.dart` / `settings_page.dart` → `hafez_api_client.dart`):** Scans the QR payload emitted by Hafez desktop (`Ctrl+Q` → `{host, port, token, serverName}`) or authenticates via `POST /api/auth/login`. Persists connection config in `SharedPreferences`.
- **REST & SignalR Sync (`lib/data/hafez_api_client.dart`):**
  - Sends `Authorization: Bearer <token>` on REST calls (`/api/health`, `/api/state`, `/api/catalog/surahs`, `/api/catalog/mafatih`, `/api/catalog/personal-duas`, etc.).
  - Connects via `signalr_netcore` to the desktop's `/hub/hafez` hub for real-time `StateChanged` updates and `SendCommand` invocations with automatic reconnect.
- **State (`lib/state/hafez_controller_provider.dart`):** Central Riverpod provider managing connection status, `HafezLiveState`, fetched catalogs, and user preferences.

## Development & Commands
```bash
# Install Dart/Flutter dependencies
flutter pub get

# Static analysis & lints
flutter analyze

# Run unit & widget tests
flutter test

# Run on connected device / emulator
flutter run

# Build release Android APK
flutter build apk --release
```

## Configuration & Environment
- No `.env` files or bundled secrets.
- Server connection (`host`, `port` default `5050`, `token`, `serverName`) and theme mode are stored locally via `shared_preferences` at runtime.

## Conventions & Gotchas
- **Protocol coupling with `Hafez` desktop:** REST paths, SignalR hub method names (`StateChanged`, `SendCommand`), and JSON field casing (notice `hafez_api_client.dart` defensively checks both camelCase and PascalCase keys like `token`/`Token`) must stay compatible with `HafezWPFUI/Services/HafezRemoteServer.cs` in the sibling `Hafez` repo.
- **Cleartext HTTP on local Wi-Fi:** The app communicates with the desktop server over local LAN `http://<host>:<port>`; preserve cleartext traffic permissions in Android manifest / iOS ATS settings when updating platform configs.
- **Persian RTL UI:** All user-facing copy is Persian (`fa_IR`) using the bundled `Vazir` font; test layout changes in RTL directionality.
- **Destructive actions:** Camera stop and similar live-output interruptions intentionally prompt for confirmation in the UI to prevent accidental cutoffs during ceremonies.
