import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_dl/presentation/bloc/download/download_bloc.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/presentation/bloc/theme/theme_bloc.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final sl = GetIt.instance;

class CookieHttpClient extends http.BaseClient {
  final String cookies;
  final http.Client _inner = http.Client();

  CookieHttpClient(this.cookies);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (cookies.isNotEmpty) {
      request.headers['Cookie'] = cookies;
    }
    request.headers['User-Agent'] =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
    return _inner.send(request);
  }
}

Future<void> setupDependency() async {
  if (!sl.isRegistered<YoutubeExplode>()) {
    final prefs = await SharedPreferences.getInstance();
    final cookies = prefs.getString('youtube_cookies') ?? '';

    sl.registerSingleton<YoutubeExplode>(
        YoutubeExplode(httpClient: YoutubeHttpClient(CookieHttpClient(cookies))));
    sl.registerSingleton<LoaderBloc>(LoaderBloc());
    sl.registerSingleton<HistoryBloc>(HistoryBloc());
    sl.registerSingleton<DownloadBloc>(DownloadBloc());
    sl.registerSingleton<ThemeBloc>(ThemeBloc());
  }
}