import 'dart:async';

import 'package:flutter/material.dart';

import '../models/work.dart';

class HeroWorkCarousel extends StatefulWidget {
  const HeroWorkCarousel({
    super.key,
    required this.works,
    required this.onTap,
  });

  final List<Work> works;
  final ValueChanged<Work> onTap;

  @override
  State<HeroWorkCarousel> createState() => _HeroWorkCarouselState();
}

class _HeroWorkCarouselState extends State<HeroWorkCarousel> {
  late final PageController _controller;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.78);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.works.length <= 1) {
      return;
    }
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted || !_controller.hasClients) return;
      final nextPage = (_currentPage + 1) % widget.works.length;
      setState(() {
        _currentPage = nextPage;
      });
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.works.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const viewportFraction = 0.78;
        const aspectRatio = 16 / 9;
        final viewportWidth = constraints.maxWidth;
        final slideWidth = viewportWidth * viewportFraction;
        final height = slideWidth / aspectRatio;

        return Column(
          children: [
            SizedBox(
              height: height,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.works.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_controller.position.haveDimensions) {
                        final currentPage =
                            _controller.page ?? _controller.initialPage.toDouble();
                        value = currentPage - index;
                        value = (1 - (value.abs() * 0.2)).clamp(0.9, 1.0);
                      }
                      return Center(
                        child: SizedBox(
                          height: height * value,
                          child: child,
                        ),
                      );
                    },
                    child: _HeroSlide(
                      work: widget.works[index],
                      onTap: () => widget.onTap(widget.works[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: List.generate(widget.works.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 36 : 16,
                  height: 4,
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black.withOpacity(0.2),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

class _HeroSlide extends StatelessWidget {
  const _HeroSlide({required this.work, required this.onTap});

  final Work work;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              work.thumbnail,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
            Positioned(
              left: 32,
              right: 32,
              bottom: 32,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  work.category,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  work.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
