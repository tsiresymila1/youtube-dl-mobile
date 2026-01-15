---
name: Code Review (Flutter/Dart)
description: Comprehensive guidelines for reviewing Flutter code in the YouDown project, focusing on Bloc, performance, and best practices.
---

# Code Review Guidelines for YouDown Mobile

Use this skill when asked to review code or before finalizing significant changes. Focus on the following areas to ensure high quality, stability, and maintainability.

## 1. Architecture & State Management (BLoC)
- **Event/State Immutability**: Ensure all Bloc Events and States are immutable (`@immutable` or using `Freezed`).
- **Logic Separation**: UI widgets should *only* dispatch events and listen to states. Business logic must reside in Blocs or Repositories.
- **Bloc Usage**: 
  - Use `BlocBuilder` for rebuilding UI part.
  - Use `BlocListener` for side effects (navigation, toasts, dialogs).
  - Avoid overly complex logic inside `build()` methods.
- **HydratedBloc**: Verify that state persistence logic (`fromJson`/`toJson`) handles nulls and data migration gracefully.

## 2. Resource Management & Performance
- **Disposal**: Check that all `Controllers` (VideoPlayer, Chewie, TextEditing, Animation), `Timers`, and `Streams` are properly disposed in `dispose()`.
- **Media Players**: Ensure `video_player` and `just_audio` instances are stopped/paused before disposal to prevent background audio leaks.
- **Build Method**: Avoid expensive computations or object instantiations inside `build()`. Use `late final` or `initState` where appropriate.
- **const Constructors**: Use `const` for widgets and values wherever possible to optimize rebuilds.

## 3. Error Handling & Stability
- **Network Requests**: All `Dio` requests must be wrapped in try/catch blocks handling `DioException`.
- **FFmpeg**: Check for FFmpeg session return codes. Handle cases where merging or conversion fails.
- **Permissions**: Verify that permission requests (`manageExternalStorage`, `photos`, etc.) check the Android SDK version correctly (SDK 30+ vs older).
- **Null Safety**: strictly avoid force unwrapping (`!`) unless absolutely certain. Use `?.` and `??` defaults.

## 4. User Interface & UX
- **Material 3**: Ensure components follow Material 3 design guidelines (use `ColorScheme`, proper typography).
- **Responsiveness**: UI should handle different screen sizes and orientations gracefully.
- **Dark Mode**: Verify correct color usage for both Light and Dark themes (use `Theme.of(context).colorScheme`).
- **Localization**: All user-facing text must use `easy_localization` keys (e.g., `"key".tr()`). No hardcoded strings.

## 5. Specific Project patterns
- **Background Service**: Ensure tasks intended for background execution properly communicate with `FlutterForegroundTask`.
- **Navigation**: Use `GoRouter` for all navigation. Avoid `Navigator.push` unless working with dialogs/overlays that require it.

## 6. Security
- **Input Validation**: Validate all user inputs (especially YouTube URLs).
- **File System**: Be careful with file path manipulations. Use `path_provider` and validate paths before writing.
