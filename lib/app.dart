import 'package:flutter/material.dart';
import 'package:starsgrp/webview_container.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      home: WebViewContainer('https://starsgrp.com/', 'STARSGRP',"https://starsgrp.com/page/privacy-policy"),
    );
  }
}