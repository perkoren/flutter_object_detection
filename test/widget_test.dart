// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

void main() {

  testWidgets('terms and conditions display', (WidgetTester tester) async {

   // await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(RichText), findsOneWidget);
    //expect(find.text("By tapping Continue, you agree to our"), findsOneWidget);
  });

}
