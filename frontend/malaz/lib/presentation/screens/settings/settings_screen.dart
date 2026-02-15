import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:malaz/l10n/app_localizations.dart';
import 'package:malaz/presentation/cubits/settings/settings_cubit.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/language/language_cubit.dart';
import '../../cubits/theme/theme_cubit.dart';
import '../../global_widgets/brand/build_branding.dart';
import '../../global_widgets/glowing_key/build_glowing_key.dart';
import '../../global_widgets/user_profile_image/user_profile_image.dart';
import '../side_drawer/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const platform = MethodChannel('com.malaz.app/ringtone_picker');

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [_buildSliverAppBar(context, isDark, tr)];
        },
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return ListView(
              physics: const BouncingScrollPhysics(), // حركة تمرير ناعمة (iOS style)
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                // 1. إضافة ملخص الحساب (اختياري لكنه يعطي رقي عالي)
                _buildAccountSummary(context, isDark),
                const SizedBox(height: 30),

                _buildSectionHeader(tr.notifications),
                const SizedBox(height: 15),

                _buildModernContainer(
                  isDark,
                  child: Column(
                    children: [
                      _buildCustomTile(
                        isDark,
                        icon: Icons.notifications_active_rounded,
                        color: Colors.orange,
                        title: tr.enable_notifications,
                        trailing: Switch.adaptive(
                          activeColor: AppColors.primaryLight,
                          value: state.notificationsEnabled,
                          onChanged: (val) => context.read<SettingsCubit>().toggleNotifications(val),
                        ),
                      ),
                      _buildDivider(isDark),
                      _buildCustomTile(
                        isDark,
                        icon: Icons.music_note_rounded,
                        color: Colors.blueAccent,
                        title: tr.notification_sound,
                        subtitle: state.customSoundPath != null
                            ? tr.custom_tone_selected
                            : tr.default_sound,
                        enabled: state.notificationsEnabled,
                        onTap: () => _openSystemRingtonePicker(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),
                _buildSectionHeader(tr.app_preferences),
                const SizedBox(height: 15),

                _buildModernContainer(
                  isDark,
                  child: Column(
                    children: [
                      _buildCustomTile(
                        isDark,
                        icon: Icons.language_rounded,
                        color: Colors.teal,
                        title: tr.language,
                        onTap: () => _showLanguageBottomSheet(context),
                      ),
                      _buildDivider(isDark),
                      _buildCustomTile(
                        isDark,
                        icon: Icons.palette_outlined,
                        color: Colors.purpleAccent,
                        title: tr.theme,
                        onTap: () => _showThemeBottomSheet(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),
                _buildLuxuryFooter(isDark),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isDark, AppLocalizations tr) {
    return SliverAppBar(
      expandedHeight: 95,
      floating: false,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        centerTitle: true,
        title: Text(
          tr.settings,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // التدرج الذهبي مع انحناء سفلي
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.premiumGoldGradient2,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
            ),
            // المفاتيح المتوهجة (بروح ملاذ)
            const PositionedDirectional(
              top: -20,
              start: -40,
              child: BuildGlowingKey(size: 180, opacity: 0.15, rotation: -0.2),
            ),
            const PositionedDirectional(
              bottom: 10,
              end: -20,
              child: BuildGlowingKey(size: 120, opacity: 0.1, rotation: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSummary(BuildContext context, bool isDark) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is !AuthAuthenticated) return const SizedBox();
        return _buildModernContainer(
          isDark,
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: UserProfileImage(
              userId: state.user.id,
              firstName: state.user.first_name,
              lastName: state.user.last_name,
              radius: 30,
            ),
            title: Text("${state.user.first_name} ${state.user.last_name}",
                style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            subtitle: Text(state.user.phone.toString(), style: const TextStyle(color: Colors.grey)),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primaryLight.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.verified_user_rounded, color: AppColors.primaryLight, size: 20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernContainer(bool isDark, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: child,
      ),
    );
  }

  Widget _buildCustomTile(
      bool isDark, {
    required IconData icon,
    required Color color,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: enabled ? onTap : null,
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87
          )),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)) : null,
      trailing: trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade400),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Text(title,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryLight,
              letterSpacing: 1.2
          )),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
        height: 1,
        indent: 70,
        endIndent: 20,
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1)
    );
  }

  Widget _buildLuxuryFooter(bool isDark) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 35),
          BuildBranding.metaStyle(),
          const SizedBox(height: 5),
          const Text("Version 1.0.0", style: TextStyle(color: Colors.grey, fontSize: 9)),
        ],
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: colorScheme.outlineVariant.withOpacity(0.4), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 25),
            Text(tr.select_theme, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 30),
            ThemeSwitcher(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(ctx).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: colorScheme.outlineVariant.withOpacity(0.4), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 25),
            Text(tr.select_language, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 20),
            BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) => Column(
                children: [
                  _buildLanguageOption(ctx, 'English', const Locale('en'), state.locale),
                  _buildLanguageOption(ctx, 'العربية', const Locale('ar'), state.locale),
                  _buildLanguageOption(ctx, 'Français', const Locale('fr'), state.locale),
                  _buildLanguageOption(ctx, 'Русский', const Locale('ru'), state.locale),
                  _buildLanguageOption(ctx, 'Türkçe', const Locale('tr'), state.locale),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String title, Locale locale, Locale currentLocale) {
    final isSelected = locale == currentLocale;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _onLanguageChanged(context, locale),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? colorScheme.primary : colorScheme.onSurface)),
            if (isSelected) Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }

  void _onLanguageChanged(BuildContext context, Locale? value) {
    if (value != null) {
      context.read<LanguageCubit>().updateLanguage(value);
      Navigator.pop(context);
    }
  }

  Future<void> _openSystemRingtonePicker(BuildContext context) async {
    try {
      final String? uri = await platform.invokeMethod('pickRingtone');
      if (uri != null && context.mounted) {
        context.read<SettingsCubit>().updateNotificationSound(uri);
      }
    } on PlatformException catch (e) {
      debugPrint("Error: ${e.message}");
    }
  }
}