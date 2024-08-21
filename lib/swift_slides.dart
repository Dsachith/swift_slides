import 'dart:async';
import 'package:flutter/material.dart';

class AdvancedCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final bool infiniteScroll;
  final Curve transitionCurve;
  final Duration transitionDuration;
  final bool showIndicator;
  final Color indicatorColor;
  final double indicatorSize;
  final Alignment indicatorAlignment;

  const AdvancedCarousel({
    Key? key,
    required this.items,
    this.height = 200.0,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.infiniteScroll = true,
    this.transitionCurve = Curves.easeInOut,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.showIndicator = true,
    this.indicatorColor = Colors.white,
    this.indicatorSize = 8.0,
    this.indicatorAlignment = Alignment.bottomCenter,
  }) : super(key: key);

  @override
  _AdvancedCarouselState createState() => _AdvancedCarouselState();
}

class _AdvancedCarouselState extends State<AdvancedCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentIndex + 1;

        if (nextPage < widget.items.length) {
          // Normal forward scroll
          _pageController.animateToPage(
            nextPage,
            duration: widget.transitionDuration,
            curve: widget.transitionCurve,
          );
        } else {
          // Loop back to the first item
          _pageController.jumpToPage(0);
        }
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return widget.items[index];
            },
          ),
        ),
        if (widget.showIndicator) _buildIndicator(),
      ],
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.items.length, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 100),
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            width: _currentIndex == index
                ? widget.indicatorSize * 1.5
                : widget.indicatorSize,
            height: widget.indicatorSize,
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? widget.indicatorColor
                  : widget.indicatorColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
