import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tip_splitter/app.dart';
import 'package:tip_splitter/data/shared_preferences_settings_repository.dart';

void main() {
  testWidgets('app renders Tip Splitter app bar', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = SharedPreferencesSettingsRepository(prefs);
    await tester.pumpWidget(TipSplitterApp(settingsRepository: repo));
    await tester.pumpAndSettle();
    expect(find.text('Tip Splitter'), findsOneWidget);
  });
}