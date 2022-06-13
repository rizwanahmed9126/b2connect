import 'dart:io';

import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/screen_size.dart';
import 'package:b2connect_flutter/view/widgets/appBar_with_cart_notification_widget.dart';
import 'package:b2connect_flutter/view/widgets/useful_widgets.dart';
import 'package:b2connect_flutter/view/widgets/web_view_page.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:zoho_chat/zoho_chat.dart';
import '../../model/services/storage_service.dart';
import '../../model/utils/service_locator.dart';
import '../../view/widgets/support_widget_view.dart';

//import 'package:zoho_chat/zoho_chat.dart';
import 'dart:io' as io;
import 'package:salesiq_mobilisten/salesiq_mobilisten.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:io';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  // String tagId = ' ';
  // void active(val) {
  //   setState(() {
  //     tagId = val;
  //   });
  // }

  // ignore: unused_field
  late Future<void> _launched;

  Future<void> _sendmail(String toMailId, String subject, String body) async {
    //var url = 'mailto:$toMailId?subject=$subject&body=$body';
    final Uri url = Uri(
      scheme: 'mailto',
      path: toMailId,
      query: 'subject=$subject&body=$body', //add subject and body here
    );

    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var storageService = locator<StorageService>();

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<void> initMobilisten() async {
    print('get into zoho');

    String name =
        "${Provider.of<AuthProvider>(context, listen: false).userInfoData!.firstName} ${Provider.of<AuthProvider>(context, listen: false).userInfoData!.lastName}";
    String phone =
        "${Provider.of<AuthProvider>(context, listen: false).userInfoData!.uid}";
    //if (io.Platform.isIOS || io.Platform.isAndroid) {
    String appKey;
    String accessKey;
    if (io.Platform.isIOS) {
      print('into ios');
      appKey =
      "R%2B7sOc2Ar80g30w%2BzPy9E1bx8s4WTfkX%2Fllx06n29N10apswHnfLvYcGBqTixH%2FT";
      accessKey =
      "YuCDcIoTmTHrs%2FG7fOn1Za0ig8kscV%2FVXMax20AJcv%2BqHF13I%2Bkv21MhfdnjSVr5dCZaDDOF1m1y2bGzWEf8WxLr2UcH%2FYopiItRXhnwo1ZmvqjKBtAErn%2FonBBmGGjgSLMsJqH6sLh9GS6PE1Ap9Y0%2F6q2S80PW%2FZSwkESTFPI%3D";
    } else {
      print('into android');
      appKey =
      "b9xazcJxDzFW8fLOFk35F%2F5ZcdOp9vTddGqbMB53y72HBgak4sR%2F0w%3D%3D_in";
      accessKey =
      "YuCDcIoTmTHrs%2FG7fOn1Za0ig8kscV%2FVF30m%2FWHJc%2BKQMSTje3htrxvIu0AwgwNGfb8FWmXoAomv0Vq6zGAfszcadFMwFTM3Y0ri%2FNAKv0paQvy9XR69C2MEbTlcGWDiG85uQNyYdBBqnZZ418W6NiIjc9kDy1lE0Ws9c1US3Bc%3D";
    }

    ZohoSalesIQ.init(appKey, accessKey).then((_) {
      ZohoSalesIQ.showLauncher(false);
//ZohoSalesIQ.show();
    }).catchError((error) {
      print(error);
    });
    //   ZohoSalesIQ.eventChannel.listen((event) {
    //     switch (event["eventName"]) {
    //       case SIQEvent.supportOpened:
    //       // your code to handle event
    //         break;
    //       case SIQEvent.supportClosed:
    //     }
    //
    // });

    //ZohoSalesIQ.setVisitorNameVisibility(false);
    ZohoSalesIQ.openNewChat();

    // ZohoSalesIQ.openChatWithID("10021");

    ZohoSalesIQ.setVisitorContactNumber("$phone");
    ZohoSalesIQ.setVisitorName("$name");
    ZohoSalesIQ.startChat(
        "Hello. My name is $name and my account number is $phone. Can we chat now?");

    // }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBarWithCartNotificationWidget(
        title: 'Support',
        onTapIcon: () {
          /* Navigator.pop(context);
            Provider.of<OffersProvider>(context, listen: false)
                .clearFilterData();*/
        },
        leadingWidget: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Image.asset(
            "assets/images/logo_icon.png",
            scale: 8,
            height: 30.h,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 0.h,
            bottom: 10.h,
          ),
          child: Column(


            children: [
              SizedBox(
                height: height * 0.030.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('business_hours')!,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                  ),
                ),
              ),

              SizedBox(
                height: height * 0.015.h,
              ),
              Container(
                width: double.infinity.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: width * 0.003.w,
                      color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.all(height * 0.015.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.translate('sunday')!} - ${AppLocalizations.of(context)!.translate('saturday')!}",
                              style: TextStyle(
                                fontSize:
                                ScreenSize.productContainerText,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.010.h,
                            ),
                            Text(
                              "9 AM - 10 PM",
                              style: TextStyle(
                                fontSize:
                                ScreenSize.productContainerText,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        /* SizedBox(
                          width:20.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text(
                              "${AppLocalizations.of(context)!.translate('friday')!} - ${AppLocalizations.of(context)!.translate('saturday')!}",
                              style: TextStyle(
                                fontSize: ScreenSize.productContainerText,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),

                            SizedBox(
                              height: height * 0.010.h,
                            ),
                            Text(
                              "9 AM - 10 AM",
                              style: TextStyle(
                                fontSize: ScreenSize.productContainerText,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            )

                          ],
                        )*/
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.015.h,
              ),
              // Container(
              //   height: ScreenSize.sliderHeight,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       scale: 1,
              //       image: AssetImage(
              //         'assets/images/Banner.png',
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 5.h,
              // ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _launched = _makePhoneCall('tel://800614');
                  });
                },
                child: SupportWidgetNew(
                  icon: "assets/images/phone01.png",
                  txt: AppLocalizations.of(context)!
                      .translate('call_us')!,
                  subTxt:
                  "${AppLocalizations.of(context)!.translate('toll_free')!}: 800 614",
                ),
              ),
              GestureDetector(
                onTap: () {
                  initPlatformState();
                  initMobilisten();
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveChat()));
                },
                child: SupportWidgetNew(
                  icon: "assets/images/Live.png",
                  txt: AppLocalizations.of(context)!
                      .translate('live_chat')!,
                  subTxt: AppLocalizations.of(context)!
                      .translate('live_chat_desc')!,
                ),
              ),
              GestureDetector(
                onTap: () {
                  openWhatsapp();
                },
                child: SupportWidgetNew(
                  icon: "assets/images/whatsapp.png",
                  txt: AppLocalizations.of(context)!
                      .translate('whatsapp')!,
                  subTxt: AppLocalizations.of(context)!
                      .translate('whatsapp_desc')!,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _launched = _sendmail('support@bsquaredwifi.com',
                        'Issue report', 'Issue description\n\n\n');
                  });
                },
                child: SupportWidgetNew(
                  icon: "assets/images/mail.png",
                  txt: AppLocalizations.of(context)!
                      .translate('email_us')!,
                  subTxt: AppLocalizations.of(context)!
                      .translate('email_us_desc')!,
                ),
              ),
              GestureDetector(
                onTap: () {
                  //YuCDcIoTmTHrs%2FG7fOn1Zf0dWaLb8UHbRS4KFaLIGbRDpiE2hjc667dKMEV1EFX420wxDl4gSCody4lk%2BvnyT%2B0Wej%2BKob7vEhAkXH30X%2BW2fm5J4TRFLNu6nglmOKgKO2uZUldPArmAW3zQB5ubMthK0lSIOGC5
                  EasyLoading.show(status: 'Loading..');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(
                          title: 'Support',
                          url:
                          "https://forms.zohopublic.com/bsquaredwifi/form/ComplaintForm2/formperma/O83_l2WJ9yIpGn3HczrIWCPj3gN-lJ9MRuGbTf2nY8s?SingleLine3=&SingleLine=&Name_First=dear%20guest&Email="),
                    ),
                  );
                },
                child: SupportWidgetNew(
                  icon: "assets/images/issue.png",
                  txt: AppLocalizations.of(context)!
                      .translate('report_issue')!,
                  subTxt: AppLocalizations.of(context)!
                      .translate('report_issue_desc')!,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  openWhatsapp() async {
    var whatsapp = "+97148753894";
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp + "&text=%s";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("%s")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }
}

