import 'package:flutter/material.dart';
import 'package:starsgrp/webview_container.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      home: WebViewContainer('https://the-owlet.com/',
          'Theowletonline',"https://the-owlet.com/services"),
    );
  }
}