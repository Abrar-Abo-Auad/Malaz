import 'package:flutter/material.dart';
import 'package:malaz/core/config/theme_config.dart';
import 'package:malaz/presentation/screens/login/login_screen.dart';
import 'package:malaz/presentation/screens/splash%20screen/splash_screen.dart';

// I'm commenting this out as it seems to be causing an error.
// We can fix this together later if you'd like.
// import 'core/config/theme_config.dart';

void main() {
  runApp(const RentalApp());
}

class RentalApp extends StatelessWidget {
  const RentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apartment Rental',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Using hardcoded colors for now to resolve the error.
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      routes: {'/login': (context) => const LoginScreen()},
      // The initial screen of the app.
      home: SplashScreen(),

      // Defines the named routes for navigation.
      // This is necessary for `Navigator.pushReplacementNamed(\'/login\')` to work.
    );
  }
}
