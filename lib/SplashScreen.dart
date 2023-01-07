import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'app.dart';
// void main() {
//   runApp(MyApp());
// }

class SplashScreenpg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Theoletonline',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: splashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class splashScreen extends StatefulWidget {
  @override
  _splashScreen createState() => _splashScreen();
}
class _splashScreen extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    App()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      body:  Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              height: 500,
                width: 500,
                color: Colors.white,
                child:Image.asset("assets/theee.png")
            ),
            SizedBox(height: 10,),
            Container(
              child: Lottie.asset('assets/load.json'),
            ),

          ],
        ),
      ),

    );
  }
}
