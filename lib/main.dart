import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/services/hive_service.dart';
import 'core/theme/aura_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local boxes for offline-first state persistence
  await HiveService.init();

  // Configure transparent status bar & dark navigation bar overlays
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AuraColors.backgroundDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: AuraFashionApp(),
    ),
  );
}

class AuraFashionApp extends StatelessWidget {
  const AuraFashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aura AI - Fashion OS',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AuraColors.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: AuraColors.auraViolet,
          secondary: AuraColors.auraRose,
          surface: AuraColors.cardBackgroundDark,
          background: AuraColors.backgroundDark,
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
