import 'package:flutter/material.dart';
import 'package:starsgrp/webview_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Ads').snapshots(),
          builder: (context, snaps) {
            if (snaps.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final bool ad1 = snaps.data!.docs[0].get('ad1') ?? false;
              final bool ad2 = snaps.data!.docs[0].get('ad2') ?? false;
              return WebViewContainer('https://the-owlet.com/',
                  'Theowletonline', "https://the-owlet.com/services", ad1, ad2);
              return Scaffold(
                body: Center(
                  child: Text('whats wrong'),
                ),
              );
            }
          }),
    );
  }
}
