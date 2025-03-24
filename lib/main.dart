import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:random_frame/app_theme.dart';
import 'package:random_frame/domain/game_type.dart';
import 'package:random_frame/initializer.dart';
import 'package:random_frame/ui/game/game_page.dart';
import 'package:random_frame/ui/home/home_page.dart';

void main() async {
  await initEverything();
  runApp(RandomApp());
}

class RandomApp extends StatelessWidget {
  RandomApp({super.key});

  final GoRouter _router = GoRouter(
    observers: <NavigatorObserver>[
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    debugLogDiagnostics: !kReleaseMode,
    initialLocation: '/',
    navigatorKey: GlobalKey<NavigatorState>(),
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/game',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final type = state.uri.queryParameters['type'];
          final GameType gameType = type != null
              ? GameType.values.byName(type)
              : throw ArgumentError("Invalid game type: $type");
          return MaterialPage(child: GamePage(gameType: gameType));
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (themeContext) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientBackgroundStart, gradientBackgroundEnd],
          ),
        ),
        child: MaterialApp.router(
          title: 'Random',
          theme: randomTheme,
          routerConfig: _router,
          debugShowCheckedModeBanner: !kReleaseMode,
          builder: (context, child) => child ?? const Placeholder(),
        ),
      );
    });
  }
}
