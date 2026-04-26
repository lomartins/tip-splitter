import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/settings_repository.dart';
import '../../domain/models/currency.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(const SettingsState()) {
    _load();
  }

  final SettingsRepository _repository;
  bool _isLoaded = false;

  Future<void> _load() async {
    final saved = await _repository.load();
    if (!_isLoaded) {
      _isLoaded = true;
      emit(saved);
    }
  }

  void setCurrency(Currency currency) {
    _isLoaded = true;
    _repository.saveCurrency(currency);
    emit(state.copyWith(currency: currency));
  }

  void setDefaultTipPct(double pct) {
    _isLoaded = true;
    final clamped = pct.clamp(0.0, 100.0);
    _repository.saveDefaultTipPct(clamped);
    emit(state.copyWith(defaultTipPct: clamped));
  }
}
