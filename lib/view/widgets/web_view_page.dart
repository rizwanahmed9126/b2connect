import 'dart:io';

import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/services/navigation_service.dart';
import 'package:b2connect_flutter/model/services/util_service.dart';
import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:b2connect_flutter/screen_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'appBar_with_cart_notification_widget.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage({required this.url, required this.title}) : super();

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  NavigationService navigationService = locator<NavigationService>();
  UtilService utilsService = locator<UtilService>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    //if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  // bool isLoading=true;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithCartNotificationWidget(
        title: widget.title,
        onTapIcon: () {
          /*i.mediaBlogsList.clear();*/
          navigationService.closeScreen();
        },
      ),
      body: Container(
        child: WebView(
          key: _key,
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (finish) {
            EasyLoading.dismiss();
            /* setState(() {
                isLoading = false;
              });*/
          },
        ),
        /* isLoading ? Center( child: CircularProgressIndicator(color: pink,),)
              : Stack(),*/
      ),
    );
  }
}

//       Container(
//         child: WebView(
//
//           initialUrl: widget.url,
//           javascriptMode: JavascriptMode.unrestricted,
//         ),
//       ),
//     );
//   }
// }
