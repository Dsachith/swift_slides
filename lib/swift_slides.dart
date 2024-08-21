import 'dart:async';
import 'package:flutter/material.dart';

class AdvancedCarousel extends StatefulWidget {
  final Future<List<Widget>>? itemsFuture; // Support for dynamic content
  final Widget Function(BuildContext context, int index)? itemBuilder; // Custom item builder
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
  final bool pauseOnInteraction; // Pause on user interaction
  final Function(int index)? onItemChanged; // Event callback for item change

  const AdvancedCarousel({
    Key? key,
    this.itemsFuture,
    this.itemBuilder,
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
    this.pauseOnInteraction = true,
    this.onItemChanged,
  }) : super(key: key);

  @override
  _AdvancedCarouselState createState() => _AdvancedCarouselState();
}

class _AdvancedCarouselState extends State<AdvancedCarousel> {
  late PageController _pageController;
  late Future<List<Widget>> _itemsFuture;
  List<Widget> _items = [];
  int _currentIndex = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _itemsFuture = widget.itemsFuture ?? Future.value([]);
    _itemsFuture.then((items) {
      setState(() {
        _items = items;
        if (widget.autoPlay) {
          _startAutoPlay();
        }
      });
    });
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentIndex + 1;

        if (nextPage < _items.length) {
          _pageController.animateToPage(
            nextPage,
            duration: widget.transitionDuration,
            curve: widget.transitionCurve,
          );
        } else if (widget.infiniteScroll) {
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
    return GestureDetector(
      onPanUpdate: (details) {
        if (widget.pauseOnInteraction) {
          _autoPlayTimer?.cancel();
        }
      },
      onPanEnd: (details) {
        if (widget.pauseOnInteraction && widget.autoPlay) {
          _startAutoPlay();
        }
      },
      child: Stack(
        alignment: widget.indicatorAlignment,
        children: [
          SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.infiniteScroll ? _items.length * 2 : _items.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index % _items.length;
                  if (widget.onItemChanged != null) {
                    widget.onItemChanged!(_currentIndex);
                  }
                });
              },
              itemBuilder: (context, index) {
                final actualIndex = index % _items.length;
                return widget.itemBuilder != null
                    ? widget.itemBuilder!(context, actualIndex)
                    : _items[actualIndex];
              },
            ),
          ),
          if (widget.showIndicator) _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_items.length, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            width: _currentIndex == index ? widget.indicatorSize * 1.5 : widget.indicatorSize,
            height: widget.indicatorSize,
            decoration: BoxDecoration(
              color: _currentIndex == index ? widget.indicatorColor : widget.indicatorColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
