import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_frame/firebase_options.dart';
import 'package:random_frame/sl/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/js/js_layer.dart';
import 'log/bloc_logging.dart';

Future<void> initEverything() async {
  await dotenv.load(fileName: 'env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: dotenv.get('NEXT_PUBLIC_SUPABASE_URL', fallback: ''),
    anonKey: dotenv.get('NEXT_PUBLIC_SUPABASE_ANON_KEY', fallback: ''),
  );
  initDependencies();
  initJsBridge();
  initBlocLogging(enabled: true);
  await GoogleFonts.pendingFonts([
    GoogleFonts.lato(),
    GoogleFonts.righteous(),
    GoogleFonts.montserrat(),
    GoogleFonts.oxanium(),
  ]);
}
