/// @nodoc
library;
import 'package:flutter/material.dart';
import 'package:lumotareas/lib/providers/auth_provider.dart';
import 'package:lumotareas/lib/providers/project_data_provider.dart';
import 'package:lumotareas/lib/providers/user_data_provider.dart';
import 'package:lumotareas/lib/providers/organization_data_provider.dart';
import 'package:lumotareas/lib/screens/layout/layout_screen.dart';
import 'package:lumotareas/lib/screens/loading/loading_screen.dart';
import 'package:lumotareas/lib/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
// import 'package:lumotareas/viewmodels/login_viewmodel.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('es_CL', null);

  var logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  logger.i('Firebase inicializado');
  try {
    runApp(const MyApp());
  } catch (error, stackTrace) {
    logger.e('Error al ejecutar la aplicación',
        error: error, stackTrace: stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF07081D),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF07081D),
        titleTextStyle: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFFF1DDD9),
        ),
      ),
    );
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) => UserDataProvider(
              Provider.of<AuthProvider>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => OrganizationDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProjectDataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Lumotareas',
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const LayoutScreen(),
          '/loading': (context) => const LoadingScreen(),
        },
      ),
    );
  }
}
