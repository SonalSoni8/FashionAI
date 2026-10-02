import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String settingsBoxName = 'aura_settings';
  static const String profileBoxName = 'aura_profile';
  static const String wardrobeBoxName = 'aura_wardrobe';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(profileBoxName);
    await Hive.openBox(wardrobeBoxName);
  }

  static Box get settingsBox => Hive.box(settingsBoxName);
  static Box get profileBox => Hive.box(profileBoxName);
  static Box get wardrobeBox => Hive.box(wardrobeBoxName);

  static bool get isOnboardingCompleted =>
      settingsBox.get('onboarding_completed', defaultValue: false);

  static Future<void> setOnboardingCompleted(bool value) async {
    await settingsBox.put('onboarding_completed', value);
  }

  static bool get isLoggedIn =>
      settingsBox.get('is_logged_in', defaultValue: false);

  static Future<void> setLoggedIn(bool value) async {
    await settingsBox.put('is_logged_in', value);
  }

  static String? get userEmail => settingsBox.get('user_email');
  static Future<void> setUserEmail(String email) async {
    await settingsBox.put('user_email', email);
  }

  static Map<String, dynamic>? get userProfile =>
      Map<String, dynamic>.from(profileBox.get('user_data', defaultValue: {}));

  static Future<void> saveUserProfile(Map<String, dynamic> data) async {
    await profileBox.put('user_data', data);
  }

  static List<Map<String, dynamic>> get getWardrobeItems {
    final raw = wardrobeBox.get('items', defaultValue: []);
    if (raw is List) {
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

  static Future<void> saveWardrobeItems(List<Map<String, dynamic>> items) async {
    await wardrobeBox.put('items', items);
  }
}

