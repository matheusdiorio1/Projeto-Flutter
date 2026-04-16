import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:login_app/screens/login_screen.dart';
import 'package:login_app/screens/cadastro_screen.dart';
import 'package:login_app/screens/home_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // pode colocar kDebugMode depois
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/home': (context) => const HomeScreen(),
      }
    );
  }
}
