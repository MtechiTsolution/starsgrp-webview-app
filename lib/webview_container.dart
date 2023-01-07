import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:starsgrp/app.dart';
import 'package:starsgrp/privacy_policy.dart';
import 'package:starsgrp/widgets/exit_popup.dart';
import 'package:startapp_sdk/startapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final title;
  final url_p;
  final bool ad1, ad2;
  WebViewContainer(this.url, this.title, this.url_p, this.ad1, this.ad2);
  @override
  createState() => _WebViewContainerState(this.url, this.title, this.url_p);
}

class _WebViewContainerState extends State<WebViewContainer> {
  final _advancedDrawerController = AdvancedDrawerController();
  var startAppSdk = StartAppSdk();
  var _sdkVersion = "";

  StartAppBannerAd? bannerAd;
  StartAppBannerAd? mrecAd;
  StartAppInterstitialAd? interstitialAd;
  Timer? timer;
  @override
  void initState() {
    super.initState();

    startAppSdk.setTestAdsEnabled(true);

    // TODO your app doesn't need to call this method unless for debug purposes
    // startAppSdk.getSdkVersion().then((value) {
    //   setState(() => _sdkVersion = value);
    // });

    if (widget.ad2) {
      loadInterstitialAd();
    }
    if (widget.ad1) {
      startAppSdk.loadBannerAd(StartAppBannerType.BANNER).then((bannerAd) {
        setState(() {
          this.bannerAd = bannerAd;
        });
      }).onError<StartAppException>((ex, stackTrace) {
        debugPrint("Error loading Banner ad: ${ex.message}");
      }).onError((error, stackTrace) {
        debugPrint("Error loading Banner ad: $error");
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void loadInterstitialAd() {
    startAppSdk.loadInterstitialAd().then((interstitialAd) {
      setState(() {
        this.interstitialAd = interstitialAd;
      });
    }).onError((ex, stackTrace) {
      debugPrint("Error");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Interstitial ad: $error");
    });
  }

  loadMyinitalAds() {
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
  }

  var _url;
  var _title;
  var _url_p;
  final _key = UniqueKey();
  bool isLoading = true;
  @override
  _WebViewContainerState(this._url, this._title, this._url_p);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebView(
            initialUrl: _url,
            zoomEnabled: true,
            allowsInlineMediaPlayback: true,
            gestureRecognizers: {}
              ..add(Factory(() => VerticalDragGestureRecognizer())),
            key: _key,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url != 'https://the-owlet.com/' && widget.ad2) {
                loadMyinitalAds();
              }

              return NavigationDecision.navigate;
            },
          ),
          Visibility(
            visible: isLoading,
            child: Center(
              child: Container(
                height: 120,
                width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.red[500],
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Center(
                          child: Text(
                            "Loading.....",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 35,
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white))),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            "Please wait ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (bannerAd != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StartAppBanner(bannerAd!),
              ],
            )
        ],
      ),
    );
  }
}
