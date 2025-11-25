import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/site_header.dart';
import '../components/video_embed.dart';
import '../components/work_card.dart';
import '../models/work.dart';

class WorkDetailPage extends StatelessWidget {
  const WorkDetailPage({
    super.key,
    required this.work,
    required this.relatedWorks,
  });

  final Work work;
  final List<Work> relatedWorks;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding =
        MediaQuery.of(context).size.width > 900 ? 96.0 : 24.0;
    final textTheme = Theme.of(context).textTheme;
    final hasVideo = (work.videoId ?? '').isNotEmpty || (work.videoUrl ?? '').isNotEmpty;
    return Scaffold(
      appBar: SiteHeader(
        onLogoTap: () => context.go('/'),
        onWorksTap: () => context.go('/works'),
        onAboutTap: () => context.go('/?section=about'),
        onContactTap: () => context.go('/contact'),
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: work.thumbnail.isNotEmpty
                  ? Image.asset(
                      work.thumbnail,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: work.accentColor.withOpacity(0.4),
                    ),
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  work.category.toUpperCase(),
                  style: textTheme.labelMedium?.copyWith(letterSpacing: 2),
                ),
                const SizedBox(height: 12),
                Text(
                  work.title,
                  style: textTheme.displaySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  '${work.year}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.black.withOpacity(0.08)),
              ],
            ),
            Text(
              work.description,
              style: textTheme.bodyLarge,
            ),
            if (work.tags.isNotEmpty) ...[
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: work.tags
                    .map((tag) => Text(
                          tag.toUpperCase(),
                          style: textTheme.labelMedium?.copyWith(
                            letterSpacing: 1.2,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ))
                    .toList(),
              ),
            ],
            if (hasVideo) ...[
              const SizedBox(height: 32),
              VideoEmbed(work: work),
            ],
            if (work.images.isNotEmpty) ...[
              const SizedBox(height: 32),
              _WorkGallery(images: work.images),
            ],
            if (relatedWorks.isNotEmpty) ...[
              const SizedBox(height: 48),
              Text(
                'More in ${work.category}',
                style: textTheme.headlineSmall,
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
                    children: relatedWorks
                        .map((w) => SizedBox(
                              width: width,
                              child: WorkCard(
                                work: w,
                                onTap: () => context.go('/work/${w.id}'),
                                showTags: false,
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WorkGallery extends StatelessWidget {
  const _WorkGallery({required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: images
              .map(
                (path) => SizedBox(
                  width: 360,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      path,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
