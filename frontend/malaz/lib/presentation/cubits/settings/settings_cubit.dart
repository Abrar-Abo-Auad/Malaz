import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/notification_service/notification_service.dart';

class SettingsState {
  final bool notificationsEnabled;
  final String? customSoundPath; // اسم ملف النغمة أو المسار
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
    notificationsEnabled: _prefs.getBool('notifications_enabled') ?? true,
    customSoundPath: _prefs.getString('custom_sound_path'),
  ));

  // تفعيل أو إلغاء الإشعارات
  Future<void> toggleNotifications(bool enabled) async {
    // 1. تحديث الواجهة فوراً (Local First)
    emit(state.copyWith(notificationsEnabled: enabled));

    // 2. حفظ الإعداد في SharedPreferences لضمان بقائه بعد إغلاق التطبيق
    await _prefs.setBool('notifications_enabled', enabled);

    // 3. محاولة مزامنة الحالة مع Firebase في الخلفية دون تعطيل المستخدم
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
      // نمسك الخطأ هنا (سواء كان Timeout أو Network Error) لكي لا يظهر اللون الأحمر في الـ Console
      debugPrint("⚠️ Firebase Sync failed (Network/Timeout), but settings saved locally.");
    }
  }

  // تحديث نغمة الإشعارات
  // عند تغيير النغمة
  Future<void> updateNotificationSound(String uri) async {
    await _prefs.setString('custom_sound_path', uri);
    emit(state.copyWith(customSoundPath: uri));

    // تحديث القناة محلياً (الحذف ثم الإعادة بالصوت الجديد)
    await NotificationService.updateNotificationChannel(uri);

    // لا حاجة لإرسال شيء للباك-أند هنا لأن الـ ID ثابت عنده أصلاً!
  }

  void _recreateNotificationChannel(String soundName) {
    // منطق حذف وإنشاء قناة إشعارات جديدة بـ ID مختلف ليعتمد أندرويد النغمة الجديدة
  }
}