# Changelog

## v2.0.0 (2026-11-22)

### 🚀 Platform & Architecture
- Upgraded to **Flutter 3 / Dart 3 / Material 3** with Light & Dark Mode support and `flutter_lints`.
- Modernized Android Gradle/Kotlin build (`AGP 8.6.0`, `Gradle 8.7`, `Kotlin 2.0.21`, `compileSdk 36`, `minSdk 23`, Java 17).
- Introduced **Riverpod** state management (`HafezControllerNotifier`) and persistent settings via `shared_preferences`.

### 📡 SignalR, REST API & QR Pairing
- Implemented `HafezApiClient` connecting to `Hafez` v2.0's embedded ASP.NET Core Minimal API and **SignalR Hub** (`/hub/hafez`) with automatic reconnect.
- Added **QR Code Scanner** (`mobile_scanner`) to pair with `Hafez` desktop (`Ctrl+Q`) in one scan.
- Added manual IP/Port + username/password login in `SettingsPage`.

### 📱 Complete Operator UI
- Fixed bottom `NavigationBar` tab switching, duplicate widget classes, and horizontal layout overflows.
- Added live connection status badge (Connected / Connecting / Offline) in the AppBar.
- Wired **Notifications** (group dropdown, urgent announcement banner toggle, ticker play/pause), **Quran / Mafatih / Personal Dua** (live catalog dropdowns + synced transport controls), **Camera** (with stop confirmation), and **Gallery** (live folder dropdown + slideshow controls).
- Added haptic feedback, SnackBar error reporting, unit/widget tests, and automated Android APK release CI/CD.
