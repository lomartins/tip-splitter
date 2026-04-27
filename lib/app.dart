import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tip_splitter/l10n/app_localizations.dart';

import 'bloc/settings/settings_cubit.dart';
import 'bloc/settings/settings_state.dart';
import 'bloc/tip/tip_bloc.dart';
import 'bloc/tip/tip_event.dart';
import 'domain/repository/settings_repository.dart';
import 'ui/tip/tip_screen.dart';

// Light: derived from oklch tokens in design + #3D5AFE primary (from tweaks)
// Dark: explicit hex values from design darkMode overrides
const _seedColor = Color(0xFF3D5AFE);
const _seedColorDark = Color.fromARGB(255, 100, 122, 244);

final _lightScheme =
    ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: _seedColor,
      onPrimaryContainer: _seedColor,
      surface: const Color(0xFFF6F9FB),
      onSurface: const Color(0xFF0E1216),
      surfaceContainerHighest: const Color(0xFFE0E6EA),
      surfaceContainerLow: const Color(0xFFF8FAFC),
      onSurfaceVariant: const Color(0xFF444F57),
      outline: const Color(0xFF96A0A7),
      outlineVariant: const Color(0xFFC5CBD0),
    );

final _darkScheme =
    ColorScheme.fromSeed(
      seedColor: _seedColorDark,
      brightness: Brightness.dark,
    ).copyWith(
      primary: _seedColor,
      surface: const Color(0xFF1C1C1E),
      onSurface: const Color(0xFFF2F2F7),
      surfaceContainerHighest: const Color(0xFF3A3A3C),
      surfaceContainerLow: const Color(0xFF2C2C2E),
      onSurfaceVariant: const Color(0xFFA6A6AD),
      secondaryContainer: const Color(0xFFD3E7FF),
      onSecondaryContainer: const Color(0xFF001E2B),
      outlineVariant: const Color(0xFF454547),
      outline: const Color(0xFF969FA6),
    );

ThemeData _buildTheme(ColorScheme scheme) => ThemeData(
  colorScheme: scheme,
  useMaterial3: true,
  scaffoldBackgroundColor: scheme.surface,
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 1,
  ),
);

class TipSplitterApp extends StatelessWidget {
  const TipSplitterApp({super.key, required this.settingsRepository});

  final SettingsRepository settingsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => SettingsCubit(settingsRepository),
      child: BlocProvider<TipBloc>(
        create: (_) => TipBloc(),
        child: BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (a, b) => a.defaultTipPct != b.defaultTipPct,
          listener: (context, settings) => context.read<TipBloc>().add(
            TipPctChanged(settings.defaultTipPct),
          ),
          child: MaterialApp(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pt')],
            theme: _buildTheme(_lightScheme),
            darkTheme: _buildTheme(_darkScheme),
            themeMode: ThemeMode.system,
            home: const TipScreen(),
          ),
        ),
      ),
    );
  }
}
