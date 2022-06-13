import 'dart:async';
import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/models/advert_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/get_offers_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/offers_list_model.dart';
import 'package:b2connect_flutter/model/models/userinfo_model.dart';
import 'package:b2connect_flutter/model/services/navigation_service.dart';
import 'package:b2connect_flutter/model/services/storage_service.dart';
import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:b2connect_flutter/view/screens/view_all_offers_screen.dart';
import 'package:b2connect_flutter/view/widgets/appBar_with_cart_notification_widget.dart';
import 'package:b2connect_flutter/view/widgets/no_internet.dart';
import 'package:b2connect_flutter/view/widgets/offers_list_widget.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view/widgets/useful_widgets.dart';
import 'package:b2connect_flutter/view/widgets/web_view_page.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:b2connect_flutter/view_model/providers/fortune_provider.dart';
import 'package:b2connect_flutter/view_model/providers/blogs_provider.dart';
import 'package:b2connect_flutter/view_model/providers/offers_provider.dart';
import 'package:b2connect_flutter/view_model/providers/pay_by_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

//import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:provider/provider.dart';
import '../../model/models/advert_model.dart';
import '../../model/models/userinfo_model.dart';
import '../../model/services/navigation_service.dart';
import '../../model/services/storage_service.dart';
import '../../model/utils/routes.dart';
import '../../model/utils/service_locator.dart';
import '../../view/widgets/showOnWillPop.dart';
import '../../view/widgets/web_view_page.dart';
import '../../view_model/providers/auth_provider.dart';
import '../../model/models/notification_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

