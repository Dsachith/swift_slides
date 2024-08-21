import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swift_slides/swift_slides.dart';

void main() {
  testWidgets('AdvancedCarousel displays items and indicator', (WidgetTester tester) async {
    // Create a Future to simulate async item fetching
    final itemsFuture = Future<List<Widget>>.delayed(
      Duration(seconds: 1),
      () => [
        Container(color: Colors.red, key: ValueKey('Red')),
        Container(color: Colors.green, key: ValueKey('Green')),
        Container(color: Colors.blue, key: ValueKey('Blue')),
      ],
    );

    // Build the AdvancedCarousel widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AdvancedCarousel(
          itemsFuture: itemsFuture,
          height: 250.0,
          autoPlay: false,
          showIndicator: true,
          indicatorColor: Colors.white,
          indicatorSize: 12.0,
          indicatorAlignment: Alignment.bottomCenter,
        ),
      ),
    ));

    // Wait for the Future to complete and items to be displayed
    await tester.pumpAndSettle();

    // Verify if the items are displayed
    expect(find.byKey(ValueKey('Red')), findsOneWidget);
    expect(find.byKey(ValueKey('Green')), findsOneWidget);
    expect(find.byKey(ValueKey('Blue')), findsOneWidget);

    // Verify the presence of AnimatedContainer for indicators
    final indicatorFinder = find.byWidgetPredicate(
      (widget) {
        if (widget is AnimatedContainer) {
          final AnimatedContainer container = widget;
          final decoration = container.decoration as BoxDecoration?;
          final color = decoration?.color;
          return color != null && color == Colors.white;
        }
        return false;
      },
    );
    expect(indicatorFinder, findsWidgets);
  });
}
