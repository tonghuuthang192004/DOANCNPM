import 'pages/welcome_pages.dart';
import 'pages/homepage.dart';
import 'package:flutter/material.dart';
void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'flutter App Clock',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity
          ),
      debugShowCheckedModeBanner: false,
      // home: homepages(),
      home: HomeWelcome(),
    );
  }
}
