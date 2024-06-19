import 'package:flutter/material.dart';
import 'package:lumotareas/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFC9B8F9),
      hintColor: const Color(0xFFA193C7),
      scaffoldBackgroundColor: const Color(0xFF07081D),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
            color: Color(0xFFF1DDD9)),
        displayMedium: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w600,
            color: Color(0xFFF1DDD9)),
        displaySmall: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
            color: Color(0xFFF1DDD9)),
        headlineMedium: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
            color: Color(0xFFF1DDD9)),
        bodyLarge: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: Color(0xFFC9B8F9)),
        bodyMedium: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            color: Color(0xFFC9B8F9)),
        titleMedium: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
            color: Color(0xFFC9B8F9)),
        titleSmall: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w400,
            color: Color(0xFFC9B8F9)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF07081D),
        titleTextStyle: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFFF1DDD9),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: Color(0xFF07081D),
        labelStyle: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w400,
          color: Color(0xFFF1DDD9),
        ),
        secondaryLabelStyle: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w400,
          color: Color(0xFF07081D),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFC9B8F9),
        secondary: Color(0xFFA193C7),
        background: Color(0xFF191B5B),
        surface: Color(0xFF191B5B),
        onPrimary: Color(0xFF07081D),
        onSecondary: Color(0xFF191B5B),
        onBackground: Color(0xFFF1DDD9),
        onSurface: Color(0xFFF1DDD9),
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
      },
    );
  }
}
