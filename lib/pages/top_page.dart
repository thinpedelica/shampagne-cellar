import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/hero_work_carousel.dart';
import '../components/site_header.dart';
import '../components/work_card.dart';
import '../models/work.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.works, this.initialSection});

  final List<Work> works;
  final String? initialSection;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  late final List<Work> _sortedWorks = [...widget.works]
    ..sort((a, b) => b.year.compareTo(a.year));

  final _aboutKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool _initialScrollDone = false;

  List<Work> get _heroWorks {
    final pinned = _sortedWorks.where((w) => w.heroOrder != null).toList();
    if (pinned.isNotEmpty) {
      pinned.sort((a, b) => a.heroOrder!.compareTo(b.heroOrder!));
      return pinned;
    }
    return _sortedWorks.take(5).toList();
  }
  List<Work> get _worksForGrid => _sortedWorks;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeScrollToInitialSection();
    });
  }

  @override
  void didUpdateWidget(covariant TopPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSection != widget.initialSection) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeScrollToInitialSection(force: true);
      });
    }
  }

  void _maybeScrollToInitialSection({bool force = false}) {
    if ((widget.initialSection == 'about' && !_initialScrollDone) || force) {
      _scrollToAbout();
      _initialScrollDone = true;
    }
  }

  void _scrollToAbout() {
    final context = _aboutKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 960;
    final horizontalPadding = isWide ? 96.0 : 24.0;
    const sectionSpacing = 64.0;
    return Scaffold(
      appBar: SiteHeader(
        onLogoTap: () => context.go('/'),
        onWorksTap: () => context.go('/works'),
        onAboutTap: _scrollToAbout,
        onContactTap: () => context.go('/contact'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroWorkCarousel(
              works: _heroWorks,
              onTap: (work) => context.go('/work/${work.id}'),
            ),
            const SizedBox(height: sectionSpacing),
            KeyedSubtree(
              key: _aboutKey,
              child: _SelfIntroduction(),
            ),
            const SizedBox(height: sectionSpacing),
            Text(
              'Works',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final gap = 32.0;
                final width =
                    isWide ? (constraints.maxWidth - gap) / 2 : constraints.maxWidth;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: _worksForGrid
                      .map((work) => SizedBox(
                            width: width,
                            child: WorkCard(
                              work: work,
                              onTap: () => context.go('/work/${work.id}'),
                              showTags: false,
                            ),
                          ))
                      .toList(),
                );
              },
            ),
            const SizedBox(height: sectionSpacing),
            FilledButton(
              onPressed: () => context.go('/works'),
              child: const Text('See all works'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelfIntroduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(
          'Shampagne has worked in production activities such as VJ and installation.\n'
          'His main means of expression is data analysis and real-time visual generation through programming.\n'
          'He plays with visual perception between the cutting edge and the classical.',
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
