import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_frame/data/js/js_layer.dart';
import 'package:random_frame/domain/game_type.dart';
import 'package:random_frame/firebase_options.dart';
import 'package:random_frame/log/bloc_logging.dart';
import 'package:random_frame/sl/get_it.dart';
import 'package:random_frame/ui/game/game_page.dart';
import 'package:random_frame/ui/home/home_page.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

const lightTheme = "light";
const darkTheme = "dark";
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initSaas();
  initDependencies();
  initJsBridge();
  initBlocLogging(enabled: true);
  runApp(RandomApp());
}

Future<void> initSaas() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: dotenv.env['NEXT_PUBLIC_SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['NEXT_PUBLIC_SUPABASE_ANON_KEY'] ?? '',
  );
}

class RandomApp extends StatelessWidget {
  RandomApp({super.key});

  final GoRouter _router = GoRouter(
    observers: <NavigatorObserver>[
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: !kReleaseMode,
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: const [],
      ),
      GoRoute(
        path: '/game',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final type = state.queryParameters['type'];
          final GameType gameType = type != null
              ? GameType.values.byName(type)
              : throw ArgumentError("Invalid game type: $type");
          return MaterialPage(child: GamePage(gameType: gameType));
        },
      ),
    ],
  );

  final _lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0XFFF1F6F9),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF151638),
      dragHandleColor: Color(0xFF50516D),
      dragHandleSize: Size(64, 8),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFFBFBF9),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0XFF222345),
      onPrimary: Color(0XFFF1F6F9),
      secondary: Color(0x7750516D),
      onSecondary: Color(0XFF000000),
      surface: Colors.black12,
      onSurface: Color(0XFF000000),
      error: Colors.redAccent,
      onError: Color(0XFFFFFFFF),
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.righteous(
        textStyle: const TextStyle(
          fontSize: 28.0,
          color: Color(0XFFEEEEEA),
        ),
      ),
      bodyMedium: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      titleMedium: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFF000B1A),
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bodyLarge: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFF000B1A),
          fontSize: 24.0,
        ),
      ),
      labelMedium: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFF000B1A),
          fontSize: 18.0,
        ),
      ),
      labelSmall: GoogleFonts.lato(
        textStyle: const TextStyle(
          color: Color(0XFF000B1A),
          fontSize: 16.0,
        ),
      ),
      bodySmall: GoogleFonts.lato(
        textStyle: const TextStyle(
          color: Color(0x7750516D),
          fontSize: 16.0,
        ),
      ),
    ),
  );

  final _darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0XFF17212B),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0XFF222345),
      onPrimary: Color(0XFF000000),
      secondary: Color(0XFF2B5278),
      onSecondary: Color(0XFF000000),
      surface: Colors.white12,
      onSurface: Color(0XFF000000),
      error: Colors.redAccent,
      onError: Color(0XFFFFFFFF),
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.righteous(
        textStyle: const TextStyle(
          fontSize: 28.0,
          color: Color(0XFFEEEEEA),
        ),
      ),
      bodyMedium: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      titleMedium: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFFEEEEEA),
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bodyLarge: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFFEEEEEA),
          fontSize: 24.0,
        ),
      ),
      labelMedium: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFFEEEEEA),
          fontSize: 18.0,
        ),
      ),
      bodySmall: GoogleFonts.lato(
        textStyle: const TextStyle(
          color: Colors.white54,
          fontSize: 16.0,
        ),
      ),
    ),
  );

  final _breakpoints = [
    const Breakpoint(start: 0, end: 450, name: 'TINY'),
    const Breakpoint(start: 451, end: 750, name: MOBILE),
    const Breakpoint(start: 751, end: 1200, name: TABLET),
    const Breakpoint(start: 1201, end: double.infinity, name: DESKTOP),
  ];

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme(
          id: lightTheme,
          description: "Light Theme",
          data: _lightTheme,
        ),
        AppTheme(
          id: darkTheme,
          description: "Dark Theme",
          data: _darkTheme,
        ),
      ],
      child: ThemeConsumer(
        child: Builder(builder: (themeContext) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEBD1FB), Color(0xFFFBFBF9)],
              ),
            ),
            child: MaterialApp.router(
              title: 'Random',
              theme: ThemeProvider.themeOf(themeContext).data,
              routerConfig: _router,
              debugShowCheckedModeBanner: !kReleaseMode,
              builder: (context, child) => ResponsiveBreakpoints.builder(
                child: child ?? const Placeholder(),
                breakpoints: _breakpoints,
              ),
            ),
          );
        }),
      ),
    );
  }
}
