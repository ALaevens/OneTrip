import 'package:flutter/material.dart';
import 'package:grocery_helper/screens/home_screen.dart';
import 'package:grocery_helper/screens/login_screen.dart';
import 'package:grocery_helper/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery Helper',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        "/login": (context) => const LoginScreen(),
        "/home": (context) => ScrollConfiguration(
            behavior: MyBehavior(), child: const HomeScreen())
      },
    );
  }
}
