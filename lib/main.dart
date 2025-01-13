import 'package:fl_query/fl_query.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_dl/presentation/bloc/download/download_bloc.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/router.dart';
import 'package:youtube_dl/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory());
  FileDownloader.setLogEnabled(false);
  await QueryClient.initialize(
    cachePrefix: 'youtube_dl',
  );

  setupDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoaderBloc>(create: (context) => sl.get<LoaderBloc>()),
        BlocProvider<HistoryBloc>(create: (context) => sl.get<HistoryBloc>()),
        BlocProvider<DownloadBloc>(create: (context) => sl.get<DownloadBloc>())
      ],
      child: Builder(builder: (context) {
        return QueryClientProvider(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            builder: (ctx, widget) {
              return Scaffold(
                body: MultiBlocListener(listeners: [
                  BlocListener<DownloadBloc, DownloadState>(
                      bloc: sl.get<DownloadBloc>(),
                      listenWhen: (prev, next) => prev != next,
                      listener: (context, state) {
                        if (state is DownloadFinished) {
                          Fluttertoast.showToast(
                              msg: "Downloaded  at ${state.video.path} ");
                        }
                      }),
                  BlocListener<LoaderBloc, LoaderState>(
                    bloc: sl.get<LoaderBloc>(),
                    listenWhen: (prev, next) => prev != next,
                    listener: (context, state) {
                      if (state is LoaderStateLoading) {
                        showDialog(
                          context: navigatorKey.currentState!.context,
                          barrierDismissible: false,
                          builder: (ct) {
                            return Scaffold(
                              backgroundColor:
                                  Colors.black.withValues(alpha: 200),
                              body: Center(
                                  child: SpinKitFadingCircle(
                                      color: Theme.of(context).primaryColor)),
                            );
                          },
                        ).then((value) {});
                      } else {
                        Navigator.of(navigatorKey.currentState!.context,
                                rootNavigator: true)
                            .pop();
                      }
                    },
                  ),
                ], child: widget ?? const SizedBox.shrink()),
              );
            },
            title: 'Youtube DL',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF5D77)),
              useMaterial3: true,
              primaryColor: Color(0xFFFF5D77),
              textTheme: const TextTheme(
                bodySmall: TextStyle(fontSize: 14.0),
                bodyMedium: TextStyle(fontSize: 14.0),
              ),
            ).copyWith(),
            routerConfig: router,
          ),
        );
      }),
    );
  }
}
