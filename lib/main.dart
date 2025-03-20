import 'package:flutter/material.dart';
import 'first_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
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
