
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
  WebViewContainer(this.url, this.title,this.url_p);
  @override
  createState() => _WebViewContainerState(this.url, this.title,this.url_p);
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
    // timer = Timer.periodic(Duration(seconds: 10), (Timer t) => loadInterstitialAd());
    // if (interstitialAd != null) {
    //   interstitialAd!.show().then((shown) {
    //     if (shown) {
    //       setState(() {
    //         // NOTE interstitial ad can be shown only once
    //         this.interstitialAd = null;
    //
    //         // NOTE load again
    //         loadInterstitialAd();
    //       });
    //     }
    //
    //     return null;
    //   }).onError((error, stackTrace) {
    //     debugPrint("Error showing Interstitial ad: $error");
    //   });
    // }

    // TODO make sure to comment out this line before release
     startAppSdk.setTestAdsEnabled(false);
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
      // appBar: AppBar(
      //   backgroundColor: Colors.red[500],
      //   title: const Text('Theowletonline',style: TextStyle(fontWeight: FontWeight.bold),),
      //   centerTitle: true,
      //   // leading: IconButton(
      //   //   onPressed: _handleMenuButtonPressed,
      //   //   icon: ValueListenableBuilder<AdvancedDrawerValue>(
      //   //     valueListenable: _advancedDrawerController,
      //   //     builder: (_, value, __) {
      //   //       return AnimatedSwitcher(
      //   //         duration: Duration(milliseconds: 250),
      //   //         child: Icon(
      //   //           value.visible ? Icons.clear : Icons.menu,
      //   //           key: ValueKey<bool>(value.visible),
      //   //         ),
      //   //       );
      //   //     },
      //   //   ),
      //   // ),
      // ),
      body: Stack(
        children: [
          WebView(
            initialUrl: _url,
            zoomEnabled: true,
            allowsInlineMediaPlayback: true,
            gestureRecognizers: {}..add(Factory(() => VerticalDragGestureRecognizer())),
            key: _key,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },

          ),
          Visibility(
            visible: isLoading,
            child:Center(
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
                          child: Text("Loading.....",
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 18,color: Colors.white),),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                          height: 35,
                          child: CircularProgressIndicator(valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white))),

                      SizedBox(height: 10,),
                      Container(
                        child: Center(
                          child: Text("Please wait ",
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 12,color: Colors.white),),
                        ),
                      ),
                    ],

                  ),
                ),
              ),
            ),
          ),
          if (bannerAd != null) Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                child: Text('Test Interstitial'),
              ),
              StartAppBanner(bannerAd!),
            ],
          ) else Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,

          ),
        ],
      ),
    );

    //   WillPopScope(
    //   onWillPop: () => showExitPopup(context),
    //   child:
    //   AdvancedDrawer(
    //       backdropColor: Colors.red[500],
    //      // controller: _advancedDrawerController,
    //      // animationCurve: Curves.easeInOut,
    //       animationDuration: const Duration(milliseconds: 300),
    //       animateChildDecoration: true,
    //       rtlOpening: false,
    //       // openScale: 1.0,
    //       disabledGestures: false,
    //       childDecoration: const BoxDecoration(
    //         borderRadius: const BorderRadius.all(Radius.circular(16)),
    //       ),
    //       drawer:
    //       SafeArea(
    //         child: Container(
    //           // child: ListTileTheme(
    //           //   textColor: Colors.white,
    //           //   iconColor: Colors.white,
    //           //   child: Column(
    //           //     mainAxisSize: MainAxisSize.max,
    //           //     children: [
    //           //       Container(
    //           //         width: 120.0,
    //           //         height: 120.0,
    //           //         margin: const EdgeInsets.only(
    //           //           top: 24.0,
    //           //           bottom: 64.0,
    //           //         ),
    //           //         clipBehavior: Clip.antiAlias,
    //           //         decoration: const BoxDecoration(
    //           //           color: Colors.white,
    //           //           shape: BoxShape.circle,
    //           //         ),
    //           //         child: Image.asset(
    //           //           'assets/iconn.png',
    //           //         ),
    //           //       ),
    //           //       ListTile(
    //           //         onTap: () {
    //           //           // Navigator.pop(context);
    //           //           // Navigator.of(context).push(
    //           //           //     MaterialPageRoute(builder: (context) => App()));
    //           //            _advancedDrawerController.hideDrawer();
    //           //           // Navigator.push(context,
    //           //           //     MaterialPageRoute(builder: (context) =>  controlling()));
    //           //         },
    //           //         leading: Icon(Icons.home),
    //           //         title: Text('Home'),
    //           //       ),
    //           //       ListTile(
    //           //         onTap: () {
    //           //           _advancedDrawerController.hideDrawer();
    //           //           Navigator.pop(context);
    //           //           Navigator.of(context).push(
    //           //               MaterialPageRoute(builder: (context) =>
    //           //                   Privacy_policy(this._url, this._title,this._url_p)));
    //           //         },
    //           //         leading: Icon(Icons.home_repair_service),
    //           //         title: Text('Services'),
    //           //       ),
    //           //       ListTile(
    //           //         onTap: ()async{
    //           //           String email = Uri.encodeComponent("support@theowlette.com");
    //           //           String subject = Uri.encodeComponent("Team Theowletonline");
    //           //           String body = Uri.encodeComponent("Hi! write your feedback here.....");
    //           //           print(subject); //output: Hello%20Flutter
    //           //           Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    //           //           if (await launchUrl(mail)) {
    //           //           //email app opened
    //           //           }else{
    //           //           //email app is not opened
    //           //           }
    //           //           Text("Mail Us");
    //           //         },
    //           //         leading: Icon(Icons.feedback_outlined),
    //           //         title: Text('FeedBack'),
    //           //       ),
    //           //       ListTile(
    //           //         onTap: () {
    //           //           Share.share('Visit Theowletonline at https://the-owlet.com/');
    //           //         },
    //           //         leading: Icon(Icons.share),
    //           //         title: Text('Share'),
    //           //       ),
    //           //       Spacer(),
    //           //       DefaultTextStyle(
    //           //         style: const TextStyle(
    //           //           fontSize: 12,
    //           //           color: Colors.white54,
    //           //         ),
    //           //         child: Container(
    //           //           margin: const EdgeInsets.symmetric(
    //           //             vertical: 16.0,
    //           //           ),
    //           //           child: Text('Copyright © 2022, All Right Reserved',style: TextStyle(color: Colors.white),),
    //           //         ),
    //           //       ),
    //           //     ],
    //           //   ),
    //           // ),
    //         ),
    //       ),
    //       child: Scaffold(
    //         appBar: AppBar(
    //           backgroundColor: Colors.red[500],
    //           title: const Text('Theowletonline',style: TextStyle(fontWeight: FontWeight.bold),),
    //           centerTitle: true,
    //           // leading: IconButton(
    //           //   onPressed: _handleMenuButtonPressed,
    //           //   icon: ValueListenableBuilder<AdvancedDrawerValue>(
    //           //     valueListenable: _advancedDrawerController,
    //           //     builder: (_, value, __) {
    //           //       return AnimatedSwitcher(
    //           //         duration: Duration(milliseconds: 250),
    //           //         child: Icon(
    //           //           value.visible ? Icons.clear : Icons.menu,
    //           //           key: ValueKey<bool>(value.visible),
    //           //         ),
    //           //       );
    //           //     },
    //           //   ),
    //           // ),
    //         ),
    //         body: Stack(
    //           children: [
    //             WebView(
    //               initialUrl: _url,
    //               zoomEnabled: true,
    //               allowsInlineMediaPlayback: true,
    //               gestureRecognizers: {}..add(Factory(() => VerticalDragGestureRecognizer())),
    //               key: _key,
    //               javascriptMode: JavascriptMode.unrestricted,
    //               onPageFinished: (finish) {
    //                 setState(() {
    //                   isLoading = false;
    //                 });
    //               },
    //
    //             ),
    //             Visibility(
    //               visible: isLoading,
    //               child:Center(
    //                 child: Container(
    //                   height: 120,
    //                   width: 200,
    //                   child: Card(
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(15.0),
    //                     ),
    //                     color: Colors.red[500],
    //                     elevation: 10,
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Container(
    //                           child: Center(
    //                             child: Text("Loading.....",
    //                               style: TextStyle(fontWeight: FontWeight.bold,
    //                                   fontSize: 18,color: Colors.white),),
    //                           ),
    //                           ),
    //                         SizedBox(height: 10,),
    //                         Container(
    //                             height: 35,
    //                             child: CircularProgressIndicator(valueColor:
    //                             new AlwaysStoppedAnimation<Color>(Colors.white))),
    //
    //                         SizedBox(height: 10,),
    //                         Container(
    //                           child: Center(
    //                             child: Text("Please wait ",
    //                               style: TextStyle(fontWeight: FontWeight.bold,
    //                                   fontSize: 12,color: Colors.white),),
    //                           ),
    //                         ),
    //                       ],
    //
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             if (bannerAd != null) Column(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               children: [
    //                 ElevatedButton(
    //                   onPressed: () {
    //                     if (interstitialAd != null) {
    //                       interstitialAd!.show().then((shown) {
    //                         if (shown) {
    //                           setState(() {
    //                             // NOTE interstitial ad can be shown only once
    //                             this.interstitialAd = null;
    //
    //                             // NOTE load again
    //                             loadInterstitialAd();
    //                           });
    //                         }
    //
    //                         return null;
    //                       }).onError((error, stackTrace) {
    //                         debugPrint("Error showing Interstitial ad: $error");
    //                       });
    //                     }
    //                   },
    //                   child: Text('Test Interstitial'),
    //                 ),
    //                 StartAppBanner(bannerAd!),
    //               ],
    //             ) else Container(
    //               color: Colors.white,
    //               width: MediaQuery.of(context).size.width,
    //               alignment: Alignment.bottomCenter,
    //
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    // );
  }


  // void _handleMenuButtonPressed() {
  //   // NOTICE: Manage Advanced Drawer state through the Controller.
  //   _advancedDrawerController.value = AdvancedDrawerValue.visible();
  //   _advancedDrawerController.showDrawer();
  // }
}