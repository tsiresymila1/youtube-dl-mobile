import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_dl/presentation/pages/about/about_page.dart';
import 'package:youtube_dl/presentation/pages/history/history_page.dart';
import 'package:youtube_dl/presentation/pages/home/home_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(navigatorKey: navigatorKey, routes: [
  GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) {
        return const HomePage();
      },
      routes: [
        GoRoute(
            name: 'history',
            path: 'history',
            builder: (context, state) {
              return const HistoryPage();
            }),
        GoRoute(
            name: 'about',
            path: 'about',
            builder: (context, state) {
              return const AboutPage();
            })
      ]),
]);
