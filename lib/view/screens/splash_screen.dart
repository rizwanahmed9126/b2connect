import 'dart:async';
import 'dart:io';
import 'package:b2connect_flutter/view_model/providers/offers_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../../screen_size.dart';
import '../../view_model/providers/auth_provider.dart';
import '../../model/utils/routes.dart';
import '../../model/utils/service_locator.dart';
import '../../model/services/storage_service.dart';
import '../../model/services/navigation_service.dart';





Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _mediaHeight;
  var _mediaWidth;
  var navigationService = locator<NavigationService>();
  var storageService = locator<StorageService>();


  // ignore: unused_field
 // var _alignment = Alignment.bottomCenter;
  checkConnection()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
    {
      print('abc');
      //

      getVersion();

    }
  }

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _mediaWidth = MediaQuery.of(context).size.width;
      _mediaHeight = MediaQuery.of(context).size.height;
      ScreenSize.screen(_mediaWidth, _mediaHeight);
    });
   /* setState(() {
      _alignment = Alignment.center;
    });*/

    Timer(Duration(seconds: 3), () async {
      await navigateDecision();
      //navigationService.navigateTo(MainDashBoardRoute);
    });

    checkConnection();
    loadData1();

  }

  loadData1() async {

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (!kIsWeb) {
      var token= await FirebaseMessaging.instance.getToken();
      print('this is the token--${token.toString()}');
      if(token!.isNotEmpty){


        //Provider.of<AuthProvider>(context,listen: false).callFcmToken(token.toString());
        Provider.of<AuthProvider>(context,listen: false).saveFcmToken(token.toString());
      }

      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        //'This channel is used for important notifications.', // description
        importance: Importance.high,
      );


      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
     await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }



    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message.notification!.title);
      print(message.notification!.body);


     // if (Platform.isAndroid)
        flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                //'This channel is used for important notifications.',
                importance: Importance.high,
                priority: Priority.high,
              ),
              iOS: IOSNotificationDetails(


              ),
            ));
      // if(Platform.isIOS)
      //   flutterLocalNotificationsPlugin.show(
      //       0,
      //       message.notification!.title,
      //       message.notification!.body,
      //       NotificationDetails(
      //         android: AndroidNotificationDetails(
      //           'high_importance_channel',
      //           'High Importance Notifications',
      //           //'This channel is used for important notifications.',
      //           importance: Importance.high,
      //           priority: Priority.high,
      //         ),
      //         iOS: IOSNotificationDetails(
      //
      //         ),
      //       ));
    });


    // await Provider.of<AuthProvider>(context, listen: false).callUserInfo(context).then((value) async {
    //   Provider.of<AuthProvider>(context, listen: false).saveUid(value.uid.toString());
    //
    //   await Provider.of<AuthProvider>(context, listen: false).callAdvert().then((value) {
    //     navigationService.navigateTo(HomeScreenRoute);
    //   });
    // });

  }

  navigateDecision() async {

    if (await storageService.getBoolData('isShowHome') == true) {

      navigationService.navigateTo(HomeScreenRoute);
      //await loadData1();
    } else {

      navigationService.navigateTo(OnBoardingRoute);
    }
  }

  void getVersion() async {
    final newVersion = NewVersion(
      androidId: "com.eurisko.azadea",
      iOSId: 'com.version check.iOS',
    );
    final status = await newVersion.getVersionStatus();
    //newVersion.showUpdateDialog(context: context, versionStatus: status!);
    //print("Device: ${status.localVersion}");
    Provider.of<AuthProvider>(context, listen: false).saveAppVersion(status!.localVersion);

    //print("Store: ${status.storeVersion}");
  }




  @override
  Widget build(BuildContext context) {

    // var mediaWidth = MediaQuery.of(context).size.width;
    // ScreenSize.screen(mediaWidth);

    return WillPopScope(
      onWillPop: null,
      child: Stack(
          // fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash1.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
            Positioned(
              child: Align(
                alignment: FractionalOffset.center,
                child: Container(
                  child:
                      // Container(child: Image.asset('assets/images/logo.png')),
                      ShowUpAnimation(
                    delayStart: Duration(milliseconds: 100),
                    animationDuration: Duration(seconds: 2),
                    curve: Curves.bounceIn,
                    direction: Direction.vertical,
                    offset: 0.7,
                    child: Container(
                      // height: 70,
                      // width: 70,
                      child:
                      // Image.asset(
                      //   'assets/images/logo.png',
                      //   fit: BoxFit.fill,
                      //   scale: 3,
                      // ),


                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.fill,
                            scale: 3,
                          ),
                          SizedBox(height: 10.h,),
                         Text('Connecting Communities Digitally',style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }


}
