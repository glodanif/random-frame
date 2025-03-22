import 'package:get_it/get_it.dart';
import 'package:random_frame/data/js/js_bridge.dart';
import 'package:random_frame/ui/game/bloc/game_bloc.dart';
import 'package:random_frame/ui/home/bloc/home_bloc.dart';
import 'package:random_frame/ui/receipt/bloc/sharing_bloc.dart';

final getIt = GetIt.instance;

initDependencies() {
  getIt.registerLazySingleton<JsBridge>(() => JsBridge());
  getIt.registerFactory<HomeBloc>(() => HomeBloc(getIt<JsBridge>()));
  getIt.registerFactory<GameBloc>(() => GameBloc());
  getIt.registerFactory<SharingBloc>(() => SharingBloc(getIt<JsBridge>()));
}
