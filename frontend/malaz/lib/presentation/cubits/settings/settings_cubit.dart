import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/notification_service/notification_service.dart';

class SettingsState {
  final bool notificationsEnabled;
  final String? customSoundPath;
  final bool isLoading;

  SettingsState({
    this.notificationsEnabled = true,
    this.customSoundPath,
    this.isLoading = false,
  });

  SettingsState copyWith({bool? notificationsEnabled, String? customSoundPath, bool? isLoading}) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      customSoundPath: customSoundPath ?? this.customSoundPath,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;

  SettingsCubit(this._prefs) : super(SettingsState(
    notificationsEnabled: _prefs.getBool(AppConstants.notificationsEnabled) ?? true,
    customSoundPath: _prefs.getString(AppConstants.customSoundPath),
  ));

  Future<void> toggleNotifications(bool enabled) async {
    emit(state.copyWith(notificationsEnabled: enabled));

    await _prefs.setBool(AppConstants.notificationsEnabled, enabled);

    try {
      if (enabled) {
        await FirebaseMessaging.instance
            .subscribeToTopic('all')
            .timeout(const Duration(seconds: 3));
      } else {
        await FirebaseMessaging.instance
            .unsubscribeFromTopic('all')
            .timeout(const Duration(seconds: 3));
      }
      debugPrint("✅ Firebase Topic Sync Success");
    } catch (e) {
      debugPrint("⚠️ Firebase Sync failed (Network/Timeout), but settings saved locally.");
    }
  }

  Future<void> updateNotificationSound(String uri) async {
    await _prefs.setString('custom_sound_path', uri);
    emit(state.copyWith(customSoundPath: uri));

    await NotificationService.updateNotificationChannel(uri);
  }
}