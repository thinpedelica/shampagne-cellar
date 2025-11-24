import 'package:flutter/material.dart';

import '../models/work.dart';

class WorkCard extends StatelessWidget {
  const WorkCard({
    super.key,
    required this.work,
    this.onTap,
    this.showTags = true,
  });

  final Work work;
  final VoidCallback? onTap;
  final bool showTags;

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.black.withOpacity(0.08);
    final tagStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 1.2,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.6),
        );

    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumbnail(work: work),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    work.category.toUpperCase(),
                    style: tagStyle,
                  ),
                  Text(
                    '${work.year}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                work.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                work.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              if (showTags && work.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: work.tags
                      .map((tag) => Text(
                            tag.toUpperCase(),
                            style: tagStyle,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.work});

  final Work work;

  @override
  Widget build(BuildContext context) {
    if (work.thumbnail.isNotEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          work.thumbnail,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: work.accentColor.withOpacity(0.4),
      ),
    );
  }
}
