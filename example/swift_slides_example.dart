import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swift_slides/swift_slides.dart'; // Ensure this imports the correct package

void main() {
  testWidgets('AdvancedCarousel widget test', (WidgetTester tester) async {
    // Create a Future to simulate async item fetching
    final itemsFuture = Future<List<Widget>>.delayed(
      Duration(seconds: 1),
      () => [
        Container(color: Colors.red, key: ValueKey('Red')),
        Container(color: Colors.green, key: ValueKey('Green')),
        Container(color: Colors.blue, key: ValueKey('Blue')),
      ],
    );

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Advanced Carousel Example'),
        ),
        body: Center(
          child: AdvancedCarousel(
            itemsFuture: itemsFuture,
            height: 250.0,
            autoPlay: false,
            infiniteScroll: true,
            transitionCurve: Curves.easeInOut,
            transitionDuration: Duration(seconds: 1),
            showIndicator: true,
            indicatorColor: Colors.white,
            indicatorSize: 12.0,
            indicatorAlignment: Alignment.bottomCenter,
            pauseOnInteraction: false, // Optional: set to false to not pause on interaction
          ),
        ),
      ),
    ));

    // Wait for the Future to complete and items to be displayed
    await tester.pumpAndSettle();

    // Verify the carousel has three items
    expect(find.byKey(ValueKey('Red')), findsOneWidget);
    expect(find.byKey(ValueKey('Green')), findsOneWidget);
    expect(find.byKey(ValueKey('Blue')), findsOneWidget);

    // Verify the carousel indicator is visible
    expect(find.byType(AnimatedContainer), findsWidgets);

    // Verify indicator properties using widget predicate
    expect(
      find.byWidgetPredicate(
        (widget) {
          if (widget is AnimatedContainer) {
            final BoxDecoration? decoration = widget.decoration as BoxDecoration?;
            return decoration?.color == Colors.white;
          }
          return false;
        },
      ),
      findsWidgets,
    );

    // Verify the height of the carousel by checking the SizedBox widget
    final SizedBox carouselSizedBox = tester.widget(find.byType(SizedBox)) as SizedBox;
    expect(carouselSizedBox.height, 250.0);

    // Optionally, verify specific properties of the indicators
    final indicatorFinder = find.byWidgetPredicate(
      (widget) {
        if (widget is AnimatedContainer) {
          final BoxDecoration? decoration = widget.decoration as BoxDecoration?;
          return decoration?.color == Colors.white;
        }
        return false;
      },
    );

    expect(indicatorFinder, findsWidgets);

    // Optionally, verify size of the indicator
    final indicators = tester.widgetList(indicatorFinder).toList();
    for (final widget in indicators) {
      if (widget is AnimatedContainer) {
        final BoxDecoration? decoration = widget.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.white);
        // Add checks for size if possible, e.g. by checking constraints
      }
    }
  });
}
