import 'package:flutter/material.dart';
import 'package:startapp_sdk/startapp.dart';

import 'SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'STARSGRP',
      debugShowCheckedModeBanner: false,
      home:SplashScreenpg(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  // SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  var startAppSdk = StartAppSdk();
  var _sdkVersion = "";

  StartAppBannerAd? bannerAd;
  StartAppBannerAd? mrecAd;
  StartAppInterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();

    // TODO make sure to comment out this line before release
    startAppSdk.setTestAdsEnabled(true);
    loadInterstitialAd();
    // TODO your app doesn't need to call this method unless for debug purposes
    startAppSdk.getSdkVersion().then((value) {
      setState(() => _sdkVersion = value);
    });
    startAppSdk.setTestAdsEnabled(true);

    // TODO use one of the following types: BANNER, MREC, COVER
    startAppSdk.loadBannerAd(StartAppBannerType.BANNER).then((bannerAd) {
      setState(() {
        this.bannerAd = bannerAd;
      });
    }).onError < StartAppException > ((ex, stackTrace) {
      debugPrint("Error loading Banner ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Banner ad: $error");
    });
  }

  void loadInterstitialAd() {
    startAppSdk.loadInterstitialAd().then((interstitialAd) {
      setState(() {
        this.interstitialAd = interstitialAd;
      });
    }).onError((ex, stackTrace) {
      var message;
      debugPrint("Error");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Interstitial ad: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ButtonStyle(minimumSize: MaterialStateProperty.all(Size(224, 36)));
    return Scaffold(
        body: Column(
          children: [
            bannerAd != null ? StartAppBanner(bannerAd!) : Container(),

             ElevatedButton(
              onPressed: () {
                if (interstitialAd != null) {
                  interstitialAd!.show().then((shown) {
                    if (shown) {
                      setState(() {
                        // NOTE interstitial ad can be shown only once
                        this.interstitialAd = null;

                        // NOTE load again
                        loadInterstitialAd();
                      });
                    }

                    return null;
                  }).onError((error, stackTrace) {
                    debugPrint("Error showing Interstitial ad: $error");
                  });
                }
              },
              child: Text('Show Interstitial'),
            ),

          ],
        )
    );
  }

  Future<Object> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit an App'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.redAccent, backgroundColor: Colors.red, // foreground
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },

    );

  }

}
