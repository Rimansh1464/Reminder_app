import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/provider/reminder_provider.dart';
import 'package:reminder_app/provider/theme_provider.dart';
import 'package:reminder_app/views/HomeScreen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider(),),
      ChangeNotifierProvider<ReminderProvider>(
        create: (context) => ReminderProvider(),
        builder: (context, child) => MaterialApp(
          themeMode: (Provider.of<ThemeProvider>(context).isDark) ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(backgroundColor: Colors.white,primaryColor: Colors.black),
          darkTheme: ThemeData(backgroundColor: Colors.white24,primaryColor: Colors.white),
          routes: {
            '/': (context) => const HomeScreen(),
          },
        ),
      ),
    ],
  ));
}
