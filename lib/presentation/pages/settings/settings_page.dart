import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_dl/presentation/bloc/theme/theme_bloc.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark 
          ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("settings".tr()),
          scrolledUnderElevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _buildSection(
              context,
              "general".tr(),
              [
                BlocBuilder<ThemeBloc, ThemeMode>(
                  builder: (context, themeMode) {
                    final isDark = themeMode == ThemeMode.dark;
                    return _buildSettingItem(
                      context,
                      icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      title: "dark_mode".tr(),
                      subtitle: isDark ? "currently_dark".tr() : "currently_light".tr(),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (val) => context.read<ThemeBloc>().toggleTheme(),
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.language_rounded,
                  title: "language".tr(),
                  subtitle: context.locale.languageCode == 'fr' ? "french".tr() : "english".tr(),
                  onTap: () => _showLanguageDialog(context),
                ),
              ],
            ),
            _buildSection(
              context,
              "authentication".tr(),
              [
                _buildSettingItem(
                  context,
                  icon: Icons.cookie_rounded,
                  title: "youtube_cookies".tr(),
                  subtitle: "cookies_required".tr(),
                  onTap: () => _showCookieDialog(context),
                ),
              ],
            ),
            _buildSection(
              context,
              "developer".tr(),
              [
                _buildSettingItem(
                  context,
                  icon: Icons.person_rounded,
                  title: "Tsiresy Mila",
                  subtitle: "software_engineer".tr(),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.code_rounded,
                  title: "app_name".tr(),
                  subtitle: "built_with".tr(),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.history_edu_rounded,
                  title: "version".tr(),
                  subtitle: "1.0.0 (${"stable".tr()})",
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "thank_you".tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showCookieDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!context.mounted) return;
    
    final controller = TextEditingController(text: prefs.getString('youtube_cookies'));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("youtube_cookies".tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "cookies_description".tr(),
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "VISITOR_INFO1_LIVE=...; HSID=...; ...",
                hintStyle: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withAlpha(50),
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("cancel".tr()),
          ),
          FilledButton(
            onPressed: () async {
              await prefs.setString('youtube_cookies', controller.text.trim());
              // Force re-register YoutubeExplode with new cookies
              if (sl.isRegistered<YoutubeExplode>()) {
                await sl.unregister<YoutubeExplode>();
              }
              await setupDependency();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("cookies_saved".tr())),
                );
              }
            },
           child: Text("save".tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, title),
        ...items,
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "select_language".tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Text("🇺🇸", style: TextStyle(fontSize: 24)),
              title: Text("english".tr()),
              trailing: context.locale.languageCode == 'en'
                  ? Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text("🇫🇷", style: TextStyle(fontSize: 24)),
              title: Text("french".tr()),
              trailing: context.locale.languageCode == 'fr'
                  ? Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                context.setLocale(const Locale('fr'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
