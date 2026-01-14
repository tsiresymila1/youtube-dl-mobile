import 'package:fl_query/fl_query.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:youtube_dl/core/background_service.dart';
import 'package:youtube_dl/core/log.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';
import 'package:youtube_dl/presentation/bloc/download/download_bloc.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/presentation/bloc/theme/theme_bloc.dart';
import 'package:youtube_dl/router.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await QueryClient.initialize(
    cachePrefix: 'youtube_dl',
  );
  await requestStoragePermission();
  await setupDependency();
  
  // Initialize communication port
  FlutterForegroundTask.initCommunicationPort();
  
  // Initialize background service
  logger.i('Initializing background service...');
  await initializeBackgroundService();
  logger.i('App initialized and starting...');
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: const MyApp(),
    ),
  );
}

Future<void> requestStoragePermission() async {
  logger.i('Checking storage permissions...');
  var status = await Permission.manageExternalStorage.status;
  if (!status.isGranted) {
    logger.i('Requesting Manage External Storage permission...');
    status = await Permission.manageExternalStorage.request();
    logger.i('Manage External Storage permission status: $status');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _setupBackgroundListener();
    _syncBackgroundProgress();
  }

  void _requestPermissions() async {
    await requestStoragePermission();
    // Request notification permission for Android 13+
    await FlutterForegroundTask.requestNotificationPermission();
  }

  void _syncBackgroundProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final historyBloc = sl.get<HistoryBloc>();
    
    final videos = historyBloc.state.videos;
    for (final video in videos) {
      if (video.status != VideoStatus.finished && video.status != VideoStatus.failed) {
        final progress = prefs.getDouble('progress_${video.uuid}');
        final statusIndex = prefs.getInt('status_${video.uuid}');
        final path = prefs.getString('path_${video.uuid}');
        
        if (progress != null || statusIndex != null) {
          historyBloc.add(UpdateHistoryEvent(
            video: video.copyWith(
              progress: progress ?? video.progress,
              status: statusIndex != null ? VideoStatus.values[statusIndex] : video.status,
              path: path ?? video.path,
            ),
          ));
        }
      }
    }
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    super.dispose();
  }

  void _setupBackgroundListener() async {
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
  }

  void _onReceiveTaskData(Object data) {
    if (data is Map<String, dynamic>) {
      final String? type = data['type'];
      if (type == 'updateProgress') {
        final String uuid = data['uuid'];
        final double progress = data['progress'];
        final int statusIndex = data['status'];

        final historyBloc = sl.get<HistoryBloc>();
        final index = historyBloc.state.videos.indexWhere((v) => v.uuid == uuid);

        if (index != -1) {
          final item = historyBloc.state.videos[index];
          historyBloc.add(UpdateHistoryEvent(
            video: item.copyWith(
              progress: progress,
              status: VideoStatus.values[statusIndex],
            ),
          ));
        }
      } else if (type == 'downloadFinished') {
        final String uuid = data['uuid'];
        final String path = data['path'];

        final historyBloc = sl.get<HistoryBloc>();
        final index = historyBloc.state.videos.indexWhere((v) => v.uuid == uuid);

        if (index != -1) {
          final item = historyBloc.state.videos[index];
          historyBloc.add(UpdateHistoryEvent(
            video: item.copyWith(
              path: path,
              status: VideoStatus.finished,
              progress: 1.0,
            ),
          ));
        }

        Fluttertoast.showToast(msg: "download_finished".tr());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoaderBloc>(create: (context) => sl.get<LoaderBloc>()),
        BlocProvider<HistoryBloc>(create: (context) => sl.get<HistoryBloc>()),
        BlocProvider<DownloadBloc>(create: (context) => sl.get<DownloadBloc>()),
        BlocProvider<ThemeBloc>(create: (context) => sl.get<ThemeBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return QueryClientProvider(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              builder: (ctx, child) {
                return MultiBlocListener(
                  listeners: [
                    BlocListener<DownloadBloc, DownloadState>(
                      bloc: sl.get<DownloadBloc>(),
                      listenWhen: (prev, next) => prev != next,
                      listener: (context, state) {
                        if (state is DownloadFinished) {
                          Fluttertoast.showToast(
                            msg: "downloaded_at".tr(args: [state.video.path]),
                            toastLength: Toast.LENGTH_LONG,
                          );
                        }
                      },
                    ),
                    BlocListener<LoaderBloc, LoaderState>(
                      bloc: sl.get<LoaderBloc>(),
                      listenWhen: (prev, next) => prev != next,
                      listener: (context, state) {
                        if (state is LoaderStateLoading) {
                          showDialog(
                            context: navigatorKey.currentState!.context,
                            barrierDismissible: true,
                            builder: (ct) {
                              return Material(
                                color: Colors.transparent,
                                child: PopScope(
                                  canPop: true,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Container(
                                        padding: const EdgeInsets.all(32),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).brightness == Brightness.dark 
                                              ? Colors.black87 
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(20),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SpinKitFadingCircle(
                                              size: 50,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              "analyzing".tr(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                decoration: TextDecoration.none,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          final nav = navigatorKey.currentState!;
                          if (nav.canPop()) {
                            nav.pop();
                          }
                        }
                      },
                    ),
                  ],
                  child: child ?? const SizedBox.shrink(),
                );
              },
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: 'Youtube DL',
              theme: _buildTheme(Brightness.light),
              darkTheme: _buildTheme(Brightness.dark),
              routerConfig: router,
            ),
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    
    // Define a vibrant color scheme based on the seed color
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF5D77),
      brightness: brightness,
      surface: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF9F9F9),
    );

    final baseTextTheme = brightness == Brightness.dark 
        ? Typography.material2021().white 
        : Typography.material2021().black;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: GoogleFonts.outfit().fontFamily,
      scaffoldBackgroundColor: colorScheme.surface,
      
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      
      textTheme: GoogleFonts.outfitTextTheme(baseTextTheme).copyWith(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0, 
          color: colorScheme.onSurfaceVariant,
        ),
        bodySmall: TextStyle(
          fontSize: 12.0, 
          color: colorScheme.outline,
        ),
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.white.withAlpha(5) : Colors.black.withAlpha(5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: colorScheme.outline),
      ),
    );
  }
}
