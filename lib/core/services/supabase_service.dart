import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient? _client;

  static Future<void> init({
    required String url,
    required String anonKey,
  }) async {
    if (url.isNotEmpty && anonKey.isNotEmpty) {
      await Supabase.initialize(url: url, anonKey: anonKey);
      _client = Supabase.instance.client;
    }
  }

  static SupabaseClient? get client => _client;
}
