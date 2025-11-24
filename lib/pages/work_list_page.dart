import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/site_header.dart';
import '../components/work_card.dart';
import '../data/work_repository.dart';
import '../models/work.dart';

class WorkListPage extends StatelessWidget {
  const WorkListPage({super.key, required this.works});

  final List<Work> works;

  static const _preferredOrder = ['VJ', 'MV', 'Art'];

  @override
  Widget build(BuildContext context) {
    final grouped = WorkRepository.groupByCategory(works);
    final categories = [
      ..._preferredOrder.where((c) => grouped.keys.contains(c)),
      ...grouped.keys.where((c) => !_preferredOrder.contains(c)),
    ];

    return Scaffold(
      appBar: SiteHeader(
        onLogoTap: () => context.go('/'),
        onWorksTap: () => context.go('/works'),
        onAboutTap: () => context.go('/?section=about'),
        onContactTap: () => context.go('/contact'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        itemBuilder: (context, index) {
          final category = categories[index];
          final items = grouped[category] ?? [];
          return _CategorySection(category: category, works: items);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 48),
        itemCount: categories.length,
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category, required this.works});

  final String category;
  final List<Work> works;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(letterSpacing: 2),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final gap = 32.0;
            final cardWidth = isWide ? (constraints.maxWidth - gap) / 2 : double.infinity;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: works
                  .map((work) => SizedBox(
                        width: cardWidth,
                        child: WorkCard(
                          work: work,
                          onTap: () => context.go('/work/${work.id}'),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
