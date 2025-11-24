import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/work_repository.dart';
import 'models/work.dart';
import 'pages/contact_page.dart';
import 'pages/not_found_page.dart';
import 'pages/top_page.dart';
import 'pages/work_detail_page.dart';
import 'pages/work_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final works = await WorkRepository.loadWorks();
  runApp(WorkApp(works: works));
}

class WorkApp extends StatelessWidget {
  WorkApp({super.key, required this.works});

  final List<Work> works;

  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'top',
        builder: (context, state) => TopPage(
          works: works,
          initialSection: state.uri.queryParameters['section'],
        ),
      ),
      GoRoute(
        path: '/works',
        name: 'works',
        builder: (context, state) => WorkListPage(
          works: works,
        ),
      ),
      GoRoute(
        path: '/work/:id',
        name: 'work-detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final work = WorkRepository.findById(works, id);
          if (work == null) {
            return NotFoundPage(message: 'Work "$id" was not found.');
          }
          return WorkDetailPage(
            work: work,
            relatedWorks: WorkRepository.relatedWorks(works, work),
          );
        },
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const ContactPage(),
      ),
    ],
    errorBuilder: (context, state) =>
        NotFoundPage(message: state.error?.toString() ?? 'Page not found'),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = const ColorScheme.light(
      background: Colors.white,
      surface: Colors.white,
      primary: Color(0xFF111111),
      onPrimary: Colors.white,
      secondary: Color(0xFF4E4E4E),
      onSecondary: Colors.white,
      onSurface: Color(0xFF111111),
    );

    final baseTextTheme = ThemeData.light().textTheme;
    final interTheme = GoogleFonts.interTextTheme(baseTextTheme);
    final textTheme = interTheme
        .apply(
          bodyColor: const Color(0xFF111111),
          displayColor: const Color(0xFF111111),
        )
        .copyWith(
          displaySmall: interTheme.displaySmall?.copyWith(
            fontSize: 44,
            fontWeight: FontWeight.w600,
            height: 1.15,
          ),
          headlineMedium: interTheme.headlineMedium?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
          headlineSmall: interTheme.headlineSmall?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
          titleLarge: interTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: interTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: interTheme.bodyLarge?.copyWith(
            fontSize: 16,
            height: 1.7,
          ),
          bodyMedium: interTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.6,
          ),
          labelMedium: interTheme.labelMedium?.copyWith(
            letterSpacing: 1.5,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        );

    final primaryFont = GoogleFonts.inter().fontFamily;
    final fallbackFont = GoogleFonts.notoSansJp().fontFamily ?? 'Noto Sans JP';

    return MaterialApp.router(
      title: 'Shampagne Cellar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: primaryFont,
        fontFamilyFallback: [fallbackFont],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF111111),
          elevation: 0,
        ),
        textTheme: textTheme,
        cardTheme: const CardTheme(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          color: Colors.white,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            backgroundColor: const Color(0xFF111111),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            foregroundColor: const Color(0xFF111111),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.black.withOpacity(0.05),
          thickness: 1,
        ),
      ),
      routerConfig: _router,
    );
  }
}
