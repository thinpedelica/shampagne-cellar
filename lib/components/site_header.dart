import 'package:flutter/material.dart';

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  const SiteHeader({
    super.key,
    required this.onLogoTap,
    required this.onWorksTap,
    required this.onAboutTap,
    required this.onContactTap,
  });

  final VoidCallback onLogoTap;
  final VoidCallback onWorksTap;
  final VoidCallback onAboutTap;
  final VoidCallback onContactTap;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      bottom: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onLogoTap,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'SHAMPAGNE CELLAR',
                  style: textTheme.titleMedium?.copyWith(
                    letterSpacing: 2,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            const Spacer(),
            _NavButton(label: 'Works', onTap: onWorksTap),
            _NavButton(label: 'About', onTap: onAboutTap),
            _NavButton(label: 'Contact', onTap: onContactTap),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  letterSpacing: 1.2,
                  color: Colors.black.withOpacity(0.55),
                ),
          ),
        ),
      ),
    );
  }
}
