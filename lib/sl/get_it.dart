import 'package:get_it/get_it.dart';
import 'package:random_frame/data/js/js_bridge.dart';
import 'package:random_frame/data/supabase_file_storage.dart';
import 'package:random_frame/data/uploaded_files.dart';
import 'package:random_frame/ui/game/bloc/game_bloc.dart';
import 'package:random_frame/ui/home/bloc/home_bloc.dart';
import 'package:random_frame/ui/receipt/bloc/sharing_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

initDependencies() {
  getIt.registerLazySingleton<StorageFileApi>(
      () => Supabase.instance.client.storage.from('random-results'));
  getIt.registerLazySingleton<GoTrueClient>(
          () => Supabase.instance.client.auth);
  getIt.registerLazySingleton<JsBridge>(() => JsBridge());
  getIt.registerLazySingleton<SupabaseFileStorage>(
      () => SupabaseFileStorage(
          getIt<StorageFileApi>(),
          getIt<GoTrueClient>(),
          getIt<JsBridge>(),
      ));
  getIt.registerLazySingleton<UploadedFiles>(() => UploadedFiles());
  getIt.registerFactory<HomeBloc>(() => HomeBloc(getIt<JsBridge>()));
  getIt.registerFactory<GameBloc>(() => GameBloc());
  getIt.registerFactory<SharingBloc>(() => SharingBloc(
        getIt<JsBridge>(),
        getIt<SupabaseFileStorage>(),
        getIt<UploadedFiles>(),
      ));
}
