# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter run                          # run on connected device/emulator
flutter test                         # run all tests
flutter test test/bloc/tip_bloc_test.dart  # run single test file
flutter analyze                      # lint
flutter build apk --release          # build release APK
flutter pub get                      # install dependencies
```

Localization files (`lib/l10n/app_localizations*.dart`) are auto-generated — run `flutter run` or `flutter build` to regenerate after editing `.arb` files.

## Architecture

Three-layer: **domain → data → UI**, wired together in `main.dart`.

### Domain (`lib/domain/`)
- `tip_calculator.dart` — pure function `calculateTip({bill, tipPct, people})` returning `TipResult`
- `models/` — `TipResult`, `Currency` (BRL/USD)
- `repository/settings_repository.dart` — abstract interface for persistence

### Data (`lib/data/`)
- `SharedPreferencesSettingsRepository` — sole implementation of `SettingsRepository`

### BLoC (`lib/bloc/`)
- `TipBloc` — holds calculator state (bill, tipPct, people). Stateless between sessions; receives tip default from `SettingsCubit` via `BlocListener` in `app.dart`
- `SettingsCubit` — persisted settings (currency, defaultTipPct). Provided at app root, loads from `SettingsRepository` on init

Both are provided at app root in `TipSplitterApp` (`app.dart`).

### UI (`lib/ui/`)
- `tip/tip_screen.dart` — main calculator screen, composed of cards
- `settings/settings_screen.dart` — currency and default tip preferences
- `common/` — shared widgets: `TapToEditField`, `TipPercentSelector`, `CurrencyInputFormatter`

### Localization
Supports `en` and `pt`. ARB sources live in `lib/l10n/`. Generated delegates in `app_localizations*.dart`. Currency default auto-detected from device locale on first launch (`pt` → BRL, otherwise USD).

### Theme
Material 3, system dark/light mode. Seed color `#3D5AFE`. Color tokens defined as constants in `app.dart`.
