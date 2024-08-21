import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Finds an AnimatedContainer with specific properties',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: AnimatedContainer(
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            duration: const Duration(seconds: 1),
          ),
        ),
      ),
    ));

    expect(
      find.byWidgetPredicate(
        (widget) {
          if (widget is AnimatedContainer) {
            final decoration = widget.decoration;
            if (decoration is BoxDecoration) {
              return decoration.color == Colors.red;
            }
          }
          return false;
        },
      ),
      findsOneWidget,
    );


    final renderBox =
        tester.renderObject<RenderBox>(find.byType(AnimatedContainer));
    expect(renderBox.size.width, 12.0);
    expect(renderBox.size.height, 12.0);
  });
}
