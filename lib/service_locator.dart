import 'package:get_it/get_it.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
final sl = GetIt.instance;

setupDependency(){
  sl.registerSingleton<YoutubeExplode>(YoutubeExplode());
  sl.registerSingleton<LoaderBloc>(LoaderBloc());
  sl.registerSingleton<HistoryBloc>(HistoryBloc());
}