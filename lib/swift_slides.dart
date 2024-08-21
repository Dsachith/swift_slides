import 'dart:async';
import 'package:flutter/material.dart';

class AdvancedCarousel extends StatefulWidget {
  final List<Widget>? items;
  final Future<List<Widget>> Function()? itemLoader; // Dynamic Content Loader
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
  final BoxShape indicatorShape;
  final bool pauseOnHover;
  final ValueChanged<int>? onPageChanged;
  final IndexedWidgetBuilder? itemBuilder;
  final int itemCount;
  final TransitionEffect transitionEffect; // Customizable Transitions
  final bool enableLazyLoading; // Lazy Loading
  final bool accessibilityEnabled; // Accessibility Features
  final Function(int)? onItemChanged; // Event Callback

  const AdvancedCarousel({
    Key? key,
    this.items,
    this.itemLoader,
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
    this.indicatorShape = BoxShape.circle,
    this.pauseOnHover = false,
    this.onPageChanged,
    this.itemBuilder,
    this.itemCount = 0,
    this.transitionEffect = TransitionEffect.slide,
    this.enableLazyLoading = true,
    this.accessibilityEnabled = true,
    this.onItemChanged,
  })  : assert(items != null || itemLoader != null || itemBuilder != null),
        super(key: key);

  @override
  _AdvancedCarouselState createState() => _AdvancedCarouselState();
}

enum TransitionEffect { slide, fade, zoom, rotate }

class _AdvancedCarouselState extends State<AdvancedCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoPlayTimer;
  bool _isHovered = false;
  List<Widget> _items = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    if (widget.itemLoader != null) {
      _loadItems();
    } else {
      _items = widget.items ?? [];
    }

    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  Future<void> _loadItems() async {
    setState(() => _loading = true);
    _items = await widget.itemLoader!();
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (!_isHovered && _pageController.hasClients) {
        int nextPage = _currentIndex + 1;
        if (nextPage >= _getItemCount()) {
          nextPage = widget.infiniteScroll ? 0 : _getItemCount() - 1;
        }
        _pageController.animateToPage(
          nextPage,
          duration: widget.transitionDuration,
          curve: widget.transitionCurve,
        );
      }
    });
  }

  int _getItemCount() {
    if (widget.itemBuilder != null) {
      return widget.itemCount;
    }
    return _items.length;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onPanDown: (_) {
        if (widget.pauseOnHover) {
          _isHovered = true;
          _autoPlayTimer?.cancel();
        }
      },
      onPanEnd: (_) {
        if (widget.pauseOnHover) {
          _isHovered = false;
          if (widget.autoPlay) {
            _startAutoPlay();
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.infiniteScroll ? null : _getItemCount(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index % _getItemCount();
                });
                if (widget.onPageChanged != null) {
                  widget.onPageChanged!(_currentIndex);
                }
                if (widget.onItemChanged != null) {
                  widget.onItemChanged!(_currentIndex);
                }
              },
              itemBuilder: (context, index) {
                final actualIndex = index % _getItemCount();
                final child = widget.itemBuilder != null
                    ? widget.itemBuilder!(context, actualIndex)
                    : _items[actualIndex];
                return _buildTransition(child, actualIndex);
              },
            ),
          ),
          if (widget.showIndicator) _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildTransition(Widget child, int index) {
    switch (widget.transitionEffect) {
      case TransitionEffect.fade:
        return AnimatedOpacity(
          opacity: _currentIndex == index ? 1.0 : 0.0,
          duration: widget.transitionDuration,
          child: child,
        );
      case TransitionEffect.zoom:
        return AnimatedScale(
          scale: _currentIndex == index ? 1.0 : 0.8,
          duration: widget.transitionDuration,
          child: child,
        );
      case TransitionEffect.rotate:
        return AnimatedRotation(
          turns: _currentIndex == index ? 0.0 : 1.0,
          duration: widget.transitionDuration,
          child: child,
        );
      case TransitionEffect.slide:
      default:
        return child;
    }
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_getItemCount(), (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: _currentIndex == index ? widget.indicatorSize * 1.5 : widget.indicatorSize,
            height: widget.indicatorSize,
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? widget.indicatorColor
                  : widget.indicatorColor.withOpacity(0.5),
              shape: widget.indicatorShape,
            ),
          );
        }),
      ),
    );
  }
}