// final InAppLocalhostServer localhostServer =
// new InAppLocalhostServer(port: 2021);
//
// class ZohoChat extends StatefulWidget {
//
//   ///the generated widget code copied from the zoho chat script.
//   final String zohoWidgetCode;
//
//   ///color code for the preloader in hex. Default is #000000.
//   final String? chatPreloaderColorHexString;
//
//   ///Border size of the preloader. default value = 10.0.
//   final double? chatPreloaderWidth;
//
//   ///size of preloader. Default value is 120.0
//   final double? chatPreloaderSize;
//
//   ///allow you to either hide or show minimize widget on the zoho chat. Default is false
//   final bool? showMinimizeChatWidget;
//
//   const ZohoChat(
//       {required this.zohoWidgetCode,
//         this.chatPreloaderColorHexString = "#000000",
//         this.chatPreloaderWidth = 10.0,
//         this.chatPreloaderSize = 120.0,
//         this.showMinimizeChatWidget = false});
//
//   @override
//   _ZohoChatState createState() {
//     return _ZohoChatState(zohoWidgetCode,
//         loaderColorHexString: chatPreloaderColorHexString,
//         loaderWidth: chatPreloaderWidth,
//         loaderSize: chatPreloaderSize,
//         showMinimizeChatWidget: showMinimizeChatWidget);
//   }
// }
//
// class _ZohoChatState extends State<ZohoChat> {
//   final String chatWidgetCode;
//   final String? loaderColorHexString;
//   final double? loaderWidth;
//   final double? loaderSize;
//   final bool? showMinimizeChatWidget;
//
//   _ZohoChatState(this.chatWidgetCode,
//       {this.loaderColorHexString,
//         this.loaderWidth,
//         this.loaderSize,
//         this.showMinimizeChatWidget});
//
//   final GlobalKey webViewKey = GlobalKey();
//
//   InAppWebViewController? webViewController;
//
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//     crossPlatform: InAppWebViewOptions(
//       javaScriptEnabled: true,
//       //clearCache: true,
//       //preferredContentMode: UserPreferredContentMode.MOBILE,
//       //mediaPlaybackRequiresUserGesture: true,
//     ),
//   );
//
//   bool showErrorPage = false;
//   String errorMessage = '';
//   bool startedServer = false;
//
//   void init() async {
//     await localhostServer.start();
//     setState(() {
//       startedServer = true;
//     });
//   }
//
//   @override
//   void initState() {
//     init();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     if (localhostServer.isRunning()) localhostServer.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final String functionBody = """
//
//     var stylesheet = document.styleSheets[1]
//     stylesheet.insertRule("#siqcht { margin-top: ${showMinimizeChatWidget! ? 0.0 : -4.5}rem;}", 0);
//     var loader = document.getElementsByClassName('loader')
//     for(i = 0; i < loader.length; i++) {
//       loader[i].style.border = '${loaderWidth}px solid #f3f3f3';
//       loader[i].style.borderTop = '${loaderWidth}px solid $loaderColorHexString';
//       loader[i].style.width = '${loaderSize}px';
//       loader[i].style.height = '${loaderSize}px';
//     }
//
//
// var \$zoho = \$zoho || {};
//       \$zoho.salesiq = \$zoho.salesiq || {
//         widgetcode:
//           "$chatWidgetCode",
//         values: {},
//         ready: function () {},
//       };
//       var d = document;
//       s = d.createElement("script");
//       s.type = "text/javascript";
//       s.id = "zsiqscript";
//       s.defer = true;
//       s.src = "https://salesiq.zoho.com/widget";
//
//       var t = d.getElementsByTagName("script")[0];
//       t.parentNode.insertBefore(s, t);
//       //d.write("<div id='zsiqwidget'></div>");
//       //
//       \$zoho.salesiq.afterReady = function (visitorgeoinfo) {
//         \$zoho.salesiq.floatwindow.visible("1");
//         setTimeout(function(){
//           loader[0].style.display = 'none';
//         }, 10000); //hide preloader after 10secs
//
//       };
// """;
//
//     return Container(
//         child: Stack(
//           children: <Widget>[
//             Column(children: <Widget>[
//               startedServer
//                   ? Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 child: InAppWebView(
//                   key: webViewKey,
//                   initialOptions: options,
//                   initialUrlRequest: URLRequest(
//                       url: Platform.isIOS
//                           ? Uri.parse(
//                           "http://localhost:2021/packages/zoho_chat/assets/index2.html")
//                           : Uri.parse(
//                           "http://localhost:2021/packages/zoho_chat/assets/index.html")),
//                   initialUserScripts: UnmodifiableListView<UserScript>([
//                     UserScript(
//                         source: functionBody,
//                         injectionTime:
//                         UserScriptInjectionTime.AT_DOCUMENT_START,
//                         iosForMainFrameOnly: true),
//                   ]),
//                   onWebViewCreated: (controller) {
//                     webViewController = controller;
//                   },
//                   onLoadStart: (controller, url) {},
//                   onLoadStop: (controller, url) async {},
//                   onLoadError: (controller, url, code, message) async {
//                     showError(message);
//                   },
//                   onConsoleMessage: (controller, message) {
//                     print("console message: $message");
//                   },
//                 ),
//               )
//                   : Center(child: CircularProgressIndicator())
//             ]),
//             showErrorPage
//                 ? Center(
//               child: Text("$errorMessage"),
//             )
//                 : Container(),
//           ],
//         ));
//   }
//
//   void showError(String error) {
//     setState(() {
//       errorMessage = error;
//       showErrorPage = true;
//     });
//   }
//
//   void hideError() {
//     setState(() {
//       errorMessage = '';
//       showErrorPage = false;
//     });
//   }
//
//   void reload() {
//     webViewController?.reload();
//   }
// }
