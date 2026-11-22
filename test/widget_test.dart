import 'package:flutter_test/flutter_test.dart';
import 'package:hafez_controller/main.dart';

void main() {
  testWidgets('HafezControllerApp renders navigation tabs cleanly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const HafezControllerApp());
    await tester.pumpAndSettle();

    expect(find.text('کنترل حافظ'), findsOneWidget);
    expect(find.text('اعلانات'), findsOneWidget);
    expect(find.text('دوربین'), findsOneWidget);
    expect(find.text('گالری'), findsOneWidget);
    expect(find.text('دعا و قرآن'), findsOneWidget);

    await tester.tap(find.text('دعا و قرآن'));
    await tester.pumpAndSettle();
    expect(find.text('قرآن'), findsOneWidget);
    expect(find.text('مفاتیح'), findsOneWidget);
  });
}
