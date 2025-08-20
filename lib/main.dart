import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PocketTasksApp()));
}

class PocketTasksApp extends StatelessWidget {
  const PocketTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the custom color theme based on #4D55BB
    const primaryColor = Color(0xFF4D55BB);
    
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: primaryColor,
      secondary: const Color(0xFF6366F1),
      tertiary: const Color(0xFF8B5CF6),
      surface: Colors.white,
      background: const Color(0xFFF8F9FF),
      onBackground: const Color(0xFF1A1A2E),
      onSurface: const Color(0xFF1A1A2E),
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ).copyWith(
      primary: primaryColor,
      secondary: const Color(0xFF6366F1),
      tertiary: const Color(0xFF8B5CF6),
      surface: const Color(0xFF1A1A2E),
      background: const Color(0xFF0F0F23),
      onBackground: Colors.white,
      onSurface: Colors.white,
    );

    return MaterialApp(
      title: 'PocketTasks',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'SF Pro Display', // You can customize this
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        // cardTheme: CardTheme(
        //   elevation: 0,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   color: Colors.white,
        //   shadowColor: primaryColor.withOpacity(0.1),
        // ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: primaryColor,
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'SF Pro Display', // You can customize this
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        // cardTheme: CardTheme(
        //   elevation: 0,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   color: const Color(0xFF1A1A2E),
        //   shadowColor: Colors.black.withOpacity(0.3),
        // ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: primaryColor,
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}