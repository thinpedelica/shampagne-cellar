import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/site_header.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  static final List<_ContactItem> _items = [
    _ContactItem(
      icon: Icons.mail_outline,
      label: 'Email',
      displayValue: 'thinpedelica@gmail.com',
      url: 'mailto:thinpedelica@gmail.com',
    ),
    _ContactItem(
      icon: Icons.camera_alt_outlined,
      label: 'Instagram',
      displayValue: 'instagram.com/shampagne.vsop',
      url: 'https://www.instagram.com/shampagne.vsop',
    ),
    _ContactItem(
      icon: Icons.alternate_email,
      label: 'X (Twitter)',
      displayValue: 'x.com/Shampedelica',
      url: 'https://x.com/Shampedelica',
    ),
    _ContactItem(
      icon: Icons.code,
      label: 'GitHub',
      displayValue: 'github.com/thinpedelica',
      url: 'https://github.com/thinpedelica',
    ),
    _ContactItem(
      icon: Icons.article_outlined,
      label: 'Blog',
      displayValue: 'shampagne.hatenablog.com',
      url: 'https://shampagne.hatenablog.com/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SiteHeader(
        onLogoTap: () => context.go('/'),
        onWorksTap: () => context.go('/works'),
        onAboutTap: () => context.go('/?section=about'),
        onContactTap: () {},
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontal = constraints.maxWidth > 900 ? 96.0 : 24.0;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 64),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    ..._items.map((item) => _ContactRow(item: item)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.item});

  final _ContactItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final labelStyle = textTheme.labelMedium?.copyWith(
          letterSpacing: 2,
          fontWeight: FontWeight.w600,
          color: Colors.black.withOpacity(0.5),
        );
    final valueStyle = textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launch(item.url),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;
              return Flex(
                direction: isNarrow ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 18,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      const SizedBox(width: 12),
                      Text(item.label.toUpperCase(), style: labelStyle),
                    ],
                  ),
                  const SizedBox(height: 8, width: 24),
                  SelectableText(
                    item.displayValue,
                    style: valueStyle,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ContactItem {
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.displayValue,
    required this.url,
  });

  final IconData icon;
  final String label;
  final String displayValue;
  final String url;
}

Future<void> _launch(String link) async {
  final uri = Uri.parse(link);
  if (!await launchUrl(uri)) {
    debugPrint('Could not launch $link');
  }
}
