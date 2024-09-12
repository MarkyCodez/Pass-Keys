import 'package:flutter/material.dart';
import 'package:password_manager/database/database_provider.dart';
import 'package:password_manager/pages/home_page.dart';
import 'package:password_manager/theme/my_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightMode,
      home: const HomePage(),
    );
  }
}
