import 'pages/welcome_pages.dart';
import 'pages/homepage.dart';
import 'package:flutter/material.dart';
import 'provider/provider.dart';
import 'them_mode.dart';
import 'package:provider/provider.dart';
void main()
{
  runApp(ChangeNotifierProvider(
    create: (context) => mode(),
    child: const MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<mode>(context).lightModeEnable
          ? ModeTheme.lightMode
          : ModeTheme.darkMode,
      debugShowCheckedModeBanner: false,
      // home: homepages(),
      home: HomeWelcome(),
    );
  }
}
