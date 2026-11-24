import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temu_kampus/main.dart';

void main() {
  testWidgets('TemuKampusApp smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const TemuKampusApp());
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('TemuKampus UNIMAL'), findsOneWidget);
  });
}