late GetOffers _offersData;
//List<AdvertismentModel> _data = [];
//List imgList = [];
//List onClickAgainstImg = [];
List<OffersList> _offerList = [];

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  NavigationService navigationService = locator<NavigationService>();
  var storageService = locator<StorageService>();
  List<NotificationModel> _notificationData = [];
  bool _connectedToInternet = true;

  loadData() async {
    await storageService.setBoolData('isShowHome', true);
  }

  callData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      loadData();
      setListData();

      Future.delayed(Duration.zero, () async {
        await Provider.of<AuthProvider>(context, listen: false)
            .callUserInfo()
            .then((value) async {
          Provider.of<AuthProvider>(context, listen: false)
              .saveUid(value.uid.toString());
        });

        await Provider.of<AuthProvider>(context, listen: false).callAdvert();

        Provider.of<AuthProvider>(context, listen: false)
            .userInfoData
            ?.spinEligable ==
            false /*&&
                Provider.of<AuthProvider>(context, listen: false)
                        .userInfoData
                        ?.spinResult ==
                    null*/
            ? _spinnerVisibility = false
            : _spinnerVisibility = true;

        if (Provider.of<AuthProvider>(context, listen: false)
            .notificationData
            .isEmpty ==
            true) {
          await Provider.of<AuthProvider>(context, listen: false)
              .callNotifications(context, '1', '30')
              .then((value) {
            setState(() {
              _notificationData.addAll(value);
            });
          });
        } else {
          _notificationData.addAll(
              Provider.of<AuthProvider>(context, listen: false)
                  .notificationData);
        }
      });
    } else {
      setState(() {
        _connectedToInternet = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    callData();
  }

  bool _spinnerVisibility = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Consumer<AuthProvider>(builder: (context, i, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWithCartNotificationWidget(
          title: i.userInfoData != null
              ? "${AppLocalizations.of(context)!.translate('welcome2')!} ${i.userInfoData!.firstName}"
              : "${AppLocalizations.of(context)!.translate('welcome2')!}",
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
        )/*AppBar(
          leading: Image.asset(
            "assets/images/logo_icon.png",
            scale: 8,
            height: 30.h,
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: height * 0.08,
          title: Consumer<AuthProvider>(builder: (context, i, _) {
            return Text(
              i.userInfoData != null
                  ? "${AppLocalizations.of(context)!.translate('welcome2')!} ${i.userInfoData!.firstName}"
                  : "${AppLocalizations.of(context)!.translate('welcome2')!}",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lexend',
                fontSize: ScreenSize.appbarText,
              ),
            );
          }),
          actions: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .callNotifications(context, '1', '30')
                        .then((value) {
                      setState(() {
                        // _notificationData.addAll(value);
                        navigationService.navigateTo(NotificationsScreenRoute);
                      });
                    });
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    // color: Colors.red,
                    margin: EdgeInsets.only(
                      right: 10.w,
                      top: 15.h,
                    ),
                    child: Icon(
                      Icons.notifications_outlined,

                      color: Colors.white,
                      size: 25, //ScreenSize.appbarIconSize,
                    ),
                  ),
                ),
              ],
            ),
            Consumer<PayByProvider>(builder: (context, i, _) {
              return i.offerItemsOrder.isNotEmpty
                  ? Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      navigationService.navigateTo(CartScreenRoute);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      // color: Colors.red,
                      margin: EdgeInsets.only(
                        right: 10.w,
                        top: 15.h,
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 25, //ScreenSize.appbarIconSize,
                      ),
                    ),
                  ),
                  Positioned(
                      left: 17.w,
                      top: 16.h,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text('${i.totalCartCount}',
                              style:
                              TextStyle(color: pink, fontSize: 10)),
                        ),
                      )),
                ],
              )
                  : Text(' ');
            })
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: gradientColor),
          ),
        )*/,

        // AppBar(
        //   automaticallyImplyLeading: false,
        //   elevation: 0,
        //   toolbarHeight:   //height*0.25,
        //   ScreenSize.appbarHeight,
        //   leading: Image.asset(
        //     "assets/images/logo_icon.png",
        //     scale: ScreenSize.appbarImage,
        //     height: 20.h,
        //   ),
        //   title: Text(
        //     userinfo != null ? "${AppLocalizations.of(context)!.translate('welcome2')!} ${userinfo!.firstName}" : "${AppLocalizations.of(context)!.translate('welcome2')!}",
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: ScreenSize.appbarText,
        //     ),
        //   ),
        //   actions: [
        //     Stack(
        //       children: [
        //         GestureDetector(
        //           onTap: () {
        //             navigationService.navigateTo(NotificationsScreenRoute);
        //           },
        //           child: Container(
        //             height: 30,
        //             width: 30,
        //             // color: Colors.red,
        //             margin: EdgeInsets.only(
        //               right: 10.w,
        //               top: 15.h,
        //             ),
        //             child: Icon(
        //               Icons.notifications_outlined,
        //               color: Colors.white,
        //               size: ScreenSize.appbarIconSize,
        //             ),
        //           ),
        //         ),
        //         Positioned(
        //           left: 17.w,
        //           top: 16.h,
        //           child: Provider.of<AuthProvider>(context, listen: false)
        //               .notificationSeen
        //               ? Container(
        //             width: width * 0.018,
        //             height: height * 0.018,
        //             decoration: BoxDecoration(
        //               shape: BoxShape.circle,
        //               color: Colors.red,
        //             ),
        //           )
        //               : Text(' '),
        //         )
        //       ],
        //     ),
        //   ],
        //   flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [
        //           Color.fromRGBO(224, 69, 123, 1),
        //           Color.fromRGBO(212, 69, 224, 1),
        //         ],
        //         begin: Alignment.centerLeft,
        //         end: Alignment.centerRight,
        //       ),
        //     ),
        //   ),
        // ),
        body: _connectedToInternet
            ? WillPopScope(
          onWillPop: () async {
            showOnWillPop(context);
            return false;
          },
          child: Padding(
            padding: EdgeInsets.only(left: 15.h, right: 15.h),
            child: SingleChildScrollView(
              child: AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 1000),
                    childAnimationBuilder: (widget) => ScaleAnimation(
                      scale: 1,
                      child: FlipAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),

                      // Container(
                      //   height: height * 0.12,
                      //   width: width,
                      //   decoration: BoxDecoration(
                      //     // borderRadius: BorderRadius.only(
                      //     //     bottomLeft: Radius.circular(42),
                      //     //     bottomRight: Radius.circular(42)),
                      //     gradient: LinearGradient(
                      //       colors: [
                      //         Color.fromRGBO(224, 69, 123, 1),
                      //         Color.fromRGBO(212, 69, 224, 1),
                      //       ],
                      //       begin: Alignment.centerLeft,
                      //       end: Alignment.centerRight,
                      //     ),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           SizedBox(width: 10,),
                      //           Row(
                      //             children: [
                      //               Image.asset(
                      //                 "assets/images/logo_icon.png",
                      //                 scale: ScreenSize.appbarImage,
                      //                 height: 25.h,
                      //               ),
                      //               SizedBox(
                      //                 width: 10,
                      //               ),
                      //               Container(
                      //                 height: height * 0.036,
                      //                 width: width * 0.6,
                      //                 child: Text(
                      //                   userinfo != null
                      //                       ? "${AppLocalizations.of(context)!.translate('welcome2')!} ${userinfo!.firstName}"
                      //                       : "${AppLocalizations.of(context)!.translate('welcome2')!}",
                      //                   overflow: TextOverflow.ellipsis,
                      //                   maxLines: 1,
                      //                   style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontSize: ScreenSize.appbarText,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             children: [
                      //               Stack(
                      //                 children: [
                      //                   GestureDetector(
                      //                     onTap: () {
                      //                       navigationService.navigateTo(
                      //                           NotificationsScreenRoute);
                      //                     },
                      //                     child: Container(
                      //                       height: 30,
                      //                       width: 30,
                      //                       // color: Colors.red,
                      //                       margin: EdgeInsets.only(
                      //                         right: 10.w,
                      //                         top: 15.h,
                      //                       ),
                      //                       child: Icon(
                      //                         Icons.notifications_outlined,
                      //                         color: Colors.white,
                      //                         size: ScreenSize.appbarIconSize,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   Positioned(
                      //                     left: 17.w,
                      //                     top: 16.h,
                      //                     child: Provider.of<AuthProvider>(
                      //                                 context,
                      //                                 listen: false)
                      //                             .notificationSeen
                      //                         ? Container(
                      //                             width: width * 0.018,
                      //                             height: height * 0.018,
                      //                             decoration: BoxDecoration(
                      //                               shape: BoxShape.circle,
                      //                               color: Colors.red,
                      //                             ),
                      //                           )
                      //                         : Text(' '),
                      //                   )
                      //                 ],
                      //               ),
                      //               Stack(
                      //                 children: [
                      //                   GestureDetector(
                      //                     onTap: () {
                      //                       navigationService.navigateTo(
                      //                           NotificationsScreenRoute);
                      //                     },
                      //                     child: Container(
                      //                       height: 30,
                      //                       width: 30,
                      //                       // color: Colors.red,
                      //                       margin: EdgeInsets.only(
                      //                         right: 10.w,
                      //                         top: 15.h,
                      //                       ),
                      //                       child: Icon(
                      //                         Icons.shopping_cart,
                      //                         color: Colors.white,
                      //                         size: ScreenSize.appbarIconSize,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   // Positioned(
                      //                   //   left: 17.w,
                      //                   //   top: 16.h,
                      //                   //   child: Provider.of<AuthProvider>(context, listen: false)
                      //                   //       .notificationSeen
                      //                   //       ? Container(
                      //                   //     width: width * 0.018,
                      //                   //     height: height * 0.018,
                      //                   //     decoration: BoxDecoration(
                      //                   //       shape: BoxShape.circle,
                      //                   //       color: Colors.red,
                      //                   //     ),
                      //                   //   )
                      //                   //       : Text(' '),
                      //                   // )
                      //                 ],
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //       // Row(
                      //       //   mainAxisAlignment: MainAxisAlignment.center,
                      //       //   children: [
                      //       //     InkWell(
                      //       //       onTap: () {
                      //       //         print('wifi');
                      //       //         navigationService
                      //       //             .navigateTo(WifiScreenRoute);
                      //       //       },
                      //       //       child: Column(
                      //       //         children: [
                      //       //           Container(
                      //       //               height: height * 0.08,
                      //       //               width: height * 0.08,
                      //       //               decoration: BoxDecoration(
                      //       //                   // image: DecorationImage(
                      //       //                   //   fit: BoxFit.cover,
                      //       //                   // ),
                      //       //                   gradient: LinearGradient(
                      //       //                     colors: [
                      //       //                       Color(0xFFE0457B),
                      //       //                       Color.fromARGB(
                      //       //                         100,
                      //       //                         255,
                      //       //                         199,
                      //       //                         0,
                      //       //                       ),
                      //       //                     ],
                      //       //                     begin: Alignment.topCenter,
                      //       //                     end: Alignment.bottomCenter,
                      //       //                   ),
                      //       //                   border:
                      //       //                       Border.all(color: Colors.white),
                      //       //                   borderRadius:
                      //       //                       BorderRadius.circular(6)),
                      //       //               child: Center(
                      //       //                 child: Icon(
                      //       //                   Icons.wifi,
                      //       //                   color: Colors.white,
                      //       //                   size: 30,
                      //       //                 ),
                      //       //               )
                      //       //               ),
                      //       //           SizedBox(
                      //       //             height: 3,
                      //       //           ),
                      //       //           Text(
                      //       //             'WIFI',
                      //       //             style: TextStyle(color: Colors.white),
                      //       //           )
                      //       //         ],
                      //       //       ),
                      //       //     ),
                      //       //     SizedBox(
                      //       //       width: width * 0.1,
                      //       //     ),
                      //       //     InkWell(
                      //       //       onTap: () {
                      //       //         Navigator.push(
                      //       //           context,
                      //       //           MaterialPageRoute(
                      //       //             builder: (context) => WebViewPage(
                      //       //               url:
                      //       //                   "https://go-games.gg/tournament?app=b2connect&country=ae&userid=${Provider.of<AuthProvider>(context, listen: false).getUID}",
                      //       //               title: AppLocalizations.of(context)!
                      //       //                   .translate('play')!,
                      //       //             ),
                      //       //           ),
                      //       //         );
                      //       //       },
                      //       //       child: Column(
                      //       //         children: [
                      //       //           Container(
                      //       //               height: height * 0.08,
                      //       //               width: height * 0.08,
                      //       //               decoration: BoxDecoration(
                      //       //                   gradient: LinearGradient(
                      //       //                     colors: [
                      //       //                       Color(0xFF252CDD)
                      //       //                           .withOpacity(1),
                      //       //                       Color(0xFF252CDD)
                      //       //                           .withOpacity(0),
                      //       //                     ],
                      //       //                     begin: Alignment.topCenter,
                      //       //                     end: Alignment.bottomCenter,
                      //       //                   ),
                      //       //                   border:
                      //       //                       Border.all(color: Colors.white),
                      //       //                   borderRadius:
                      //       //                       BorderRadius.circular(6)),
                      //       //               child: Center(
                      //       //                   child: Container(
                      //       //                 height: 20,
                      //       //                 child: Image.asset(
                      //       //               ))),
                      //       //           SizedBox(
                      //       //             height: 3,
                      //       //           ),
                      //       //           Text(
                      //       //             'Play',
                      //       //             style: TextStyle(color: Colors.white),
                      //       //           )
                      //       //         ],
                      //       //       ),
                      //       //     ),
                      //       //   ],
                      //       // )
                      //     ],
                      //   ),
                      // ),
                      Container(
                       // height: height * 0.14,
                        //padding: EdgeInsets.only( top: 10.h,),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.w,
                            color: Colors.grey.shade200,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top:20.0,bottom: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  tile(
                                      context: context,
                                      url: "assets/images/Consultation.png",
                                      title: AppLocalizations.of(context)!
                                          .translate('wifi')!,
                                      onTap: () {
                                        navigationService
                                            .navigateTo(WifiScreenRoute);
                                      }),
                                  tile(
                                      context: context,
                                      url: "assets/images/Dental.png",
                                      title: AppLocalizations.of(context)!
                                          .translate('shop')!,
                                      onTap: () {
                                        navigationService.navigateTo(
                                            CategoriesScreenRoute);
                                      }),
                                  tile(
                                      context: context,
                                      url: "assets/images/Heart.png",
                                      title: AppLocalizations.of(context)!
                                          .translate('play')!,
                                      onTap: () {
                                        EasyLoading.show(status: 'Loading..');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WebViewPage(
                                                  url:
                                                  "https://go-games.gg/tournament?app=b2connect&country=ae&userid=${Provider.of<AuthProvider>(context, listen: false).getUID}",
                                                  title: AppLocalizations.of(
                                                      context)!
                                                      .translate('play')!,
                                                ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  tile(
                                      context: context,
                                      url: "assets/images/Medicines.png",
                                      title: AppLocalizations.of(context)!
                                          .translate('money')!,
                                      onTap: ()  {
                                        navigationService
                                            .navigateTo(MoneyScreenRoute);
                                      }),
                                  tile(
                                      context: context,
                                      url: "assets/images/Hospitals.png",
                                      title: AppLocalizations.of(context)!
                                          .translate('wellness')!,
                                      onTap: ()  {

                                        navigationService
                                            .navigateTo(WellnessScreenRoute);
                                      }),
                                  tile(
                                      context: context,
                                      url: "assets/images/Physician.png",
                                      title: AppLocalizations.of(context)!
                                          .translate('entertainment')!,
                                      onTap: ()  {
                                        navigationService
                                            .navigateTo(MediaScreenRoute);
                                       /* EasyLoading.show(status: 'Loading..');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WebViewPage(
                                                  url:
                                                  "https://b2micro.netlify.app/",
                                                  title: AppLocalizations.of(
                                                      context)!
                                                      .translate('entertainment')!,
                                                ),
                                          ),
                                        );*/
                                      }),
                                ],
                              ),
                              // SizedBox(
                              //   height: height * 0.02,
                              // ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceAround,
                              //   children: [
                              //     tile(
                              //         context: context,
                              //         url: "assets/images/Medicines.png",
                              //         title: "Money"),
                              //     tile(
                              //         context: context,
                              //         url: "assets/images/Hospitals.png",
                              //         title: "Wellness"),
                              //     tile(
                              //         context: context,
                              //         url: "assets/images/Physician.png",
                              //         title: "Engage"),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

                      Visibility(
                        visible:  _spinnerVisibility,
                        child: GestureDetector(
                          onTap: () async {
                            await Provider.of<FortuneProvider>(context,
                                listen: false)
                                .getFortuneList()
                                .then((value) => navigationService
                                .navigateTo(SpinnerScreenRoute));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/game_background.png"),
                                scale: 1,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child:
                            /*  Image.asset(
                                      "assets/images/game_background.png"),*/
                            Row(
                              //mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    "assets/images/wheel_of_fortune.png",
                                    width: 50.w,
                                    height: 50.h,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Special Spin & Win',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child:
                                          Text('Click here to open'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      /*   Visibility(
                            visible: _spinnerVisibility,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Provider.of<FortuneProvider>(context,
                                        listen: false)
                                    .getFortuneList()
                                    .then((value) => navigationService
                                        .navigateTo(SpinnerScreenRoute));
                              },
                              child: Text('Spinner'),
                            ),
                          ),*/
                      /*Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              12.r,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.asset("assets/images/banner_img.png",fit: BoxFit.cover,)
                            // CachedNetworkImage(
                            //   imageUrl: item.mediaUrLs![0],
                            //   placeholder: (context, url) => Image.asset(
                            //   ),
                            //   errorWidget: (context, url, error) => Center(
                            //     child: Image.asset(
                            //       'assets/images/not_found1.png',
                            //       height: 100,
                            //     ),
                            //   ),
                            //   fit: BoxFit.cover,
                            // )

                            // FadeInImage(
                            //   image: NetworkImage(item.mediaUrLs![0]),
                            //   placeholder: AssetImage(
                            //   ),
                            //   fit: BoxFit.cover,
                            //
                            // ),
                          ),
                            ),
                            SizedBox(
                          height: 10.h,
                            ),*/

                      Container(
                        //height: height * 0.23,
                        child: Consumer<AuthProvider>(
                            builder: (context, i, _) {
                              i.bannerData.forEach((element) {});

                              return i.bannerData.isNotEmpty
                                  ? Column(
                                children: [
                                  CarouselSlider(
                                    carouselController: _controller,
                                    options: CarouselOptions(
                                      autoPlay: true,
                                    //  height: height * 0.2,
                                      //ScreenSize.sliderHeight,
                                      viewportFraction: 1.0,
                                      enlargeCenterPage: false,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      },
                                    ),
                                    items: i.bannerData
                                        .map((item) => GestureDetector(
                                      onTap: () {
                                        print(
                                            'index---${item.clickRedirectTo}');
                                        if (item.clickRedirectTo ==
                                            'WIFI')
                                          navigationService
                                              .navigateTo(
                                              WifiScreenRoute);
                                        else if (item
                                            .clickRedirectTo ==
                                            'SHOP')
                                          navigationService
                                              .navigateTo(
                                              CategoriesScreenRoute);
                                        else if (item
                                            .clickRedirectTo ==
                                            'GAMES') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  WebViewPage(
                                                    url:
                                                    "https://go-games.gg/tournament?app=b2connect&country=ae&userid=${Provider.of<AuthProvider>(context, listen: false).getUID}",
                                                    title: AppLocalizations.of(
                                                        context)!
                                                        .translate(
                                                        'play')!,
                                                  ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(
                                            left: 5.0,
                                            right: 5),
                                        child: Container(
                                          decoration:
                                          BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                              12.r,
                                            ),
                                          ),
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width,
                                          child: ClipRRect(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  12.r),
                                              child: //Image.asset("assets/images/banner_img.png",fit: BoxFit.cover,)
                                              CachedNetworkImage(
                                                imageUrl: item
                                                    .mediaUrLs![0],
                                                /*placeholder: (context, url) => Image.asset(
                                            ),*/
                                                errorWidget:
                                                    (context,
                                                    url,
                                                    error) =>
                                                    Center(
                                                      child: Image
                                                          .asset(
                                                        'assets/images/not_found1.png',
                                                        height: 100,
                                                      ),
                                                    ),
                                                fit: BoxFit
                                                    .cover,
                                              )

                                            // FadeInImage(
                                            //   image: NetworkImage(item.mediaUrLs![0]),
                                            //   placeholder: AssetImage(
                                            //   ),
                                            //   fit: BoxFit.cover,
                                            //
                                            // ),
                                          ),
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: i.bannerData
                                          .asMap()
                                          .entries
                                          .map(
                                            (entry) {
                                          return GestureDetector(
                                            onTap: () => _controller
                                                .animateToPage(
                                                entry.key),
                                            child: Container(
                                              width: 15.w,
                                              height: 7.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _current ==
                                                    entry.key
                                                    ? pink
                                                    : Colors.grey,
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ],
                              )
                                  : Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              );
                            }),
                      ),

                      // SizedBox(
                      //   height: 20.h,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .translate('our_products')!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                //Printy();
                                EasyLoading.show(
                                    status: AppLocalizations.of(context)!
                                        .translate('please_wait')!);
                                await getData(10).then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewAllOffersScreen(
                                            // categoryId: widget.categoryId,
                                            //  filterBy: _name,
                                            perPage: 10,
                                          ),
                                    ),
                                  );
                                }); /*navigationService.navigateTo(ViewAllOffersScreenRoute));*/
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('view_all')!,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      OffersListWidget(_offerList),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                  mainAxisSize: MainAxisSize.max,
                ),
              ),
            ),
          ),
        )
            : NoInternet());});
  }

  Future<void> getData(int perPage) async {
    await Provider.of<OffersProvider>(context, listen: false)
        .getOffers(perPage: perPage);
  }

  Future<void> setListData() async {
    await getData(4);
    _offersData =
    Provider.of<OffersProvider>(context, listen: false).offersData!;
    _offerList = _offersData.offers;
    // offerList.addAll(offersData.offers);
  }
}

// btn3(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         titlePadding: EdgeInsets.all(0),
//         title: Container(
//           height: 130.h,
//           width: 130.w,
//           child: Center(
//             child: Image.asset('assets/images/login_success.gif'),
//           ),
//         ),
//         content:
//             Text(AppLocalizations.of(context)!.translate('welcome_on_board')!),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Navigator.pop(context);
//             },
//             child: Text(
//               AppLocalizations.of(context)!.translate('ok')!,
//               style: TextStyle(
//                 color: Color(0xFF4A843E),
//               ),
//             ),
//           )
//         ],
//       );
//     },
//   );
// }

Widget tile({context, String? url, String? title, VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Image.asset(
          url!,
          height: MediaQuery.of(context).size.height * 0.075,
          //scale:2.6 //ScreenSize.categoryImage,
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          title!,
          style: TextStyle(fontWeight: FontWeight.w400),
        )
      ],
    ),
  );
}
