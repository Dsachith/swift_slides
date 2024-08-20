import 'package:flutter/material.dart';
import 'package:swift_slides/swift_slides.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Advanced Carousel Example'),
        ),
        body: Center(
          child: AdvancedCarousel(
            items: [
              Container(color: Colors.red),
              Container(color: Colors.green),
              Container(color: Colors.blue),
            ],
            height: 250.0,
            autoPlay: true,
            infiniteScroll: true,
            transitionCurve: Curves.easeInOut,
            transitionDuration: Duration(seconds: 1),
            showIndicator: true,
            indicatorColor: Colors.white,
            indicatorAlignment: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
