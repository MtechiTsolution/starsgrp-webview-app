import 'package:flutter/material.dart';
import 'package:startapp_sdk/startapp.dart';

import 'SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'STARSGRP',
      debugShowCheckedModeBanner: false,
      home: SplashScreenpg(),
    );
  }
}
