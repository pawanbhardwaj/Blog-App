import 'package:blog/Screens/Welcome/welcome_screen.dart';
import 'package:blog/views/home.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Blog App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Josefin",
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen());
  }
}
