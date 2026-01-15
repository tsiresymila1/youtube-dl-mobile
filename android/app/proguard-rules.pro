# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# FFmpeg Kit
-keep class com.arthenica.ffmpegkit.** { *; }

# Flutter Foreground Task
-keep class com.pravera.flutter_foreground_task.** { *; }

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# Just Audio
-keep class com.ryanheise.just_audio.** { *; }

# Video Player
-keep class io.flutter.plugins.videoplayer.** { *; }

# Shared Preferences (Pigeon & Implementation)
-keep class dev.flutter.pigeon.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.example.shared_preferences_android.** { *; }

# Device Info Plus
-keep class dev.fluttercommunity.plus.device_info.** { *; }

# Path Provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# URL Launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# Android X & Core
-keep class androidx.lifecycle.** { *; }
-keep class androidx.core.** { *; }

# Retrofit / Dio / OkHttp (Common network libs)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn javax.annotation.**
-dontwarn com.squareup.okhttp.**
-dontwarn okio.**

# Google Play Services / Flutter Deferred Components
# These are referenced by Flutter Android embedding but are optional if not using Split Computes
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Generic fallback for plugins using reflection
-keep public class * extends io.flutter.plugin.common.PluginRegistry$Registrar
