import 'package:flutter/material.dart';
import 'package:project2/screen/first.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(
        value: isLogin,
        onChanged: (newValue) {
          setState(() {
            isLogin = newValue;
          });
        },
      ),
    );
  }
}
