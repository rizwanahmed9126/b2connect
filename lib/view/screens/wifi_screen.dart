import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/models/userinfo_model.dart';
import 'package:b2connect_flutter/model/models/wifi_package_model.dart';
import 'package:b2connect_flutter/model/services/navigation_service.dart';
import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:b2connect_flutter/screen_size.dart';
import 'package:b2connect_flutter/view/screens/main_dashboard_screen.dart';
import 'package:b2connect_flutter/view/screens/payment_method_screen.dart';
import 'package:b2connect_flutter/view/screens/wifi_plan.dart';
import 'package:b2connect_flutter/view/widgets/custom_buttons/gradiant_color_button.dart';
import 'package:b2connect_flutter/view/widgets/no_data_screen.dart';
import 'package:b2connect_flutter/view/widgets/no_internet.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:b2connect_flutter/view_model/providers/pay_by_provider.dart';
import 'package:b2connect_flutter/view_model/providers/wifi_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:readmore/readmore.dart';

class WifiScreen extends StatefulWidget {
  WifiScreen({Key? key}) : super(key: key);

  @override
  _WifiScreenState createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  List<WifiModel> _singleDevices = [];
  List<WifiModel> _multipleDevices = [];
  NavigationService _navigationService = locator<NavigationService>();

  bool? _showLoader;
  bool _connectedToInternet = true;

  String _value = 'All';
  String deviceAvailable = '';

  void handleClick(int item, double height) {
    switch (item) {
      case 0:
        setState(() {
          deviceAvailable = ' ';
          _value = 'All';
        });
        break;
      case 1:
        setState(() {
          deviceAvailable = ' ';
          _value = 'single';
          deviceAvailable = 'No Single Device Packages Available';
        });
        break;
      case 2:
        setState(() {
          deviceAvailable = ' ';
          _value = 'multiple';
          deviceAvailable = 'No Multiple Device Packages Available';
        });
        break;
    }
  }

  getData() async {
    if (Provider.of<WifiProvider>(context, listen: false).wifiData.isEmpty) {
      Provider.of<WifiProvider>(context, listen: false).wifiData.clear();
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        await Provider.of<WifiProvider>(context, listen: false)
            .callWifi()
            .then((value) {
          setState(() {
            if (value == "failed") {
              setState(() {
                _showLoader = true;
              });
            } else {
              value.forEach((element) {
                if (element.devices == 1) {
                  _singleDevices.add(element);
                } else if (element.devices == 2) {
                  _multipleDevices.add(element);
                }
              });
            }
          });
        });
      } else {
        setState(() {
          _connectedToInternet = false;
        });
      }
    } else {
      Provider.of<WifiProvider>(context, listen: false)
          .wifiData
          .forEach((element) {
        if (element.devices == 1) {
          _singleDevices.add(element);
        } else if (element.devices == 2) {
          _multipleDevices.add(element);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<PayByProvider>().getPayByDeviceId();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return _connectedToInternet
        ? Consumer<WifiProvider>(builder: (context, index, _) {
            return _showLoader == null
                ? DefaultTabController(
                    length: 2,
                    child: Scaffold(
                        backgroundColor: Colors.white,
                        appBar: AppBar(
                          bottom: TabBar(
                            indicator: BoxDecoration(
                                //borderRadius: BorderRadius.circular(50), // Creates border
                                color: Colors.white),

                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor: Colors.white,

                            indicatorColor: Colors.white,
                            tabs: [
                              Tab(
                                text: 'Normal',
                              ),
                              Tab(
                                text: 'Corporate',
                              )
                            ],
                          ),
                          leading: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                _navigationService.closeScreen();
                              },
                              icon: Icon(Icons.arrow_back_ios)),
                          toolbarHeight: ScreenSize.appbarHeight,
                          automaticallyImplyLeading: false,
                          centerTitle: false,
                          elevation: 0,
                          title: Text(
                            AppLocalizations.of(context)!.translate('wifi')!,
                            style: TextStyle(
                              fontSize: ScreenSize.appbarText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          actions: [
                            PopupMenuButton<int>(
                              icon: Image.asset(
                                'assets/images/filter_icon.png',
                                color: Colors.white,
                                height: 20,
                              ),
                              onSelected: (item) => handleClick(item, height),
                              itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                    value: 0, child: Text('All')),
                                PopupMenuItem<int>(
                                    value: 1, child: Text('Single Device')),
                                PopupMenuItem<int>(
                                    value: 2, child: Text('Multiple Devices')),
                              ],
                            ),
                          ],
                          flexibleSpace: Container(
                            decoration: BoxDecoration(gradient: gradientColor),
                          ),
                        ),
                        body: index.wifiData.isNotEmpty
                            ? Container(
                                padding: EdgeInsets.all(15.h),
                                child: TabBarView(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          if (_value == 'single') ...[
                                            _singleDevices.isNotEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'single_device')!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Container(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              _singleDevices
                                                                  .length,
                                                          // addRepaintBoundaries: false,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),

                                                          itemBuilder:
                                                              (context, i) {
                                                            double val =
                                                                _singleDevices[
                                                                            i]
                                                                        .validity /
                                                                    86400;
                                                            print(
                                                                'this is value--$val');
                                                            String abc = val
                                                                .toStringAsFixed(
                                                                    0);

                                                            var parts =
                                                                _singleDevices[
                                                                        i]
                                                                    .description
                                                                    .split('2');
                                                            var prefix =
                                                                parts[0].trim();

                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  width: width,
                                                                  height:
                                                                      height *
                                                                          0.20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          gradient:
                                                                              gradientColor,
                                                                          //color: Color(0xFFE0457B),
                                                                          borderRadius:
                                                                              BorderRadius.circular(17)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            1.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              height * 0.14,
                                                                          width:
                                                                              width,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(17)),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(12.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Validity',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          "$abc days",
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 30,
                                                                                      width: 1,
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Limit',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          '${_singleDevices[i].devices.toString()} Device',
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 30,
                                                                                      width: 1,
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Speed',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          '${_singleDevices[i].bandwidth} Mbps',
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: width * 0.9,
                                                                                height: 1,
                                                                                color: Colors.grey[300],
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 11),
                                                                                child: Container(
                                                                                  width: width,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      // Container(
                                                                                      //   height: height * 0.05,
                                                                                      //   width: width*0.55,
                                                                                      //   //color: Colors.green,
                                                                                      //   child: //ReadMore
                                                                                      //   Text(
                                                                                      //     prefix,
                                                                                      //     overflow: TextOverflow.ellipsis,
                                                                                      //     maxLines: 3,
                                                                                      //     style: TextStyle(fontSize: 12),
                                                                                      //   ),
                                                                                      // ),

                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, right: 10),
                                                                                        decoration: BoxDecoration(
                                                                                          gradient: LinearGradient(
                                                                                            colors:
                                                                                                // [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                                                                _singleDevices[i].name == "BLUE"
                                                                                                    ? [
                                                                                                        Color(0xFF5787E3),
                                                                                                        Color(0xFF5787E3),
                                                                                                      ]
                                                                                                    : _singleDevices[i].name == "SILVER"
                                                                                                        ? [
                                                                                                            Color(0xFF3D3C3A),
                                                                                                            Color(0xFFC8C5BD),
                                                                                                          ]
                                                                                                        : _singleDevices[i].name == "GOLD+"
                                                                                                            ? [
                                                                                                                Color(0xFFF4C73E),
                                                                                                                Color(0xFFB99013),
                                                                                                              ]
                                                                                                            : _singleDevices[i].name == "GOLD"
                                                                                                                ? [
                                                                                                                    Color(0xFFF4C73E),
                                                                                                                    Color(0xFFB99013),
                                                                                                                  ]
                                                                                                                : _singleDevices[i].name == "CRYSTAL"
                                                                                                                    ? [
                                                                                                                        Color(0xFFF19164),
                                                                                                                        Color(0xFFF19164),
                                                                                                                      ]
                                                                                                                    : [
                                                                                                                        Color(0xFF1A1A1A),
                                                                                                                        Color(0xFF1A1A1A),
                                                                                                                      ],
                                                                                            begin: const FractionalOffset(0.2, 0.0),
                                                                                            end: const FractionalOffset(1.1, 0.0),
                                                                                          ),

                                                                                          // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                                                          //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                                                          //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),

                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(40.r),
                                                                                          ),
                                                                                        ),
                                                                                        height: 21.h,
                                                                                        //width: 100.w,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            /* Image.asset(
                                                                        _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                                            :
                                                                        "assets/images/wifi_icon.png",
                                                                        color: Colors.white,
                                                                        height: 11.h,
                                                                        // scale: 8,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5.w,
                                                                      ),*/
                                                                                            Text(
                                                                                              //_singleDevices[i].name,
                                                                                              "${_singleDevices[i].name}",
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize: 10.sp,
                                                                                                //height: 1.8,
                                                                                              ),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 12.0,
                                                                              right: 12,
                                                                              top: 5),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              /* Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => PaymentMethod(
                                                                  price: '${_singleDevices[i].price.toStringAsFixed(2)}',
                                                                  id: _singleDevices[i].id,
                                                                  comingFrom: false,
                                                                )));*/
                                                                              EasyLoading.show(status: AppLocalizations.of(context)!.translate('please_wait')!);
                                                                              await context.read<PayByProvider>().payByPackageOrder(context, _singleDevices[i].id);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: height * 0.05,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    'AED ${_singleDevices[i].price.toStringAsFixed(2)}',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    'Buy Now',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      height *
                                                                          0.03,
                                                                )
                                                              ],
                                                            );

                                                            //   Card(
                                                            //   elevation: 0,
                                                            //   shape: RoundedRectangleBorder(
                                                            //     side: BorderSide(
                                                            //       color: Colors.grey.shade300,
                                                            //       width: 1.w,
                                                            //     ),
                                                            //     borderRadius: BorderRadius.circular(10),
                                                            //   ),
                                                            //   // decoration: BoxDecoration(
                                                            //   //   borderRadius: BorderRadius.circular(10),
                                                            //   //   border: Border.all()
                                                            //   // ),
                                                            //   child: Column(
                                                            //     crossAxisAlignment: CrossAxisAlignment.start,
                                                            //     children: [
                                                            //       Container(
                                                            //         // width: double.infinity,
                                                            //         // height: 120.h,
                                                            //         decoration: BoxDecoration(
                                                            //           color: Colors.pink.shade50,
                                                            //           borderRadius: BorderRadius.only(
                                                            //             topLeft: Radius.circular(10.r),
                                                            //             topRight: Radius.circular(10.r),
                                                            //           ),
                                                            //         ),
                                                            //         child: Padding(
                                                            //           padding: EdgeInsets.all(8.0.h),
                                                            //           child: Column(
                                                            //             crossAxisAlignment:
                                                            //             CrossAxisAlignment.start,
                                                            //             children: [
                                                            //               Row(
                                                            //                 children: [
                                                            //                   Container(
                                                            //                     padding: EdgeInsets.only(left: 10,right: 10),
                                                            //                     decoration: BoxDecoration(
                                                            //                       gradient: LinearGradient(
                                                            //                         colors:
                                                            //                         _singleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                                            //                             : _singleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                                            //                             : _singleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                            //                             : _singleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                            //                             :_singleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                                            //                             : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                            //                         begin: const FractionalOffset(
                                                            //                             0.2, 0.0),
                                                            //                         end: const FractionalOffset(
                                                            //                             1.1, 0.0),
                                                            //                       ),
                                                            //
                                                            //                       // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                            //                       //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                            //                       //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                                            //
                                                            //                       borderRadius: BorderRadius.all(
                                                            //                         Radius.circular(50.r),
                                                            //                       ),
                                                            //                     ),
                                                            //                     height: 30.h,
                                                            //                     //width: 100.w,
                                                            //                     child: Row(
                                                            //                       mainAxisAlignment: MainAxisAlignment.center,
                                                            //                       crossAxisAlignment: CrossAxisAlignment.center,
                                                            //                       children: [
                                                            //                         Image.asset(
                                                            //                           _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                            //                               : "assets/images/wifi_icon.png",
                                                            //                           color: Colors.white,
                                                            //                           height: 16.h,
                                                            //                           scale: 8,
                                                            //                         ),
                                                            //                         SizedBox(
                                                            //                           width: 5.w,
                                                            //                         ),
                                                            //                         Text(
                                                            //                           _singleDevices[i].name,
                                                            //                           style: TextStyle(
                                                            //                             color: Colors.white,
                                                            //                             fontWeight: FontWeight.w600,
                                                            //                             fontSize: 12.sp,
                                                            //                             height: 1.8,
                                                            //                           ),
                                                            //                           textAlign: TextAlign.center,
                                                            //                         ),
                                                            //                       ],
                                                            //                     ),
                                                            //                   ),
                                                            //                 ],
                                                            //               ),
                                                            //               SizedBox(
                                                            //                 height: 5,
                                                            //               ),
                                                            //               Container(
                                                            //                 height: height * 0.07,
                                                            //                 child: //ReadMore
                                                            //                 Text(
                                                            //                   prefix,
                                                            //                   overflow: TextOverflow.clip,
                                                            //                   maxLines: 3,
                                                            //                   style: TextStyle(fontSize: 12),
                                                            //                 ),
                                                            //               ),
                                                            //               SizedBox(
                                                            //                 height: 7.h,
                                                            //               ),
                                                            //               Text(
                                                            //                 "${_singleDevices[i].price.toString()} AED",
                                                            //                 style: TextStyle(
                                                            //                   fontSize: 28.sp,
                                                            //                   fontWeight: FontWeight.w700,
                                                            //                 ),
                                                            //               )
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 20.h,
                                                            //       ),
                                                            //       Padding(
                                                            //         padding: EdgeInsets.only(
                                                            //           left: 10.w,
                                                            //           right: 10.w,
                                                            //         ),
                                                            //         child: Row(
                                                            //           mainAxisAlignment:
                                                            //           MainAxisAlignment.spaceBetween,
                                                            //           children: [
                                                            //             Text(
                                                            //               "Validity",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.grey.shade500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //             Text(
                                                            //               "$abc days",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.black,
                                                            //                 fontWeight: FontWeight.w500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //           ],
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 10.h,
                                                            //       ),
                                                            //       Padding(
                                                            //         padding: EdgeInsets.only(
                                                            //           left: 10.w,
                                                            //           right: 10.w,
                                                            //         ),
                                                            //         child: Row(
                                                            //           mainAxisAlignment:
                                                            //           MainAxisAlignment.spaceBetween,
                                                            //           children: [
                                                            //             Text(
                                                            //               "# of Devices",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.grey.shade500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //             Text(
                                                            //               "${_singleDevices[i].devices.toString()}",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.black,
                                                            //                 fontWeight: FontWeight.w500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //           ],
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 10.h,
                                                            //       ),
                                                            //       Padding(
                                                            //         padding: EdgeInsets.only(
                                                            //           left: 10.w,
                                                            //           right: 10.w,
                                                            //         ),
                                                            //         child: Row(
                                                            //           mainAxisAlignment:
                                                            //           MainAxisAlignment.spaceBetween,
                                                            //           children: [
                                                            //             Text(
                                                            //               "Speed upto",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.grey.shade500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //             Text(
                                                            //               "${_singleDevices[i].bandwidth.toString()}Mbps",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.black,
                                                            //                 fontWeight: FontWeight.w500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //           ],
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 10.h,
                                                            //       ),
                                                            //       Divider(),
                                                            //       Container(
                                                            //         height:45,
                                                            //         //color:Colors.red,
                                                            //         child: Center(
                                                            //           child: CustomButton(
                                                            //             height: 40.h,
                                                            //             width: 140.w,
                                                            //             onPressed: () {
                                                            //               Navigator.push(
                                                            //                   context,
                                                            //                   MaterialPageRoute(
                                                            //                       builder: (context) => PaymentMethod(
                                                            //                         price: _singleDevices[i].price.toString(),
                                                            //                         id: _singleDevices[i].id.toString(),
                                                            //                       )));
                                                            //             },
                                                            //             text: AppLocalizations.of(context)!
                                                            //                 .translate('buy_now')!,
                                                            //           ),
                                                            //         ),
                                                            //       ),
                                                            //
                                                            //     ],
                                                            //   ),
                                                            // );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text('$deviceAvailable'),
                                          ] else if (_value == 'multiple') ...[
                                            _multipleDevices.isNotEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'multiple_device')!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Container(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              _multipleDevices
                                                                  .length,
                                                          // addRepaintBoundaries: false,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),

                                                          itemBuilder:
                                                              (context, i) {
                                                            double val =
                                                                _multipleDevices[
                                                                            i]
                                                                        .validity /
                                                                    86400;
                                                            print(
                                                                'this is value--$val');
                                                            String abc = val
                                                                .toStringAsFixed(
                                                                    0);

                                                            var parts =
                                                                _multipleDevices[
                                                                        i]
                                                                    .description
                                                                    .split('2');
                                                            var prefix =
                                                                parts[0].trim();

                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  width: width,
                                                                  height:
                                                                      height *
                                                                          0.20,
                                                                  decoration: BoxDecoration(
                                                                      gradient:
                                                                          gradientColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              17)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            1.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              height * 0.14,
                                                                          width:
                                                                              width,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(17)),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(12.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Validity',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          "$abc days",
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 30,
                                                                                      width: 1,
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Limit',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          '${_multipleDevices[i].devices.toString()} Devices',
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 30,
                                                                                      width: 1,
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Speed',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          '${_multipleDevices[i].bandwidth} Mbps',
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: width * 0.9,
                                                                                height: 1,
                                                                                color: Colors.grey[300],
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 11),
                                                                                child: Container(
                                                                                  width: width,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      // Container(
                                                                                      //   height: height * 0.05,
                                                                                      //   width: width*0.55,
                                                                                      //   //color: Colors.green,
                                                                                      //   child: //ReadMore
                                                                                      //   Text(
                                                                                      //     prefix,
                                                                                      //     overflow: TextOverflow.ellipsis,
                                                                                      //     maxLines: 3,
                                                                                      //     style: TextStyle(fontSize: 12),
                                                                                      //   ),
                                                                                      // ),

                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, right: 10),
                                                                                        decoration: BoxDecoration(
                                                                                          gradient: LinearGradient(
                                                                                            colors:
                                                                                                // [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                                                                _multipleDevices[i].name == "BLUE"
                                                                                                    ? [
                                                                                                        Color(0xFF5787E3),
                                                                                                        Color(0xFF5787E3),
                                                                                                      ]
                                                                                                    : _multipleDevices[i].name == "SILVER"
                                                                                                        ? [
                                                                                                            Color(0xFF3D3C3A),
                                                                                                            Color(0xFFC8C5BD),
                                                                                                          ]
                                                                                                        : _multipleDevices[i].name == "GOLD+"
                                                                                                            ? [
                                                                                                                Color(0xFFF4C73E),
                                                                                                                Color(0xFFB99013),
                                                                                                              ]
                                                                                                            : _multipleDevices[i].name == "GOLD"
                                                                                                                ? [
                                                                                                                    Color(0xFFF4C73E),
                                                                                                                    Color(0xFFB99013),
                                                                                                                  ]
                                                                                                                : _multipleDevices[i].name == "CRYSTAL"
                                                                                                                    ? [
                                                                                                                        Color(0xFFF19164),
                                                                                                                        Color(0xFFF19164),
                                                                                                                      ]
                                                                                                                    : [
                                                                                                                        Color(0xFF1A1A1A),
                                                                                                                        Color(0xFF1A1A1A),
                                                                                                                      ],
                                                                                            begin: const FractionalOffset(0.2, 0.0),
                                                                                            end: const FractionalOffset(1.1, 0.0),
                                                                                          ),

                                                                                          // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                                                          //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                                                          //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),

                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(40.r),
                                                                                          ),
                                                                                        ),
                                                                                        height: 21.h,
                                                                                        //width: 100.w,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            /*Image.asset(
                                                                        _multipleDevices[i].name == "GOLD" || _multipleDevices[i].name == "GOLD+" || _multipleDevices[i].name == "PLATINUM" || _multipleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                                            :
                                                                        "assets/images/wifi_icon.png",
                                                                        color: Colors.white,
                                                                        height: 11.h,
                                                                        //scale: 8,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5.w,
                                                                      ),*/
                                                                                            Text(
                                                                                              //_singleDevices[i].name,
                                                                                              "${_multipleDevices[i].name}",
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize: 10.sp,
                                                                                                //height: 1.8,
                                                                                              ),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 12.0,
                                                                              right: 12),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              /* Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => PaymentMethod(
                                                                  price: "${_multipleDevices[i].price.toStringAsFixed(2)}",
                                                                  id: _multipleDevices[i].id,
                                                                  comingFrom: false,
                                                                )));*/
                                                                              EasyLoading.show(status: AppLocalizations.of(context)!.translate('please_wait')!);
                                                                              await context.read<PayByProvider>().payByPackageOrder(context, _multipleDevices[i].id);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: height * 0.05,
                                                                              //color: Colors.green,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    'AED ${_multipleDevices[i].price.toStringAsFixed(2)}',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    'Buy Now',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      height *
                                                                          0.03,
                                                                )
                                                              ],
                                                            );

                                                            //   Card(
                                                            //   elevation: 0,
                                                            //   shape: RoundedRectangleBorder(
                                                            //     side: BorderSide(
                                                            //       color: Colors.grey.shade300,
                                                            //       width: 1.w,
                                                            //     ),
                                                            //     borderRadius: BorderRadius.circular(10),
                                                            //   ),
                                                            //   // decoration: BoxDecoration(
                                                            //   //   borderRadius: BorderRadius.circular(10),
                                                            //   //   border: Border.all()
                                                            //   // ),
                                                            //   child: Column(
                                                            //     crossAxisAlignment: CrossAxisAlignment.start,
                                                            //     children: [
                                                            //       Container(
                                                            //         // width: double.infinity,
                                                            //         // height: 120.h,
                                                            //         decoration: BoxDecoration(
                                                            //           color: Colors.pink.shade50,
                                                            //           borderRadius: BorderRadius.only(
                                                            //             topLeft: Radius.circular(10.r),
                                                            //             topRight: Radius.circular(10.r),
                                                            //           ),
                                                            //         ),
                                                            //         child: Padding(
                                                            //           padding: EdgeInsets.all(8.0.h),
                                                            //           child: Column(
                                                            //             crossAxisAlignment:
                                                            //             CrossAxisAlignment.start,
                                                            //             children: [
                                                            //               Row(
                                                            //                 children: [
                                                            //                   Container(
                                                            //                     padding: EdgeInsets.only(left: 10,right: 10),
                                                            //                     decoration: BoxDecoration(
                                                            //                       gradient: LinearGradient(
                                                            //                         colors:
                                                            //                         _singleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                                            //                             : _singleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                                            //                             : _singleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                            //                             : _singleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                            //                             :_singleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                                            //                             : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                            //                         begin: const FractionalOffset(
                                                            //                             0.2, 0.0),
                                                            //                         end: const FractionalOffset(
                                                            //                             1.1, 0.0),
                                                            //                       ),
                                                            //
                                                            //                       // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                            //                       //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                            //                       //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                                            //
                                                            //                       borderRadius: BorderRadius.all(
                                                            //                         Radius.circular(50.r),
                                                            //                       ),
                                                            //                     ),
                                                            //                     height: 30.h,
                                                            //                     //width: 100.w,
                                                            //                     child: Row(
                                                            //                       mainAxisAlignment: MainAxisAlignment.center,
                                                            //                       crossAxisAlignment: CrossAxisAlignment.center,
                                                            //                       children: [
                                                            //                         Image.asset(
                                                            //                           _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                            //                               : "assets/images/wifi_icon.png",
                                                            //                           color: Colors.white,
                                                            //                           height: 16.h,
                                                            //                           scale: 8,
                                                            //                         ),
                                                            //                         SizedBox(
                                                            //                           width: 5.w,
                                                            //                         ),
                                                            //                         Text(
                                                            //                           _singleDevices[i].name,
                                                            //                           style: TextStyle(
                                                            //                             color: Colors.white,
                                                            //                             fontWeight: FontWeight.w600,
                                                            //                             fontSize: 12.sp,
                                                            //                             height: 1.8,
                                                            //                           ),
                                                            //                           textAlign: TextAlign.center,
                                                            //                         ),
                                                            //                       ],
                                                            //                     ),
                                                            //                   ),
                                                            //                 ],
                                                            //               ),
                                                            //               SizedBox(
                                                            //                 height: 5,
                                                            //               ),
                                                            //               Container(
                                                            //                 height: height * 0.07,
                                                            //                 child: //ReadMore
                                                            //                 Text(
                                                            //                   prefix,
                                                            //                   overflow: TextOverflow.clip,
                                                            //                   maxLines: 3,
                                                            //                   style: TextStyle(fontSize: 12),
                                                            //                 ),
                                                            //               ),
                                                            //               SizedBox(
                                                            //                 height: 7.h,
                                                            //               ),
                                                            //               Text(
                                                            //                 "${_singleDevices[i].price.toString()} AED",
                                                            //                 style: TextStyle(
                                                            //                   fontSize: 28.sp,
                                                            //                   fontWeight: FontWeight.w700,
                                                            //                 ),
                                                            //               )
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 20.h,
                                                            //       ),
                                                            //       Padding(
                                                            //         padding: EdgeInsets.only(
                                                            //           left: 10.w,
                                                            //           right: 10.w,
                                                            //         ),
                                                            //         child: Row(
                                                            //           mainAxisAlignment:
                                                            //           MainAxisAlignment.spaceBetween,
                                                            //           children: [
                                                            //             Text(
                                                            //               "Validity",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.grey.shade500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //             Text(
                                                            //               "$abc days",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.black,
                                                            //                 fontWeight: FontWeight.w500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //           ],
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 10.h,
                                                            //       ),
                                                            //       Padding(
                                                            //         padding: EdgeInsets.only(
                                                            //           left: 10.w,
                                                            //           right: 10.w,
                                                            //         ),
                                                            //         child: Row(
                                                            //           mainAxisAlignment:
                                                            //           MainAxisAlignment.spaceBetween,
                                                            //           children: [
                                                            //             Text(
                                                            //               "# of Devices",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.grey.shade500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //             Text(
                                                            //               "${_singleDevices[i].devices.toString()}",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.black,
                                                            //                 fontWeight: FontWeight.w500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //           ],
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 10.h,
                                                            //       ),
                                                            //       Padding(
                                                            //         padding: EdgeInsets.only(
                                                            //           left: 10.w,
                                                            //           right: 10.w,
                                                            //         ),
                                                            //         child: Row(
                                                            //           mainAxisAlignment:
                                                            //           MainAxisAlignment.spaceBetween,
                                                            //           children: [
                                                            //             Text(
                                                            //               "Speed upto",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.grey.shade500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //             Text(
                                                            //               "${_singleDevices[i].bandwidth.toString()}Mbps",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.black,
                                                            //                 fontWeight: FontWeight.w500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //           ],
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 10.h,
                                                            //       ),
                                                            //       Divider(),
                                                            //       Container(
                                                            //         height:45,
                                                            //         //color:Colors.red,
                                                            //         child: Center(
                                                            //           child: CustomButton(
                                                            //             height: 40.h,
                                                            //             width: 140.w,
                                                            //             onPressed: () {
                                                            //               Navigator.push(
                                                            //                   context,
                                                            //                   MaterialPageRoute(
                                                            //                       builder: (context) => PaymentMethod(
                                                            //                         price: _singleDevices[i].price.toString(),
                                                            //                         id: _singleDevices[i].id.toString(),
                                                            //                       )));
                                                            //             },
                                                            //             text: AppLocalizations.of(context)!
                                                            //                 .translate('buy_now')!,
                                                            //           ),
                                                            //         ),
                                                            //       ),
                                                            //
                                                            //     ],
                                                            //   ),
                                                            // );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text('$deviceAvailable'),
                                          ] else ...[
                                            _singleDevices.isNotEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'single_device')!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Container(
                                                        child: AnimationLimiter(
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                _singleDevices
                                                                    .length,
                                                            // addRepaintBoundaries: false,
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),

                                                            itemBuilder:
                                                                (context, i) {
                                                              double val =
                                                                  _singleDevices[
                                                                              i]
                                                                          .validity /
                                                                      86400;
                                                              print(
                                                                  'this is value--$val');
                                                              String abc = val
                                                                  .toStringAsFixed(
                                                                      0);

                                                              var parts =
                                                                  _singleDevices[
                                                                          i]
                                                                      .description
                                                                      .split(
                                                                          '2');
                                                              var prefix =
                                                                  parts[0]
                                                                      .trim();

                                                              return AnimationConfiguration
                                                                  .staggeredList(
                                                                position: i,
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        1000),
                                                                child:
                                                                    ScaleAnimation(
                                                                  scale: 1,
                                                                  child:
                                                                      FlipAnimation(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              width,
                                                                          height:
                                                                              height * 0.20,
                                                                          decoration: BoxDecoration(
                                                                              gradient: gradientColor,
                                                                              //color: Color(0xFFE0457B),
                                                                              borderRadius: BorderRadius.circular(17)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(1.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: height * 0.14,
                                                                                  width: width,
                                                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(12.0),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Validity',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  "$abc days",
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Container(
                                                                                              height: 30,
                                                                                              width: 1,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Limit',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  '${_singleDevices[i].devices.toString()} Device',
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Container(
                                                                                              height: 30,
                                                                                              width: 1,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Speed',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  '${_singleDevices[i].bandwidth} Mbps',
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: width * 0.9,
                                                                                        height: 1,
                                                                                        color: Colors.grey[300],
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 11),
                                                                                        child: Container(
                                                                                          width: width,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              // Container(
                                                                                              //   height: height * 0.05,
                                                                                              //   width: width*0.55,
                                                                                              //   //color: Colors.green,
                                                                                              //   child: //ReadMore
                                                                                              //   Text(
                                                                                              //     prefix,
                                                                                              //     overflow: TextOverflow.ellipsis,
                                                                                              //     maxLines: 3,
                                                                                              //     style: TextStyle(fontSize: 12),
                                                                                              //   ),
                                                                                              // ),

                                                                                              Container(
                                                                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                                                                decoration: BoxDecoration(
                                                                                                  gradient: LinearGradient(
                                                                                                    colors:
                                                                                                        // [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                                                                        _singleDevices[i].name == "BLUE"
                                                                                                            ? [
                                                                                                                Color(0xFF5787E3),
                                                                                                                Color(0xFF5787E3),
                                                                                                              ]
                                                                                                            : _singleDevices[i].name == "SILVER"
                                                                                                                ? [
                                                                                                                    Color(0xFF3D3C3A),
                                                                                                                    Color(0xFFC8C5BD),
                                                                                                                  ]
                                                                                                                : _singleDevices[i].name == "GOLD+"
                                                                                                                    ? [
                                                                                                                        Color(0xFFF4C73E),
                                                                                                                        Color(0xFFB99013),
                                                                                                                      ]
                                                                                                                    : _singleDevices[i].name == "GOLD"
                                                                                                                        ? [
                                                                                                                            Color(0xFFF4C73E),
                                                                                                                            Color(0xFFB99013),
                                                                                                                          ]
                                                                                                                        : _singleDevices[i].name == "CRYSTAL"
                                                                                                                            ? [
                                                                                                                                Color(0xFFF19164),
                                                                                                                                Color(0xFFF19164),
                                                                                                                              ]
                                                                                                                            : [
                                                                                                                                Color(0xFF1A1A1A),
                                                                                                                                Color(0xFF1A1A1A),
                                                                                                                              ],
                                                                                                    begin: const FractionalOffset(0.2, 0.0),
                                                                                                    end: const FractionalOffset(1.1, 0.0),
                                                                                                  ),

                                                                                                  // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                                                                  //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                                                                  //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),

                                                                                                  borderRadius: BorderRadius.all(
                                                                                                    Radius.circular(40.r),
                                                                                                  ),
                                                                                                ),
                                                                                                height: 21.h,
                                                                                                //width: 100.w,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    /*  Image.asset(
                                                                                  _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                                                      :
                                                                                  "assets/images/wifi_icon.png",
                                                                                  color: Colors.white,
                                                                                  height: 11.h,
                                                                                  // scale: 8,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5.w,
                                                                                ),*/
                                                                                                    Text(
                                                                                                      //_singleDevices[i].name,
                                                                                                      "${_singleDevices[i].name}",
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.white,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: 10.sp,
                                                                                                        //height: 1.8,
                                                                                                      ),
                                                                                                      textAlign: TextAlign.center,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 12.0, right: 12, top: 5),
                                                                                  child: InkWell(
                                                                                    onTap: () async {
                                                                                      /* Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PaymentMethod(
                                                                          price: '${_singleDevices[i].price.toStringAsFixed(2)}',
                                                                          id: _singleDevices[i].id,
                                                                          comingFrom: false,
                                                                        )));*/
                                                                                      EasyLoading.show(status: AppLocalizations.of(context)!.translate('please_wait')!);
                                                                                      await context.read<PayByProvider>().payByPackageOrder(context, _singleDevices[i].id);
                                                                                    },
                                                                                    child: Container(
                                                                                      height: height * 0.05,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text(
                                                                                            'AED ${_singleDevices[i].price.toStringAsFixed(2)}',
                                                                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                          Text(
                                                                                            'Buy Now',
                                                                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.03,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );

                                                              //   Card(
                                                              //   elevation: 0,
                                                              //   shape: RoundedRectangleBorder(
                                                              //     side: BorderSide(
                                                              //       color: Colors.grey.shade300,
                                                              //       width: 1.w,
                                                              //     ),
                                                              //     borderRadius: BorderRadius.circular(10),
                                                              //   ),
                                                              //   // decoration: BoxDecoration(
                                                              //   //   borderRadius: BorderRadius.circular(10),
                                                              //   //   border: Border.all()
                                                              //   // ),
                                                              //   child: Column(
                                                              //     crossAxisAlignment: CrossAxisAlignment.start,
                                                              //     children: [
                                                              //       Container(
                                                              //         // width: double.infinity,
                                                              //         // height: 120.h,
                                                              //         decoration: BoxDecoration(
                                                              //           color: Colors.pink.shade50,
                                                              //           borderRadius: BorderRadius.only(
                                                              //             topLeft: Radius.circular(10.r),
                                                              //             topRight: Radius.circular(10.r),
                                                              //           ),
                                                              //         ),
                                                              //         child: Padding(
                                                              //           padding: EdgeInsets.all(8.0.h),
                                                              //           child: Column(
                                                              //             crossAxisAlignment:
                                                              //             CrossAxisAlignment.start,
                                                              //             children: [
                                                              //               Row(
                                                              //                 children: [
                                                              //                   Container(
                                                              //                     padding: EdgeInsets.only(left: 10,right: 10),
                                                              //                     decoration: BoxDecoration(
                                                              //                       gradient: LinearGradient(
                                                              //                         colors:
                                                              //                         _singleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                                              //                             : _singleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                                              //                             : _singleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                              //                             : _singleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                              //                             :_singleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                                              //                             : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                              //                         begin: const FractionalOffset(
                                                              //                             0.2, 0.0),
                                                              //                         end: const FractionalOffset(
                                                              //                             1.1, 0.0),
                                                              //                       ),
                                                              //
                                                              //                       // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                              //                       //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                              //                       //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                                              //
                                                              //                       borderRadius: BorderRadius.all(
                                                              //                         Radius.circular(50.r),
                                                              //                       ),
                                                              //                     ),
                                                              //                     height: 30.h,
                                                              //                     //width: 100.w,
                                                              //                     child: Row(
                                                              //                       mainAxisAlignment: MainAxisAlignment.center,
                                                              //                       crossAxisAlignment: CrossAxisAlignment.center,
                                                              //                       children: [
                                                              //                         Image.asset(
                                                              //                           _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                              //                               : "assets/images/wifi_icon.png",
                                                              //                           color: Colors.white,
                                                              //                           height: 16.h,
                                                              //                           scale: 8,
                                                              //                         ),
                                                              //                         SizedBox(
                                                              //                           width: 5.w,
                                                              //                         ),
                                                              //                         Text(
                                                              //                           _singleDevices[i].name,
                                                              //                           style: TextStyle(
                                                              //                             color: Colors.white,
                                                              //                             fontWeight: FontWeight.w600,
                                                              //                             fontSize: 12.sp,
                                                              //                             height: 1.8,
                                                              //                           ),
                                                              //                           textAlign: TextAlign.center,
                                                              //                         ),
                                                              //                       ],
                                                              //                     ),
                                                              //                   ),
                                                              //                 ],
                                                              //               ),
                                                              //               SizedBox(
                                                              //                 height: 5,
                                                              //               ),
                                                              //               Container(
                                                              //                 height: height * 0.07,
                                                              //                 child: //ReadMore
                                                              //                 Text(
                                                              //                   prefix,
                                                              //                   overflow: TextOverflow.clip,
                                                              //                   maxLines: 3,
                                                              //                   style: TextStyle(fontSize: 12),
                                                              //                 ),
                                                              //               ),
                                                              //               SizedBox(
                                                              //                 height: 7.h,
                                                              //               ),
                                                              //               Text(
                                                              //                 "${_singleDevices[i].price.toString()} AED",
                                                              //                 style: TextStyle(
                                                              //                   fontSize: 28.sp,
                                                              //                   fontWeight: FontWeight.w700,
                                                              //                 ),
                                                              //               )
                                                              //             ],
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 20.h,
                                                              //       ),
                                                              //       Padding(
                                                              //         padding: EdgeInsets.only(
                                                              //           left: 10.w,
                                                              //           right: 10.w,
                                                              //         ),
                                                              //         child: Row(
                                                              //           mainAxisAlignment:
                                                              //           MainAxisAlignment.spaceBetween,
                                                              //           children: [
                                                              //             Text(
                                                              //               "Validity",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.grey.shade500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //             Text(
                                                              //               "$abc days",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.black,
                                                              //                 fontWeight: FontWeight.w500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 10.h,
                                                              //       ),
                                                              //       Padding(
                                                              //         padding: EdgeInsets.only(
                                                              //           left: 10.w,
                                                              //           right: 10.w,
                                                              //         ),
                                                              //         child: Row(
                                                              //           mainAxisAlignment:
                                                              //           MainAxisAlignment.spaceBetween,
                                                              //           children: [
                                                              //             Text(
                                                              //               "# of Devices",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.grey.shade500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //             Text(
                                                              //               "${_singleDevices[i].devices.toString()}",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.black,
                                                              //                 fontWeight: FontWeight.w500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 10.h,
                                                              //       ),
                                                              //       Padding(
                                                              //         padding: EdgeInsets.only(
                                                              //           left: 10.w,
                                                              //           right: 10.w,
                                                              //         ),
                                                              //         child: Row(
                                                              //           mainAxisAlignment:
                                                              //           MainAxisAlignment.spaceBetween,
                                                              //           children: [
                                                              //             Text(
                                                              //               "Speed upto",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.grey.shade500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //             Text(
                                                              //               "${_singleDevices[i].bandwidth.toString()}Mbps",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.black,
                                                              //                 fontWeight: FontWeight.w500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 10.h,
                                                              //       ),
                                                              //       Divider(),
                                                              //       Container(
                                                              //         height:45,
                                                              //         //color:Colors.red,
                                                              //         child: Center(
                                                              //           child: CustomButton(
                                                              //             height: 40.h,
                                                              //             width: 140.w,
                                                              //             onPressed: () {
                                                              //               Navigator.push(
                                                              //                   context,
                                                              //                   MaterialPageRoute(
                                                              //                       builder: (context) => PaymentMethod(
                                                              //                         price: _singleDevices[i].price.toString(),
                                                              //                         id: _singleDevices[i].id.toString(),
                                                              //                       )));
                                                              //             },
                                                              //             text: AppLocalizations.of(context)!
                                                              //                 .translate('buy_now')!,
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //
                                                              //     ],
                                                              //   ),
                                                              // );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text('$deviceAvailable'),
                                            _multipleDevices.isNotEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'multiple_device')!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Container(
                                                        child: AnimationLimiter(
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                _multipleDevices
                                                                    .length,
                                                            // addRepaintBoundaries: false,
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),

                                                            itemBuilder:
                                                                (context, i) {
                                                              double val =
                                                                  _multipleDevices[
                                                                              i]
                                                                          .validity /
                                                                      86400;
                                                              print(
                                                                  'this is value--$val');
                                                              String abc = val
                                                                  .toStringAsFixed(
                                                                      0);

                                                              var parts =
                                                                  _multipleDevices[
                                                                          i]
                                                                      .description
                                                                      .split(
                                                                          '2');
                                                              var prefix =
                                                                  parts[0]
                                                                      .trim();

                                                              return AnimationConfiguration
                                                                  .staggeredList(
                                                                position: i,
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        1000),
                                                                child:
                                                                    ScaleAnimation(
                                                                  scale: 1,
                                                                  child:
                                                                      FlipAnimation(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              width,
                                                                          height:
                                                                              height * 0.20,
                                                                          decoration: BoxDecoration(
                                                                              gradient: gradientColor,
                                                                              borderRadius: BorderRadius.circular(17)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(1.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: height * 0.14,
                                                                                  width: width,
                                                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(12.0),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Validity',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  "$abc days",
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Container(
                                                                                              height: 30,
                                                                                              width: 1,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Limit',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  '${_multipleDevices[i].devices.toString()} Devices',
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Container(
                                                                                              height: 30,
                                                                                              width: 1,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Speed',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  '${_multipleDevices[i].bandwidth} Mbps',
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: width * 0.9,
                                                                                        height: 1,
                                                                                        color: Colors.grey[300],
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 11),
                                                                                        child: Container(
                                                                                          width: width,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              // Container(
                                                                                              //   height: height * 0.05,
                                                                                              //   width: width*0.55,
                                                                                              //   //color: Colors.green,
                                                                                              //   child: //ReadMore
                                                                                              //   Text(
                                                                                              //     prefix,
                                                                                              //     overflow: TextOverflow.ellipsis,
                                                                                              //     maxLines: 3,
                                                                                              //     style: TextStyle(fontSize: 12),
                                                                                              //   ),
                                                                                              // ),

                                                                                              Container(
                                                                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                                                                decoration: BoxDecoration(
                                                                                                  gradient: LinearGradient(
                                                                                                    colors:
                                                                                                        // [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                                                                        _multipleDevices[i].name == "BLUE"
                                                                                                            ? [
                                                                                                                Color(0xFF5787E3),
                                                                                                                Color(0xFF5787E3),
                                                                                                              ]
                                                                                                            : _multipleDevices[i].name == "SILVER"
                                                                                                                ? [
                                                                                                                    Color(0xFF3D3C3A),
                                                                                                                    Color(0xFFC8C5BD),
                                                                                                                  ]
                                                                                                                : _multipleDevices[i].name == "GOLD+"
                                                                                                                    ? [
                                                                                                                        Color(0xFFF4C73E),
                                                                                                                        Color(0xFFB99013),
                                                                                                                      ]
                                                                                                                    : _multipleDevices[i].name == "GOLD"
                                                                                                                        ? [
                                                                                                                            Color(0xFFF4C73E),
                                                                                                                            Color(0xFFB99013),
                                                                                                                          ]
                                                                                                                        : _multipleDevices[i].name == "CRYSTAL"
                                                                                                                            ? [
                                                                                                                                Color(0xFFF19164),
                                                                                                                                Color(0xFFF19164),
                                                                                                                              ]
                                                                                                                            : [
                                                                                                                                Color(0xFF1A1A1A),
                                                                                                                                Color(0xFF1A1A1A),
                                                                                                                              ],
                                                                                                    begin: const FractionalOffset(0.2, 0.0),
                                                                                                    end: const FractionalOffset(1.1, 0.0),
                                                                                                  ),

                                                                                                  // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                                                                  //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                                                                  //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),

                                                                                                  borderRadius: BorderRadius.all(
                                                                                                    Radius.circular(40.r),
                                                                                                  ),
                                                                                                ),
                                                                                                height: 21.h,
                                                                                                //width: 100.w,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    /* Image.asset(
                                                                                  _multipleDevices[i].name == "GOLD" || _multipleDevices[i].name == "GOLD+" || _multipleDevices[i].name == "PLATINUM" || _multipleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                                                      :
                                                                                  "assets/images/wifi_icon.png",
                                                                                  color: Colors.white,
                                                                                  height: 11.h,
                                                                                  //scale: 8,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5.w,
                                                                                ),*/
                                                                                                    Text(
                                                                                                      //_singleDevices[i].name,
                                                                                                      "${_multipleDevices[i].name}",
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.white,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: 10.sp,
                                                                                                        //height: 1.8,
                                                                                                      ),
                                                                                                      textAlign: TextAlign.center,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                                                                                  child: InkWell(
                                                                                    onTap: () async {
                                                                                      /* Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PaymentMethod(
                                                                          price: "${_multipleDevices[i].price.toStringAsFixed(2)}",
                                                                          id: _multipleDevices[i].id,
                                                                          comingFrom: false,
                                                                        )));*/
                                                                                      EasyLoading.show(status: AppLocalizations.of(context)!.translate('please_wait')!);
                                                                                      await context.read<PayByProvider>().payByPackageOrder(context, _multipleDevices[i].id);
                                                                                    },
                                                                                    child: Container(
                                                                                      height: height * 0.05,
                                                                                      //color: Colors.green,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text(
                                                                                            'AED ${_multipleDevices[i].price.toStringAsFixed(2)}',
                                                                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                          Text(
                                                                                            'Buy Now',
                                                                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.03,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text('$deviceAvailable'),
                                          ]
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                                                  SizedBox(
                                            height: 10.h,
                                          ),

                                          if (_value == 'single') ...[
                                            _singleDevices.isNotEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'single_device')!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Container(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              _singleDevices
                                                                  .length,
                                                          // addRepaintBoundaries: false,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),

                                                          itemBuilder:
                                                              (context, i) {
                                                            double val =
                                                                _singleDevices[
                                                                            i]
                                                                        .validity /
                                                                    86400;
                                                            print(
                                                                'this is value--$val');
                                                            String abc = val
                                                                .toStringAsFixed(
                                                                    0);

                                                            var parts =
                                                                _singleDevices[
                                                                        i]
                                                                    .description
                                                                    .split('2');
                                                            var prefix =
                                                                parts[0].trim();

                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  width: width,
                                                                  height:
                                                                      height *
                                                                          0.20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          gradient:
                                                                              gradientColor,
                                                                          //color: Color(0xFFE0457B),
                                                                          borderRadius:
                                                                              BorderRadius.circular(17)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            1.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              height * 0.14,
                                                                          width:
                                                                              width,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(17)),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(12.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Validity',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          "$abc days",
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 30,
                                                                                      width: 1,
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Limit',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          '${_singleDevices[i].devices.toString()} Device',
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 30,
                                                                                      width: 1,
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Speed',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          '${_singleDevices[i].bandwidth} Mbps',
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: width * 0.9,
                                                                                height: 1,
                                                                                color: Colors.grey[300],
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 11),
                                                                                child: Container(
                                                                                  width: width,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      // Container(
                                                                                      //   height: height * 0.05,
                                                                                      //   width: width*0.55,
                                                                                      //   //color: Colors.green,
                                                                                      //   child: //ReadMore
                                                                                      //   Text(
                                                                                      //     prefix,
                                                                                      //     overflow: TextOverflow.ellipsis,
                                                                                      //     maxLines: 3,
                                                                                      //     style: TextStyle(fontSize: 12),
                                                                                      //   ),
                                                                                      // ),

                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, right: 10),
                                                                                        decoration: BoxDecoration(
                                                                                          gradient: LinearGradient(
                                                                                            colors:
                                                                                                // [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                                                                _singleDevices[i].name == "BLUE"
                                                                                                    ? [
                                                                                                        Color(0xFF5787E3),
                                                                                                        Color(0xFF5787E3),
                                                                                                      ]
                                                                                                    : _singleDevices[i].name == "SILVER"
                                                                                                        ? [
                                                                                                            Color(0xFF3D3C3A),
                                                                                                            Color(0xFFC8C5BD),
                                                                                                          ]
                                                                                                        : _singleDevices[i].name == "GOLD+"
                                                                                                            ? [
                                                                                                                Color(0xFFF4C73E),
                                                                                                                Color(0xFFB99013),
                                                                                                              ]
                                                                                                            : _singleDevices[i].name == "GOLD"
                                                                                                                ? [
                                                                                                                    Color(0xFFF4C73E),
                                                                                                                    Color(0xFFB99013),
                                                                                                                  ]
                                                                                                                : _singleDevices[i].name == "CRYSTAL"
                                                                                                                    ? [
                                                                                                                        Color(0xFFF19164),
                                                                                                                        Color(0xFFF19164),
                                                                                                                      ]
                                                                                                                    : [
                                                                                                                        Color(0xFF1A1A1A),
                                                                                                                        Color(0xFF1A1A1A),
                                                                                                                      ],
                                                                                            begin: const FractionalOffset(0.2, 0.0),
                                                                                            end: const FractionalOffset(1.1, 0.0),
                                                                                          ),

                                                                                          // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                                                          //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                                                          //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),

                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(40.r),
                                                                                          ),
                                                                                        ),
                                                                                        height: 21.h,
                                                                                        //width: 100.w,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            /* Image.asset(
                                                                        _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                                            :
                                                                        "assets/images/wifi_icon.png",
                                                                        color: Colors.white,
                                                                        height: 11.h,
                                                                        // scale: 8,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5.w,
                                                                      ),*/
                                                                                            Text(
                                                                                              //_singleDevices[i].name,
                                                                                              "${_singleDevices[i].name}",
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize: 10.sp,
                                                                                                //height: 1.8,
                                                                                              ),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 12.0,
                                                                              right: 12,
                                                                              top: 5),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              /* Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => PaymentMethod(
                                                                  price: '${_singleDevices[i].price.toStringAsFixed(2)}',
                                                                  id: _singleDevices[i].id,
                                                                  comingFrom: false,
                                                                )));*/
                                                                              EasyLoading.show(status: AppLocalizations.of(context)!.translate('please_wait')!);
                                                                              await context.read<PayByProvider>().payByPackageOrder(context, _singleDevices[i].id);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: height * 0.05,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    'AED ${_singleDevices[i].price.toStringAsFixed(2)}',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    'Activate Now',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      height *
                                                                          0.03,
                                                                )
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text('$deviceAvailable'),
                                          ] else if (_value == 'multiple') ...[
                                            _multipleDevices.isNotEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'multiple_device')!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Container(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              _multipleDevices
                                                                  .length,
                                                          // addRepaintBoundaries: false,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),

                                                          itemBuilder:
                                                              (context, i) {
                                                            double val =
                                                                _multipleDevices[
                                                                            i]
                                                                        .validity /
                                                                    86400;
                                                            print(
                                                                'this is value--$val');
                                                            String abc = val
                                                                .toStringAsFixed(
                                                                    0);

                                                            var parts =
                                                                _multipleDevices[
                                                                        i]
                                                                    .description
                                                                    .split('2');
                                                            var prefix =
                                                                parts[0].trim();

                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  width: width,
                                                                  height:
                                                                      height *
                                                                          0.20,
                                                                  decoration: BoxDecoration(
                                                                      gradient:
                                                                          gradientColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              17)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            1.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              height * 0.14,
                                                                          width:
                                                                              width,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(17)),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(12.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Validity',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          "$abc days",
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 30,
                                                                                      width: 1,
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Limit',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          '${_multipleDevices[i].devices.toString()} Devices',
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 30,
                                                                                      width: 1,
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Speed',
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                        ),
                                                                                        Text(
                                                                                          '${_multipleDevices[i].bandwidth} Mbps',
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: width * 0.9,
                                                                                height: 1,
                                                                                color: Colors.grey[300],
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 11),
                                                                                child: Container(
                                                                                  width: width,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      // Container(
                                                                                      //   height: height * 0.05,
                                                                                      //   width: width*0.55,
                                                                                      //   //color: Colors.green,
                                                                                      //   child: //ReadMore
                                                                                      //   Text(
                                                                                      //     prefix,
                                                                                      //     overflow: TextOverflow.ellipsis,
                                                                                      //     maxLines: 3,
                                                                                      //     style: TextStyle(fontSize: 12),
                                                                                      //   ),
                                                                                      // ),

                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, right: 10),
                                                                                        decoration: BoxDecoration(
                                                                                          gradient: LinearGradient(
                                                                                            colors:
                                                                                                // [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                                                                _multipleDevices[i].name == "BLUE"
                                                                                                    ? [
                                                                                                        Color(0xFF5787E3),
                                                                                                        Color(0xFF5787E3),
                                                                                                      ]
                                                                                                    : _multipleDevices[i].name == "SILVER"
                                                                                                        ? [
                                                                                                            Color(0xFF3D3C3A),
                                                                                                            Color(0xFFC8C5BD),
                                                                                                          ]
                                                                                                        : _multipleDevices[i].name == "GOLD+"
                                                                                                            ? [
                                                                                                                Color(0xFFF4C73E),
                                                                                                                Color(0xFFB99013),
                                                                                                              ]
                                                                                                            : _multipleDevices[i].name == "GOLD"
                                                                                                                ? [
                                                                                                                    Color(0xFFF4C73E),
                                                                                                                    Color(0xFFB99013),
                                                                                                                  ]
                                                                                                                : _multipleDevices[i].name == "CRYSTAL"
                                                                                                                    ? [
                                                                                                                        Color(0xFFF19164),
                                                                                                                        Color(0xFFF19164),
                                                                                                                      ]
                                                                                                                    : [
                                                                                                                        Color(0xFF1A1A1A),
                                                                                                                        Color(0xFF1A1A1A),
                                                                                                                      ],
                                                                                            begin: const FractionalOffset(0.2, 0.0),
                                                                                            end: const FractionalOffset(1.1, 0.0),
                                                                                          ),

                                                                                          // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                                                          //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                                                          //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),

                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(40.r),
                                                                                          ),
                                                                                        ),
                                                                                        height: 21.h,
                                                                                        //width: 100.w,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            /*Image.asset(
                                                                        _multipleDevices[i].name == "GOLD" || _multipleDevices[i].name == "GOLD+" || _multipleDevices[i].name == "PLATINUM" || _multipleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                                            :
                                                                        "assets/images/wifi_icon.png",
                                                                        color: Colors.white,
                                                                        height: 11.h,
                                                                        //scale: 8,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5.w,
                                                                      ),*/
                                                                                            Text(
                                                                                              //_singleDevices[i].name,
                                                                                              "${_multipleDevices[i].name}",
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize: 10.sp,
                                                                                                //height: 1.8,
                                                                                              ),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 12.0,
                                                                              right: 12),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              /* Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => PaymentMethod(
                                                                  price: "${_multipleDevices[i].price.toStringAsFixed(2)}",
                                                                  id: _multipleDevices[i].id,
                                                                  comingFrom: false,
                                                                )));*/
                                                                              EasyLoading.show(status: AppLocalizations.of(context)!.translate('please_wait')!);
                                                                              await context.read<PayByProvider>().payByPackageOrder(context, _multipleDevices[i].id);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: height * 0.05,
                                                                              //color: Colors.green,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    'AED ${_multipleDevices[i].price.toStringAsFixed(2)}',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    'Activate Now',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      height *
                                                                          0.03,
                                                                )
                                                              ],
                                                            );

                                                            //   Card(
                                                            //   elevation: 0,
                                                            //   shape: RoundedRectangleBorder(
                                                            //     side: BorderSide(
                                                            //       color: Colors.grey.shade300,
                                                            //       width: 1.w,
                                                            //     ),
                                                            //     borderRadius: BorderRadius.circular(10),
                                                            //   ),
                                                            //   // decoration: BoxDecoration(
                                                            //   //   borderRadius: BorderRadius.circular(10),
                                                            //   //   border: Border.all()
                                                            //   // ),
                                                            //   child: Column(
                                                            //     crossAxisAlignment: CrossAxisAlignment.start,
                                                            //     children: [
                                                            //       Container(
                                                            //         // width: double.infinity,
                                                            //         // height: 120.h,
                                                            //         decoration: BoxDecoration(
                                                            //           color: Colors.pink.shade50,
                                                            //           borderRadius: BorderRadius.only(
                                                            //             topLeft: Radius.circular(10.r),
                                                            //             topRight: Radius.circular(10.r),
                                                            //           ),
                                                            //         ),
                                                            //         child: Padding(
                                                            //           padding: EdgeInsets.all(8.0.h),
                                                            //           child: Column(
                                                            //             crossAxisAlignment:
                                                            //             CrossAxisAlignment.start,
                                                            //             children: [
                                                            //               Row(
                                                            //                 children: [
                                                            //                   Container(
                                                            //                     padding: EdgeInsets.only(left: 10,right: 10),
                                                            //                     decoration: BoxDecoration(
                                                            //                       gradient: LinearGradient(
                                                            //                         colors:
                                                            //                         _singleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                                            //                             : _singleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                                            //                             : _singleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                            //                             : _singleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                            //                             :_singleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                                            //                             : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                            //                         begin: const FractionalOffset(
                                                            //                             0.2, 0.0),
                                                            //                         end: const FractionalOffset(
                                                            //                             1.1, 0.0),
                                                            //                       ),
                                                            //
                                                            //                       // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                            //                       //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                            //                       //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                                            //
                                                            //                       borderRadius: BorderRadius.all(
                                                            //                         Radius.circular(50.r),
                                                            //                       ),
                                                            //                     ),
                                                            //                     height: 30.h,
                                                            //                     //width: 100.w,
                                                            //                     child: Row(
                                                            //                       mainAxisAlignment: MainAxisAlignment.center,
                                                            //                       crossAxisAlignment: CrossAxisAlignment.center,
                                                            //                       children: [
                                                            //                         Image.asset(
                                                            //                           _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                            //                               : "assets/images/wifi_icon.png",
                                                            //                           color: Colors.white,
                                                            //                           height: 16.h,
                                                            //                           scale: 8,
                                                            //                         ),
                                                            //                         SizedBox(
                                                            //                           width: 5.w,
                                                            //                         ),
                                                            //                         Text(
                                                            //                           _singleDevices[i].name,
                                                            //                           style: TextStyle(
                                                            //                             color: Colors.white,
                                                            //                             fontWeight: FontWeight.w600,
                                                            //                             fontSize: 12.sp,
                                                            //                             height: 1.8,
                                                            //                           ),
                                                            //                           textAlign: TextAlign.center,
                                                            //                         ),
                                                            //                       ],
                                                            //                     ),
                                                            //                   ),
                                                            //                 ],
                                                            //               ),
                                                            //               SizedBox(
                                                            //                 height: 5,
                                                            //               ),
                                                            //               Container(
                                                            //                 height: height * 0.07,
                                                            //                 child: //ReadMore
                                                            //                 Text(
                                                            //                   prefix,
                                                            //                   overflow: TextOverflow.clip,
                                                            //                   maxLines: 3,
                                                            //                   style: TextStyle(fontSize: 12),
                                                            //                 ),
                                                            //               ),
                                                            //               SizedBox(
                                                            //                 height: 7.h,
                                                            //               ),
                                                            //               Text(
                                                            //                 "${_singleDevices[i].price.toString()} AED",
                                                            //                 style: TextStyle(
                                                            //                   fontSize: 28.sp,
                                                            //                   fontWeight: FontWeight.w700,
                                                            //                 ),
                                                            //               )
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 20.h,
                                                            //       ),
                                                            //       Padding(
                                                            //         padding: EdgeInsets.only(
                                                            //           left: 10.w,
                                                            //           right: 10.w,
                                                            //         ),
                                                            //         child: Row(
                                                            //           mainAxisAlignment:
                                                            //           MainAxisAlignment.spaceBetween,
                                                            //           children: [
                                                            //             Text(
                                                            //               "Validity",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.grey.shade500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //             Text(
                                                            //               "$abc days",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.black,
                                                            //                 fontWeight: FontWeight.w500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //           ],
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 10.h,
                                                            //       ),
                                                            //       Padding(
                                                            //         padding: EdgeInsets.only(
                                                            //           left: 10.w,
                                                            //           right: 10.w,
                                                            //         ),
                                                            //         child: Row(
                                                            //           mainAxisAlignment:
                                                            //           MainAxisAlignment.spaceBetween,
                                                            //           children: [
                                                            //             Text(
                                                            //               "# of Devices",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.grey.shade500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //             Text(
                                                            //               "${_singleDevices[i].devices.toString()}",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.black,
                                                            //                 fontWeight: FontWeight.w500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //           ],
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 10.h,
                                                            //       ),
                                                            //       Padding(
                                                            //         padding: EdgeInsets.only(
                                                            //           left: 10.w,
                                                            //           right: 10.w,
                                                            //         ),
                                                            //         child: Row(
                                                            //           mainAxisAlignment:
                                                            //           MainAxisAlignment.spaceBetween,
                                                            //           children: [
                                                            //             Text(
                                                            //               "Speed upto",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.grey.shade500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //             Text(
                                                            //               "${_singleDevices[i].bandwidth.toString()}Mbps",
                                                            //               style: TextStyle(
                                                            //                 color: Colors.black,
                                                            //                 fontWeight: FontWeight.w500,
                                                            //                 fontSize: 12.sp,
                                                            //               ),
                                                            //             ),
                                                            //           ],
                                                            //         ),
                                                            //       ),
                                                            //       SizedBox(
                                                            //         height: 10.h,
                                                            //       ),
                                                            //       Divider(),
                                                            //       Container(
                                                            //         height:45,
                                                            //         //color:Colors.red,
                                                            //         child: Center(
                                                            //           child: CustomButton(
                                                            //             height: 40.h,
                                                            //             width: 140.w,
                                                            //             onPressed: () {
                                                            //               Navigator.push(
                                                            //                   context,
                                                            //                   MaterialPageRoute(
                                                            //                       builder: (context) => PaymentMethod(
                                                            //                         price: _singleDevices[i].price.toString(),
                                                            //                         id: _singleDevices[i].id.toString(),
                                                            //                       )));
                                                            //             },
                                                            //             text: AppLocalizations.of(context)!
                                                            //                 .translate('buy_now')!,
                                                            //           ),
                                                            //         ),
                                                            //       ),
                                                            //
                                                            //     ],
                                                            //   ),
                                                            // );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text('$deviceAvailable'),
                                          ] else ...[
                                            _singleDevices.isNotEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'single_device')!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Container(
                                                        child: AnimationLimiter(
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                _singleDevices
                                                                    .length,
                                                            // addRepaintBoundaries: false,
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),

                                                            itemBuilder:
                                                                (context, i) {
                                                              double val =
                                                                  _singleDevices[
                                                                              i]
                                                                          .validity /
                                                                      86400;
                                                              print(
                                                                  'this is value--$val');
                                                              String abc = val
                                                                  .toStringAsFixed(
                                                                      0);

                                                              var parts =
                                                                  _singleDevices[
                                                                          i]
                                                                      .description
                                                                      .split(
                                                                          '2');
                                                              var prefix =
                                                                  parts[0]
                                                                      .trim();

                                                              return AnimationConfiguration
                                                                  .staggeredList(
                                                                position: i,
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        1000),
                                                                child:
                                                                    ScaleAnimation(
                                                                  scale: 1,
                                                                  child:
                                                                      FlipAnimation(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              width,
                                                                          height:
                                                                              height * 0.20,
                                                                          decoration: BoxDecoration(
                                                                              gradient: gradientColor,
                                                                              //color: Color(0xFFE0457B),
                                                                              borderRadius: BorderRadius.circular(17)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(1.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: height * 0.14,
                                                                                  width: width,
                                                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(12.0),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Validity',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  "$abc days",
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Container(
                                                                                              height: 30,
                                                                                              width: 1,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Limit',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  '${_singleDevices[i].devices.toString()} Device',
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Container(
                                                                                              height: 30,
                                                                                              width: 1,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Speed',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  '${_singleDevices[i].bandwidth} Mbps',
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: width * 0.9,
                                                                                        height: 1,
                                                                                        color: Colors.grey[300],
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 11),
                                                                                        child: Container(
                                                                                          width: width,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              // Container(
                                                                                              //   height: height * 0.05,
                                                                                              //   width: width*0.55,
                                                                                              //   //color: Colors.green,
                                                                                              //   child: //ReadMore
                                                                                              //   Text(
                                                                                              //     prefix,
                                                                                              //     overflow: TextOverflow.ellipsis,
                                                                                              //     maxLines: 3,
                                                                                              //     style: TextStyle(fontSize: 12),
                                                                                              //   ),
                                                                                              // ),

                                                                                              Container(
                                                                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                                                                decoration: BoxDecoration(
                                                                                                  gradient: LinearGradient(
                                                                                                    colors:
                                                                                                        // [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                                                                        _singleDevices[i].name == "BLUE"
                                                                                                            ? [
                                                                                                                Color(0xFF5787E3),
                                                                                                                Color(0xFF5787E3),
                                                                                                              ]
                                                                                                            : _singleDevices[i].name == "SILVER"
                                                                                                                ? [
                                                                                                                    Color(0xFF3D3C3A),
                                                                                                                    Color(0xFFC8C5BD),
                                                                                                                  ]
                                                                                                                : _singleDevices[i].name == "GOLD+"
                                                                                                                    ? [
                                                                                                                        Color(0xFFF4C73E),
                                                                                                                        Color(0xFFB99013),
                                                                                                                      ]
                                                                                                                    : _singleDevices[i].name == "GOLD"
                                                                                                                        ? [
                                                                                                                            Color(0xFFF4C73E),
                                                                                                                            Color(0xFFB99013),
                                                                                                                          ]
                                                                                                                        : _singleDevices[i].name == "CRYSTAL"
                                                                                                                            ? [
                                                                                                                                Color(0xFFF19164),
                                                                                                                                Color(0xFFF19164),
                                                                                                                              ]
                                                                                                                            : [
                                                                                                                                Color(0xFF1A1A1A),
                                                                                                                                Color(0xFF1A1A1A),
                                                                                                                              ],
                                                                                                    begin: const FractionalOffset(0.2, 0.0),
                                                                                                    end: const FractionalOffset(1.1, 0.0),
                                                                                                  ),

                                                                                                  // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                                                                  //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                                                                  //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),

                                                                                                  borderRadius: BorderRadius.all(
                                                                                                    Radius.circular(40.r),
                                                                                                  ),
                                                                                                ),
                                                                                                height: 21.h,
                                                                                                //width: 100.w,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    /*  Image.asset(
                                                                                  _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                                                      :
                                                                                  "assets/images/wifi_icon.png",
                                                                                  color: Colors.white,
                                                                                  height: 11.h,
                                                                                  // scale: 8,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5.w,
                                                                                ),*/
                                                                                                    Text(
                                                                                                      //_singleDevices[i].name,
                                                                                                      "${_singleDevices[i].name}",
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.white,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: 10.sp,
                                                                                                        //height: 1.8,
                                                                                                      ),
                                                                                                      textAlign: TextAlign.center,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 12.0, right: 12, top: 5),
                                                                                  child: InkWell(
                                                                                    onTap: () async {
                                                                                      /* Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PaymentMethod(
                                                                          price: '${_singleDevices[i].price.toStringAsFixed(2)}',
                                                                          id: _singleDevices[i].id,
                                                                          comingFrom: false,
                                                                        )));*/
                                                                                      EasyLoading.show(status: AppLocalizations.of(context)!.translate('please_wait')!);
                                                                                      await context.read<PayByProvider>().payByPackageOrder(context, _singleDevices[i].id);
                                                                                    },
                                                                                    child: Container(
                                                                                      height: height * 0.05,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text(
                                                                                            'AED ${_singleDevices[i].price.toStringAsFixed(2)}',
                                                                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                          Text(
                                                                                            ' Activate Now',
                                                                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.03,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );

                                                              //   Card(
                                                              //   elevation: 0,
                                                              //   shape: RoundedRectangleBorder(
                                                              //     side: BorderSide(
                                                              //       color: Colors.grey.shade300,
                                                              //       width: 1.w,
                                                              //     ),
                                                              //     borderRadius: BorderRadius.circular(10),
                                                              //   ),
                                                              //   // decoration: BoxDecoration(
                                                              //   //   borderRadius: BorderRadius.circular(10),
                                                              //   //   border: Border.all()
                                                              //   // ),
                                                              //   child: Column(
                                                              //     crossAxisAlignment: CrossAxisAlignment.start,
                                                              //     children: [
                                                              //       Container(
                                                              //         // width: double.infinity,
                                                              //         // height: 120.h,
                                                              //         decoration: BoxDecoration(
                                                              //           color: Colors.pink.shade50,
                                                              //           borderRadius: BorderRadius.only(
                                                              //             topLeft: Radius.circular(10.r),
                                                              //             topRight: Radius.circular(10.r),
                                                              //           ),
                                                              //         ),
                                                              //         child: Padding(
                                                              //           padding: EdgeInsets.all(8.0.h),
                                                              //           child: Column(
                                                              //             crossAxisAlignment:
                                                              //             CrossAxisAlignment.start,
                                                              //             children: [
                                                              //               Row(
                                                              //                 children: [
                                                              //                   Container(
                                                              //                     padding: EdgeInsets.only(left: 10,right: 10),
                                                              //                     decoration: BoxDecoration(
                                                              //                       gradient: LinearGradient(
                                                              //                         colors:
                                                              //                         _singleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                                              //                             : _singleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                                              //                             : _singleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                              //                             : _singleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                              //                             :_singleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                                              //                             : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                              //                         begin: const FractionalOffset(
                                                              //                             0.2, 0.0),
                                                              //                         end: const FractionalOffset(
                                                              //                             1.1, 0.0),
                                                              //                       ),
                                                              //
                                                              //                       // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                              //                       //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                              //                       //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                                              //
                                                              //                       borderRadius: BorderRadius.all(
                                                              //                         Radius.circular(50.r),
                                                              //                       ),
                                                              //                     ),
                                                              //                     height: 30.h,
                                                              //                     //width: 100.w,
                                                              //                     child: Row(
                                                              //                       mainAxisAlignment: MainAxisAlignment.center,
                                                              //                       crossAxisAlignment: CrossAxisAlignment.center,
                                                              //                       children: [
                                                              //                         Image.asset(
                                                              //                           _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                              //                               : "assets/images/wifi_icon.png",
                                                              //                           color: Colors.white,
                                                              //                           height: 16.h,
                                                              //                           scale: 8,
                                                              //                         ),
                                                              //                         SizedBox(
                                                              //                           width: 5.w,
                                                              //                         ),
                                                              //                         Text(
                                                              //                           _singleDevices[i].name,
                                                              //                           style: TextStyle(
                                                              //                             color: Colors.white,
                                                              //                             fontWeight: FontWeight.w600,
                                                              //                             fontSize: 12.sp,
                                                              //                             height: 1.8,
                                                              //                           ),
                                                              //                           textAlign: TextAlign.center,
                                                              //                         ),
                                                              //                       ],
                                                              //                     ),
                                                              //                   ),
                                                              //                 ],
                                                              //               ),
                                                              //               SizedBox(
                                                              //                 height: 5,
                                                              //               ),
                                                              //               Container(
                                                              //                 height: height * 0.07,
                                                              //                 child: //ReadMore
                                                              //                 Text(
                                                              //                   prefix,
                                                              //                   overflow: TextOverflow.clip,
                                                              //                   maxLines: 3,
                                                              //                   style: TextStyle(fontSize: 12),
                                                              //                 ),
                                                              //               ),
                                                              //               SizedBox(
                                                              //                 height: 7.h,
                                                              //               ),
                                                              //               Text(
                                                              //                 "${_singleDevices[i].price.toString()} AED",
                                                              //                 style: TextStyle(
                                                              //                   fontSize: 28.sp,
                                                              //                   fontWeight: FontWeight.w700,
                                                              //                 ),
                                                              //               )
                                                              //             ],
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 20.h,
                                                              //       ),
                                                              //       Padding(
                                                              //         padding: EdgeInsets.only(
                                                              //           left: 10.w,
                                                              //           right: 10.w,
                                                              //         ),
                                                              //         child: Row(
                                                              //           mainAxisAlignment:
                                                              //           MainAxisAlignment.spaceBetween,
                                                              //           children: [
                                                              //             Text(
                                                              //               "Validity",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.grey.shade500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //             Text(
                                                              //               "$abc days",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.black,
                                                              //                 fontWeight: FontWeight.w500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 10.h,
                                                              //       ),
                                                              //       Padding(
                                                              //         padding: EdgeInsets.only(
                                                              //           left: 10.w,
                                                              //           right: 10.w,
                                                              //         ),
                                                              //         child: Row(
                                                              //           mainAxisAlignment:
                                                              //           MainAxisAlignment.spaceBetween,
                                                              //           children: [
                                                              //             Text(
                                                              //               "# of Devices",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.grey.shade500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //             Text(
                                                              //               "${_singleDevices[i].devices.toString()}",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.black,
                                                              //                 fontWeight: FontWeight.w500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 10.h,
                                                              //       ),
                                                              //       Padding(
                                                              //         padding: EdgeInsets.only(
                                                              //           left: 10.w,
                                                              //           right: 10.w,
                                                              //         ),
                                                              //         child: Row(
                                                              //           mainAxisAlignment:
                                                              //           MainAxisAlignment.spaceBetween,
                                                              //           children: [
                                                              //             Text(
                                                              //               "Speed upto",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.grey.shade500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //             Text(
                                                              //               "${_singleDevices[i].bandwidth.toString()}Mbps",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.black,
                                                              //                 fontWeight: FontWeight.w500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 10.h,
                                                              //       ),
                                                              //       Divider(),
                                                              //       Container(
                                                              //         height:45,
                                                              //         //color:Colors.red,
                                                              //         child: Center(
                                                              //           child: CustomButton(
                                                              //             height: 40.h,
                                                              //             width: 140.w,
                                                              //             onPressed: () {
                                                              //               Navigator.push(
                                                              //                   context,
                                                              //                   MaterialPageRoute(
                                                              //                       builder: (context) => PaymentMethod(
                                                              //                         price: _singleDevices[i].price.toString(),
                                                              //                         id: _singleDevices[i].id.toString(),
                                                              //                       )));
                                                              //             },
                                                              //             text: AppLocalizations.of(context)!
                                                              //                 .translate('buy_now')!,
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //
                                                              //     ],
                                                              //   ),
                                                              // );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text('$deviceAvailable'),
                                            _multipleDevices.isNotEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translate(
                                                                'multiple_device')!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Container(
                                                        child: AnimationLimiter(
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                _multipleDevices
                                                                    .length,
                                                            // addRepaintBoundaries: false,
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),

                                                            itemBuilder:
                                                                (context, i) {
                                                              double val =
                                                                  _multipleDevices[
                                                                              i]
                                                                          .validity /
                                                                      86400;
                                                              print(
                                                                  'this is value--$val');
                                                              String abc = val
                                                                  .toStringAsFixed(
                                                                      0);

                                                              var parts =
                                                                  _multipleDevices[
                                                                          i]
                                                                      .description
                                                                      .split(
                                                                          '2');
                                                              var prefix =
                                                                  parts[0]
                                                                      .trim();

                                                              return AnimationConfiguration
                                                                  .staggeredList(
                                                                position: i,
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        1000),
                                                                child:
                                                                    ScaleAnimation(
                                                                  scale: 1,
                                                                  child:
                                                                      FlipAnimation(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              width,
                                                                          height:
                                                                              height * 0.20,
                                                                          decoration: BoxDecoration(
                                                                              gradient: gradientColor,
                                                                              borderRadius: BorderRadius.circular(17)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(1.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: height * 0.14,
                                                                                  width: width,
                                                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(12.0),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Validity',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  "$abc days",
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Container(
                                                                                              height: 30,
                                                                                              width: 1,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Limit',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  '${_multipleDevices[i].devices.toString()} Devices',
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Container(
                                                                                              height: 30,
                                                                                              width: 1,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Speed',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                                                                ),
                                                                                                Text(
                                                                                                  '${_multipleDevices[i].bandwidth} Mbps',
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: width * 0.9,
                                                                                        height: 1,
                                                                                        color: Colors.grey[300],
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 11),
                                                                                        child: Container(
                                                                                          width: width,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              // Container(
                                                                                              //   height: height * 0.05,
                                                                                              //   width: width*0.55,
                                                                                              //   //color: Colors.green,
                                                                                              //   child: //ReadMore
                                                                                              //   Text(
                                                                                              //     prefix,
                                                                                              //     overflow: TextOverflow.ellipsis,
                                                                                              //     maxLines: 3,
                                                                                              //     style: TextStyle(fontSize: 12),
                                                                                              //   ),
                                                                                              // ),

                                                                                              Container(
                                                                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                                                                decoration: BoxDecoration(
                                                                                                  gradient: LinearGradient(
                                                                                                    colors:
                                                                                                        // [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                                                                        _multipleDevices[i].name == "BLUE"
                                                                                                            ? [
                                                                                                                Color(0xFF5787E3),
                                                                                                                Color(0xFF5787E3),
                                                                                                              ]
                                                                                                            : _multipleDevices[i].name == "SILVER"
                                                                                                                ? [
                                                                                                                    Color(0xFF3D3C3A),
                                                                                                                    Color(0xFFC8C5BD),
                                                                                                                  ]
                                                                                                                : _multipleDevices[i].name == "GOLD+"
                                                                                                                    ? [
                                                                                                                        Color(0xFFF4C73E),
                                                                                                                        Color(0xFFB99013),
                                                                                                                      ]
                                                                                                                    : _multipleDevices[i].name == "GOLD"
                                                                                                                        ? [
                                                                                                                            Color(0xFFF4C73E),
                                                                                                                            Color(0xFFB99013),
                                                                                                                          ]
                                                                                                                        : _multipleDevices[i].name == "CRYSTAL"
                                                                                                                            ? [
                                                                                                                                Color(0xFFF19164),
                                                                                                                                Color(0xFFF19164),
                                                                                                                              ]
                                                                                                                            : [
                                                                                                                                Color(0xFF1A1A1A),
                                                                                                                                Color(0xFF1A1A1A),
                                                                                                                              ],
                                                                                                    begin: const FractionalOffset(0.2, 0.0),
                                                                                                    end: const FractionalOffset(1.1, 0.0),
                                                                                                  ),

                                                                                                  // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                                                                  //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                                                                  //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),

                                                                                                  borderRadius: BorderRadius.all(
                                                                                                    Radius.circular(40.r),
                                                                                                  ),
                                                                                                ),
                                                                                                height: 21.h,
                                                                                                //width: 100.w,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    /* Image.asset(
                                                                                  _multipleDevices[i].name == "GOLD" || _multipleDevices[i].name == "GOLD+" || _multipleDevices[i].name == "PLATINUM" || _multipleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                                                      :
                                                                                  "assets/images/wifi_icon.png",
                                                                                  color: Colors.white,
                                                                                  height: 11.h,
                                                                                  //scale: 8,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5.w,
                                                                                ),*/
                                                                                                    Text(
                                                                                                      //_singleDevices[i].name,
                                                                                                      "${_multipleDevices[i].name}",
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.white,
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: 10.sp,
                                                                                                        //height: 1.8,
                                                                                                      ),
                                                                                                      textAlign: TextAlign.center,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                                                                                  child: InkWell(
                                                                                    onTap: () async {
                                                                                      /* Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PaymentMethod(
                                                                          price: "${_multipleDevices[i].price.toStringAsFixed(2)}",
                                                                          id: _multipleDevices[i].id,
                                                                          comingFrom: false,
                                                                        )));*/
                                                                                      EasyLoading.show(status: AppLocalizations.of(context)!.translate('please_wait')!);
                                                                                      await context.read<PayByProvider>().payByPackageOrder(context, _multipleDevices[i].id);
                                                                                    },
                                                                                    child: Container(
                                                                                      height: height * 0.05,
                                                                                      //color: Colors.green,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text(
                                                                                            'AED ${_multipleDevices[i].price.toStringAsFixed(2)}',
                                                                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                          Text(
                                                                                            'Buy Now',
                                                                                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.03,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );

                                                              //   Card(
                                                              //   elevation: 0,
                                                              //   shape: RoundedRectangleBorder(
                                                              //     side: BorderSide(
                                                              //       color: Colors.grey.shade300,
                                                              //       width: 1.w,
                                                              //     ),
                                                              //     borderRadius: BorderRadius.circular(10),
                                                              //   ),
                                                              //   // decoration: BoxDecoration(
                                                              //   //   borderRadius: BorderRadius.circular(10),
                                                              //   //   border: Border.all()
                                                              //   // ),
                                                              //   child: Column(
                                                              //     crossAxisAlignment: CrossAxisAlignment.start,
                                                              //     children: [
                                                              //       Container(
                                                              //         // width: double.infinity,
                                                              //         // height: 120.h,
                                                              //         decoration: BoxDecoration(
                                                              //           color: Colors.pink.shade50,
                                                              //           borderRadius: BorderRadius.only(
                                                              //             topLeft: Radius.circular(10.r),
                                                              //             topRight: Radius.circular(10.r),
                                                              //           ),
                                                              //         ),
                                                              //         child: Padding(
                                                              //           padding: EdgeInsets.all(8.0.h),
                                                              //           child: Column(
                                                              //             crossAxisAlignment:
                                                              //             CrossAxisAlignment.start,
                                                              //             children: [
                                                              //               Row(
                                                              //                 children: [
                                                              //                   Container(
                                                              //                     padding: EdgeInsets.only(left: 10,right: 10),
                                                              //                     decoration: BoxDecoration(
                                                              //                       gradient: LinearGradient(
                                                              //                         colors:
                                                              //                         _singleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                                              //                             : _singleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                                              //                             : _singleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                              //                             : _singleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                                              //                             :_singleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                                              //                             : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                                              //                         begin: const FractionalOffset(
                                                              //                             0.2, 0.0),
                                                              //                         end: const FractionalOffset(
                                                              //                             1.1, 0.0),
                                                              //                       ),
                                                              //
                                                              //                       // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                                              //                       //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                                              //                       //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                                              //
                                                              //                       borderRadius: BorderRadius.all(
                                                              //                         Radius.circular(50.r),
                                                              //                       ),
                                                              //                     ),
                                                              //                     height: 30.h,
                                                              //                     //width: 100.w,
                                                              //                     child: Row(
                                                              //                       mainAxisAlignment: MainAxisAlignment.center,
                                                              //                       crossAxisAlignment: CrossAxisAlignment.center,
                                                              //                       children: [
                                                              //                         Image.asset(
                                                              //                           _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                                              //                               : "assets/images/wifi_icon.png",
                                                              //                           color: Colors.white,
                                                              //                           height: 16.h,
                                                              //                           scale: 8,
                                                              //                         ),
                                                              //                         SizedBox(
                                                              //                           width: 5.w,
                                                              //                         ),
                                                              //                         Text(
                                                              //                           _singleDevices[i].name,
                                                              //                           style: TextStyle(
                                                              //                             color: Colors.white,
                                                              //                             fontWeight: FontWeight.w600,
                                                              //                             fontSize: 12.sp,
                                                              //                             height: 1.8,
                                                              //                           ),
                                                              //                           textAlign: TextAlign.center,
                                                              //                         ),
                                                              //                       ],
                                                              //                     ),
                                                              //                   ),
                                                              //                 ],
                                                              //               ),
                                                              //               SizedBox(
                                                              //                 height: 5,
                                                              //               ),
                                                              //               Container(
                                                              //                 height: height * 0.07,
                                                              //                 child: //ReadMore
                                                              //                 Text(
                                                              //                   prefix,
                                                              //                   overflow: TextOverflow.clip,
                                                              //                   maxLines: 3,
                                                              //                   style: TextStyle(fontSize: 12),
                                                              //                 ),
                                                              //               ),
                                                              //               SizedBox(
                                                              //                 height: 7.h,
                                                              //               ),
                                                              //               Text(
                                                              //                 "${_singleDevices[i].price.toString()} AED",
                                                              //                 style: TextStyle(
                                                              //                   fontSize: 28.sp,
                                                              //                   fontWeight: FontWeight.w700,
                                                              //                 ),
                                                              //               )
                                                              //             ],
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 20.h,
                                                              //       ),
                                                              //       Padding(
                                                              //         padding: EdgeInsets.only(
                                                              //           left: 10.w,
                                                              //           right: 10.w,
                                                              //         ),
                                                              //         child: Row(
                                                              //           mainAxisAlignment:
                                                              //           MainAxisAlignment.spaceBetween,
                                                              //           children: [
                                                              //             Text(
                                                              //               "Validity",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.grey.shade500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //             Text(
                                                              //               "$abc days",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.black,
                                                              //                 fontWeight: FontWeight.w500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 10.h,
                                                              //       ),
                                                              //       Padding(
                                                              //         padding: EdgeInsets.only(
                                                              //           left: 10.w,
                                                              //           right: 10.w,
                                                              //         ),
                                                              //         child: Row(
                                                              //           mainAxisAlignment:
                                                              //           MainAxisAlignment.spaceBetween,
                                                              //           children: [
                                                              //             Text(
                                                              //               "# of Devices",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.grey.shade500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //             Text(
                                                              //               "${_singleDevices[i].devices.toString()}",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.black,
                                                              //                 fontWeight: FontWeight.w500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 10.h,
                                                              //       ),
                                                              //       Padding(
                                                              //         padding: EdgeInsets.only(
                                                              //           left: 10.w,
                                                              //           right: 10.w,
                                                              //         ),
                                                              //         child: Row(
                                                              //           mainAxisAlignment:
                                                              //           MainAxisAlignment.spaceBetween,
                                                              //           children: [
                                                              //             Text(
                                                              //               "Speed upto",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.grey.shade500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //             Text(
                                                              //               "${_singleDevices[i].bandwidth.toString()}Mbps",
                                                              //               style: TextStyle(
                                                              //                 color: Colors.black,
                                                              //                 fontWeight: FontWeight.w500,
                                                              //                 fontSize: 12.sp,
                                                              //               ),
                                                              //             ),
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //       SizedBox(
                                                              //         height: 10.h,
                                                              //       ),
                                                              //       Divider(),
                                                              //       Container(
                                                              //         height:45,
                                                              //         //color:Colors.red,
                                                              //         child: Center(
                                                              //           child: CustomButton(
                                                              //             height: 40.h,
                                                              //             width: 140.w,
                                                              //             onPressed: () {
                                                              //               Navigator.push(
                                                              //                   context,
                                                              //                   MaterialPageRoute(
                                                              //                       builder: (context) => PaymentMethod(
                                                              //                         price: _singleDevices[i].price.toString(),
                                                              //                         id: _singleDevices[i].id.toString(),
                                                              //                       )));
                                                              //             },
                                                              //             text: AppLocalizations.of(context)!
                                                              //                 .translate('buy_now')!,
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //
                                                              //     ],
                                                              //   ),
                                                              // );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text('$deviceAvailable'),
                                          ]
                                          // else if(_value=='multiple') ...[
                                          //   _multipleDevices.isNotEmpty?  Column(
                                          //     crossAxisAlignment: CrossAxisAlignment.start,
                                          //     children: [
                                          //
                                          //       Row(
                                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //         children: [
                                          //           Text(
                                          //             AppLocalizations.of(context)!
                                          //                 .translate('multiple_device')!,
                                          //             style: TextStyle(
                                          //               fontWeight: FontWeight.w500,
                                          //               fontSize: 16.sp,
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //       SizedBox(
                                          //         height: 10.h,
                                          //       ),
                                          //       GridView.builder(
                                          //         addRepaintBoundaries: false,
                                          //         shrinkWrap: true,
                                          //         physics: NeverScrollableScrollPhysics(),
                                          //         itemCount: _multipleDevices.length,
                                          //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          //           mainAxisSpacing: (4.0.h),
                                          //           crossAxisSpacing: (4.0.w),
                                          //           childAspectRatio: 0.4 / 0.813,
                                          //           crossAxisCount: 2,
                                          //         ),
                                          //         itemBuilder: (contxt, i) {
                                          //           double val = _multipleDevices[i].validity / 86400;
                                          //           print('this is value--$val');
                                          //           String abc = val.toStringAsFixed(0);
                                          //
                                          //           var parts = _multipleDevices[i].description.split('2');
                                          //           var prefix = parts[0].trim();
                                          //
                                          //           return Card(
                                          //             elevation: 0,
                                          //             shape: RoundedRectangleBorder(
                                          //               side: BorderSide(
                                          //                 color: Colors.grey.shade300,
                                          //                 width: 1.w,
                                          //               ),
                                          //               borderRadius: BorderRadius.circular(10),
                                          //             ),
                                          //             // decoration: BoxDecoration(
                                          //             //   borderRadius: BorderRadius.circular(10),
                                          //             //   border: Border.all()
                                          //             // ),
                                          //             child: Column(
                                          //               crossAxisAlignment: CrossAxisAlignment.start,
                                          //               children: [
                                          //                 Container(
                                          //                   // width: double.infinity,
                                          //                   // height: 120.h,
                                          //                   decoration: BoxDecoration(
                                          //                     color: Colors.pink.shade50,
                                          //                     borderRadius: BorderRadius.only(
                                          //                       topLeft: Radius.circular(10.r),
                                          //                       topRight: Radius.circular(10.r),
                                          //                     ),
                                          //                   ),
                                          //                   child: Padding(
                                          //                     padding: EdgeInsets.all(8.0.h),
                                          //                     child: Column(
                                          //                       crossAxisAlignment:
                                          //                       CrossAxisAlignment.start,
                                          //                       children: [
                                          //                         Row(
                                          //                           children: [
                                          //                             Container(
                                          //                               padding: EdgeInsets.only(left: 10,right: 10),
                                          //                               decoration: BoxDecoration(
                                          //                                 gradient: LinearGradient(
                                          //                                   colors:
                                          //                                   _multipleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                          //                                       : _multipleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                          //                                       : _multipleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       : _multipleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       :_multipleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                          //                                       : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                          //                                   begin: const FractionalOffset(
                                          //                                       0.2, 0.0),
                                          //                                   end: const FractionalOffset(
                                          //                                       1.1, 0.0),
                                          //                                 ),
                                          //
                                          //                                 // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                          //                                 //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                          //                                 //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                          //
                                          //                                 borderRadius: BorderRadius.all(
                                          //                                   Radius.circular(50.r),
                                          //                                 ),
                                          //                               ),
                                          //                               height: 30.h,
                                          //                               // width: 100.w,
                                          //                               child: Row(
                                          //                                 mainAxisAlignment: MainAxisAlignment.center,
                                          //                                 crossAxisAlignment: CrossAxisAlignment.center,
                                          //                                 children: [
                                          //                                   Image.asset(
                                          //                                     _multipleDevices[i].name == "GOLD" || _multipleDevices[i].name == "GOLD+" || _multipleDevices[i].name == "PLATINUM" || _multipleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                          //                                         : "assets/images/wifi_icon.png",
                                          //                                     color: Colors.white,
                                          //                                     height: 16.h,
                                          //                                     scale: 8,
                                          //                                   ),
                                          //                                   SizedBox(
                                          //                                     width: 5.w,
                                          //                                   ),
                                          //                                   Text(
                                          //                                     _multipleDevices[i].name,
                                          //                                     style: TextStyle(
                                          //                                       color: Colors.white,
                                          //                                       fontWeight: FontWeight.w600,
                                          //                                       fontSize: 12.sp,
                                          //                                       height: 1.8,
                                          //                                     ),
                                          //                                     textAlign: TextAlign.center,
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                             ),
                                          //                           ],
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 5,
                                          //                         ),
                                          //                         Container(
                                          //                           height: height * 0.07,
                                          //                           child: //ReadMore
                                          //                           Text(
                                          //                             prefix,
                                          //                             overflow: TextOverflow.clip,
                                          //                             maxLines: 3,
                                          //                             style: TextStyle(fontSize: 12),
                                          //                           ),
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 7.h,
                                          //                         ),
                                          //                         Text(
                                          //                           "${_multipleDevices[i].price.toString()} AED",
                                          //                           style: TextStyle(
                                          //                             fontSize: 28.sp,
                                          //                             fontWeight: FontWeight.w700,
                                          //                           ),
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 20.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Validity",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "$abc days",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "# of Devices",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_multipleDevices[i].devices.toString()}",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Speed upto",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_multipleDevices[i].bandwidth.toString()}Mbps",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Divider(),
                                          //                 Container(
                                          //                   height:45,
                                          //                   //color:Colors.red,
                                          //                   child: Center(
                                          //                     child: CustomButton(
                                          //                       height: 40.h,
                                          //                       width: 140.w,
                                          //                       onPressed: () {
                                          //                         Navigator.push(
                                          //                             context,
                                          //                             MaterialPageRoute(
                                          //                                 builder: (context) => PaymentMethod(
                                          //                                   price: _multipleDevices[i]
                                          //                                       .price
                                          //                                       .toString(),
                                          //                                   id: _multipleDevices[i]
                                          //                                       .id
                                          //                                       .toString(),
                                          //                                 )));
                                          //                       },
                                          //                       text: AppLocalizations.of(context)!
                                          //                           .translate('buy_now')!,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //
                                          //               ],
                                          //             ),
                                          //           );
                                          //         },
                                          //       ),
                                          //     ],
                                          //   ):Text(' '),
                                          //
                                          // ]else...[
                                          //   _singleDevices.isNotEmpty?   Column(
                                          //     crossAxisAlignment: CrossAxisAlignment.start,
                                          //     children: [
                                          //       Text(
                                          //         AppLocalizations.of(context)!
                                          //             .translate('single_device')!,
                                          //         style: TextStyle(
                                          //           fontWeight: FontWeight.w500,
                                          //           fontSize: 18.sp,
                                          //         ),
                                          //       ),
                                          //       SizedBox(
                                          //         height: 10.h,
                                          //       ),
                                          //       GridView.builder(
                                          //         addRepaintBoundaries: false,
                                          //         shrinkWrap: true,
                                          //         physics: NeverScrollableScrollPhysics(),
                                          //         itemCount: _singleDevices.length,
                                          //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          //           mainAxisSpacing: (4.0.h),
                                          //           crossAxisSpacing: (4.0.w),
                                          //           childAspectRatio: 0.4 / 0.813,
                                          //           crossAxisCount: 2,
                                          //         ),
                                          //         itemBuilder: (contxt, i) {
                                          //           double val = _singleDevices[i].validity / 86400;
                                          //           print('this is value--$val');
                                          //           String abc = val.toStringAsFixed(0);
                                          //
                                          //           var parts = _singleDevices[i].description.split('2');
                                          //           var prefix = parts[0].trim();
                                          //
                                          //           return Card(
                                          //             elevation: 0,
                                          //             shape: RoundedRectangleBorder(
                                          //               side: BorderSide(
                                          //                 color: Colors.grey.shade300,
                                          //                 width: 1.w,
                                          //               ),
                                          //               borderRadius: BorderRadius.circular(10),
                                          //             ),
                                          //             // decoration: BoxDecoration(
                                          //             //   borderRadius: BorderRadius.circular(10),
                                          //             //   border: Border.all()
                                          //             // ),
                                          //             child: Column(
                                          //               crossAxisAlignment: CrossAxisAlignment.start,
                                          //               children: [
                                          //                 Container(
                                          //                   // width: double.infinity,
                                          //                   // height: 120.h,
                                          //                   decoration: BoxDecoration(
                                          //                     color: Colors.pink.shade50,
                                          //                     borderRadius: BorderRadius.only(
                                          //                       topLeft: Radius.circular(10.r),
                                          //                       topRight: Radius.circular(10.r),
                                          //                     ),
                                          //                   ),
                                          //                   child: Padding(
                                          //                     padding: EdgeInsets.all(8.0.h),
                                          //                     child: Column(
                                          //                       crossAxisAlignment:
                                          //                       CrossAxisAlignment.start,
                                          //                       children: [
                                          //                         Row(
                                          //                           children: [
                                          //                             Container(
                                          //                               padding: EdgeInsets.only(left: 10,right: 10),
                                          //                               decoration: BoxDecoration(
                                          //                                 gradient: LinearGradient(
                                          //                                   colors:
                                          //                                   _singleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                          //                                       : _singleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                          //                                       : _singleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       : _singleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       :_singleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                          //                                       : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                          //                                   begin: const FractionalOffset(
                                          //                                       0.2, 0.0),
                                          //                                   end: const FractionalOffset(
                                          //                                       1.1, 0.0),
                                          //                                 ),
                                          //
                                          //                                 // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                          //                                 //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                          //                                 //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                          //
                                          //                                 borderRadius: BorderRadius.all(
                                          //                                   Radius.circular(50.r),
                                          //                                 ),
                                          //                               ),
                                          //                               height: 30.h,
                                          //                               //width: 100.w,
                                          //                               child: Row(
                                          //                                 mainAxisAlignment: MainAxisAlignment.center,
                                          //                                 crossAxisAlignment: CrossAxisAlignment.center,
                                          //                                 children: [
                                          //                                   Image.asset(
                                          //                                     _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                          //                                         : "assets/images/wifi_icon.png",
                                          //                                     color: Colors.white,
                                          //                                     height: 16.h,
                                          //                                     scale: 8,
                                          //                                   ),
                                          //                                   SizedBox(
                                          //                                     width: 5.w,
                                          //                                   ),
                                          //                                   Text(
                                          //                                     _singleDevices[i].name,
                                          //                                     style: TextStyle(
                                          //                                       color: Colors.white,
                                          //                                       fontWeight: FontWeight.w600,
                                          //                                       fontSize: 12.sp,
                                          //                                       height: 1.8,
                                          //                                     ),
                                          //                                     textAlign: TextAlign.center,
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                             ),
                                          //                           ],
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 5,
                                          //                         ),
                                          //                         Container(
                                          //                           height: height * 0.07,
                                          //                           child: //ReadMore
                                          //                           Text(
                                          //                             prefix,
                                          //                             overflow: TextOverflow.clip,
                                          //                             maxLines: 3,
                                          //                             style: TextStyle(fontSize: 12),
                                          //                           ),
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 7.h,
                                          //                         ),
                                          //                         Text(
                                          //                           "${_singleDevices[i].price.toString()} AED",
                                          //                           style: TextStyle(
                                          //                             fontSize: 28.sp,
                                          //                             fontWeight: FontWeight.w700,
                                          //                           ),
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 20.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Validity",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "$abc days",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "# of Devices",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_singleDevices[i].devices.toString()}",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Speed upto",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_singleDevices[i].bandwidth.toString()}Mbps",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Divider(),
                                          //                 Container(
                                          //                   height:45,
                                          //                   //color:Colors.red,
                                          //                   child: Center(
                                          //                     child: CustomButton(
                                          //                       height: 40.h,
                                          //                       width: 140.w,
                                          //                       onPressed: () {
                                          //                         Navigator.push(
                                          //                             context,
                                          //                             MaterialPageRoute(
                                          //                                 builder: (context) => PaymentMethod(
                                          //                                   price: _singleDevices[i]
                                          //                                       .price
                                          //                                       .toString(),
                                          //                                   id: _singleDevices[i]
                                          //                                       .id
                                          //                                       .toString(),
                                          //                                 )));
                                          //                       },
                                          //                       text: AppLocalizations.of(context)!
                                          //                           .translate('buy_now')!,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //
                                          //               ],
                                          //             ),
                                          //           );
                                          //         },
                                          //       ),
                                          //     ],
                                          //   ):Text(' '),
                                          //
                                          //   _multipleDevices.isNotEmpty?  Column(
                                          //     crossAxisAlignment: CrossAxisAlignment.start,
                                          //     children: [
                                          //       SizedBox(
                                          //         height: 20.h,
                                          //       ),
                                          //       Row(
                                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //         children: [
                                          //           Text(
                                          //             AppLocalizations.of(context)!
                                          //                 .translate('multiple_device')!,
                                          //             style: TextStyle(
                                          //               fontWeight: FontWeight.w500,
                                          //               fontSize: 16.sp,
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //       SizedBox(
                                          //         height: 10.h,
                                          //       ),
                                          //       GridView.builder(
                                          //         addRepaintBoundaries: false,
                                          //         shrinkWrap: true,
                                          //         physics: NeverScrollableScrollPhysics(),
                                          //         itemCount: _multipleDevices.length,
                                          //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          //           mainAxisSpacing: (4.0.h),
                                          //           crossAxisSpacing: (4.0.w),
                                          //           childAspectRatio: 0.4 / 0.813,
                                          //           crossAxisCount: 2,
                                          //         ),
                                          //         itemBuilder: (contxt, i) {
                                          //           double val = _multipleDevices[i].validity / 86400;
                                          //           print('this is value--$val');
                                          //           String abc = val.toStringAsFixed(0);
                                          //
                                          //           var parts = _multipleDevices[i].description.split('2');
                                          //           var prefix = parts[0].trim();
                                          //
                                          //           return Card(
                                          //             elevation: 0,
                                          //             shape: RoundedRectangleBorder(
                                          //               side: BorderSide(
                                          //                 color: Colors.grey.shade300,
                                          //                 width: 1.w,
                                          //               ),
                                          //               borderRadius: BorderRadius.circular(10),
                                          //             ),
                                          //             // decoration: BoxDecoration(
                                          //             //   borderRadius: BorderRadius.circular(10),
                                          //             //   border: Border.all()
                                          //             // ),
                                          //             child: Column(
                                          //               crossAxisAlignment: CrossAxisAlignment.start,
                                          //               children: [
                                          //                 Container(
                                          //                   // width: double.infinity,
                                          //                   // height: 120.h,
                                          //                   decoration: BoxDecoration(
                                          //                     color: Colors.pink.shade50,
                                          //                     borderRadius: BorderRadius.only(
                                          //                       topLeft: Radius.circular(10.r),
                                          //                       topRight: Radius.circular(10.r),
                                          //                     ),
                                          //                   ),
                                          //                   child: Padding(
                                          //                     padding: EdgeInsets.all(8.0.h),
                                          //                     child: Column(
                                          //                       crossAxisAlignment:
                                          //                       CrossAxisAlignment.start,
                                          //                       children: [
                                          //                         Row(
                                          //                           children: [
                                          //                             Container(
                                          //                               padding: EdgeInsets.only(left: 10,right: 10),
                                          //                               decoration: BoxDecoration(
                                          //                                 gradient: LinearGradient(
                                          //                                   colors:
                                          //                                   _multipleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                          //                                       : _multipleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                          //                                       : _multipleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       : _multipleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       :_multipleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                          //                                       : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                          //                                   begin: const FractionalOffset(
                                          //                                       0.2, 0.0),
                                          //                                   end: const FractionalOffset(
                                          //                                       1.1, 0.0),
                                          //                                 ),
                                          //
                                          //                                 // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                          //                                 //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                          //                                 //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                          //
                                          //                                 borderRadius: BorderRadius.all(
                                          //                                   Radius.circular(50.r),
                                          //                                 ),
                                          //                               ),
                                          //                               height: 30.h,
                                          //                               // width: 100.w,
                                          //                               child: Row(
                                          //                                 mainAxisAlignment: MainAxisAlignment.center,
                                          //                                 crossAxisAlignment: CrossAxisAlignment.center,
                                          //                                 children: [
                                          //                                   Image.asset(
                                          //                                     _multipleDevices[i].name == "GOLD" || _multipleDevices[i].name == "GOLD+" || _multipleDevices[i].name == "PLATINUM" || _multipleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                          //                                         : "assets/images/wifi_icon.png",
                                          //                                     color: Colors.white,
                                          //                                     height: 16.h,
                                          //                                     scale: 8,
                                          //                                   ),
                                          //                                   SizedBox(
                                          //                                     width: 5.w,
                                          //                                   ),
                                          //                                   Text(
                                          //                                     _multipleDevices[i].name,
                                          //                                     style: TextStyle(
                                          //                                       color: Colors.white,
                                          //                                       fontWeight: FontWeight.w600,
                                          //                                       fontSize: 12.sp,
                                          //                                       height: 1.8,
                                          //                                     ),
                                          //                                     textAlign: TextAlign.center,
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                             ),
                                          //                           ],
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 5,
                                          //                         ),
                                          //                         Container(
                                          //                           height: height * 0.07,
                                          //                           child: //ReadMore
                                          //                           Text(
                                          //                             prefix,
                                          //                             overflow: TextOverflow.clip,
                                          //                             maxLines: 3,
                                          //                             style: TextStyle(fontSize: 12),
                                          //                           ),
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 7.h,
                                          //                         ),
                                          //                         Text(
                                          //                           "${_multipleDevices[i].price.toString()} AED",
                                          //                           style: TextStyle(
                                          //                             fontSize: 28.sp,
                                          //                             fontWeight: FontWeight.w700,
                                          //                           ),
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 20.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Validity",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "$abc days",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "# of Devices",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_multipleDevices[i].devices.toString()}",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Speed upto",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_multipleDevices[i].bandwidth.toString()}Mbps",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Divider(),
                                          //                 Container(
                                          //                   height:45,
                                          //                   //color:Colors.red,
                                          //                   child: Center(
                                          //                     child: CustomButton(
                                          //                       height: 40.h,
                                          //                       width: 140.w,
                                          //                       onPressed: () {
                                          //                         Navigator.push(
                                          //                             context,
                                          //                             MaterialPageRoute(
                                          //                                 builder: (context) => PaymentMethod(
                                          //                                   price: _multipleDevices[i]
                                          //                                       .price
                                          //                                       .toString(),
                                          //                                   id: _multipleDevices[i]
                                          //                                       .id
                                          //                                       .toString(),
                                          //                                 )));
                                          //                       },
                                          //                       text: AppLocalizations.of(context)!
                                          //                           .translate('buy_now')!,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //
                                          //               ],
                                          //             ),
                                          //           );
                                          //         },
                                          //       ),
                                          //     ],
                                          //   ):Text(' '),
                                          //
                                          // ]

                                          // affordableDevices.isNotEmpty?  Column(
                                          //   crossAxisAlignment: CrossAxisAlignment.start,
                                          //     children: [
                                          //       SizedBox(
                                          //         height: 20.h,
                                          //       ),
                                          //       Text(
                                          //         AppLocalizations.of(context)!
                                          //             .translate('network_device')!,
                                          //         style: TextStyle(
                                          //           fontWeight: FontWeight.w500,
                                          //           fontSize: 16.sp,
                                          //         ),
                                          //       ),
                                          //       SizedBox(
                                          //         height: 10.h,
                                          //       ),
                                          //       GridView.builder(
                                          //         addRepaintBoundaries: false,
                                          //         shrinkWrap: true,
                                          //         physics: NeverScrollableScrollPhysics(),
                                          //         itemCount: affordableDevices.length,
                                          //         gridDelegate:
                                          //         SliverGridDelegateWithFixedCrossAxisCount(
                                          //           mainAxisSpacing: (4.0.h),
                                          //           crossAxisSpacing: (4.0.w),
                                          //           childAspectRatio: 0.4 / 0.9,
                                          //           crossAxisCount: 2,
                                          //         ),
                                          //         itemBuilder: (contxt, i) {
                                          //           double val =
                                          //               affordableDevices[i].validity / 86400;
                                          //           print('this is value--$val');
                                          //           String abc = val.toStringAsFixed(0);
                                          //           return Card(
                                          //             elevation: 0,
                                          //             shape: RoundedRectangleBorder(
                                          //               side: BorderSide(
                                          //                 color: Colors.grey.shade300,
                                          //                 width: 1.w,
                                          //               ),
                                          //               borderRadius: BorderRadius.circular(10),
                                          //             ),
                                          //             child: Column(
                                          //               crossAxisAlignment:
                                          //               CrossAxisAlignment.start,
                                          //               children: [
                                          //                 Container(
                                          //                   width: double.infinity,
                                          //                   height: 170.h,
                                          //                   decoration: BoxDecoration(
                                          //                     color: Colors.pink.shade50,
                                          //                     borderRadius: BorderRadius.only(
                                          //                       topLeft: Radius.circular(10.r),
                                          //                       topRight: Radius.circular(10.r),
                                          //                     ),
                                          //                   ),
                                          //                   child: Padding(
                                          //                     padding: EdgeInsets.all(8.0.h),
                                          //                     child: Column(
                                          //                       crossAxisAlignment:
                                          //                       CrossAxisAlignment.start,
                                          //                       children: [
                                          //                         Container(
                                          //                           decoration: BoxDecoration(
                                          //                             gradient: LinearGradient(
                                          //                               colors: affordableDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                          //                                   : affordableDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                          //                                   : [Color(0xFFF19164), Color(0xFFF19164),],
                                          //                               begin:
                                          //                               const FractionalOffset(
                                          //                                   0.2, 0.0),
                                          //                               end: const FractionalOffset(
                                          //                                   1.1, 0.0),
                                          //                             ),
                                          //                             color: affordableDevices[i]
                                          //                                 .name ==
                                          //                                 "BLUE"
                                          //                                 ? Colors.blue
                                          //                                 : affordableDevices[i]
                                          //                                 .name ==
                                          //                                 "SILVER"
                                          //                                 ? Colors.grey
                                          //                                 : affordableDevices[i]
                                          //                                 .name ==
                                          //                                 "CRYSTAL"
                                          //                                 ? Colors.blue
                                          //                                 : Color(
                                          //                                 0xFFC8C5BD),
                                          //                             borderRadius:
                                          //                             BorderRadius.all(
                                          //                               Radius.circular(50.r),
                                          //                             ),
                                          //                           ),
                                          //                           height: 30.h,
                                          //                           width: 100.w,
                                          //                           child: Row(
                                          //                             mainAxisAlignment:
                                          //                             MainAxisAlignment.center,
                                          //                             crossAxisAlignment:
                                          //                             CrossAxisAlignment.center,
                                          //                             children: [
                                          //                               Image.asset(
                                          //                                 affordableDevices[i]
                                          //                                     .name ==
                                          //                                     "GOLD"
                                          //                                     ? "assets/images/crown.png"
                                          //                                     : affordableDevices[i]
                                          //                                     .name ==
                                          //                                     "PLATINUM"
                                          //                                     ? "assets/images/crown.png"
                                          //                                     : "assets/images/wifi_icon.png",
                                          //                                 color: Colors.white,
                                          //                                 height: 16.h,
                                          //                                 scale: 8,
                                          //                               ),
                                          //                               SizedBox(
                                          //                                 width: 5.w,
                                          //                               ),
                                          //                               Text(
                                          //                                 affordableDevices[i].name,
                                          //                                 style: TextStyle(
                                          //                                   color: Colors.white,
                                          //                                   fontWeight:
                                          //                                   FontWeight.w600,
                                          //                                   fontSize: 12.sp,
                                          //                                   height: 1.8,
                                          //                                 ),
                                          //                                 textAlign:
                                          //                                 TextAlign.center,
                                          //                               ),
                                          //                             ],
                                          //                           ),
                                          //                         ),
                                          //                         Container(
                                          //                           height: height * 0.12,
                                          //                           child: //ReadMore
                                          //                           Text(
                                          //                             affordableDevices[i]
                                          //                                 .description,
                                          //                             overflow:
                                          //                             TextOverflow.ellipsis,
                                          //                             maxLines: 4,
                                          //                           ),
                                          //                         ),
                                          //                         Text(
                                          //                           "${affordableDevices[i].price.toString()} AED",
                                          //                           style: TextStyle(
                                          //                             fontSize: 28.sp,
                                          //                             fontWeight: FontWeight.w700,
                                          //                           ),
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 20.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Validity",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "$abc days",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "# of Devices",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${affordableDevices[i].devices.toString()}",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Speed upto",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${affordableDevices[i].bandwidth.toString()}Mbps",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Divider(),
                                          //                 Center(
                                          //                     child: CustomButton(
                                          //                       height: 40.h,
                                          //                       width: 140.w,
                                          //                       onPressed: () {
                                          //                         Navigator.push(
                                          //                             context,
                                          //                             MaterialPageRoute(
                                          //                                 builder: (context) =>
                                          //                                     PaymentMethod(
                                          //                                       price:
                                          //                                       affordableDevices[i]
                                          //                                           .price
                                          //                                           .toString(),
                                          //                                       id: affordableDevices[i]
                                          //                                           .id
                                          //                                           .toString(),
                                          //                                     )));
                                          //                       },
                                          //                       text: AppLocalizations.of(context)!
                                          //                           .translate('buy_now')!,
                                          //                     )
                                          //
                                          //                   // TextButton(
                                          //                   //   style: TextButton.styleFrom(
                                          //                   //     minimumSize: Size(140.w, 40.h),
                                          //                   //     backgroundColor: Colors.pink,
                                          //                   //     primary: Colors.white,
                                          //                   //   ),
                                          //                   //   onPressed: () {
                                          //                   //     Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentMethod(price: netWorkDevices[i].price.toString(), id: netWorkDevices[i].id.toString(),)));
                                          //                   //   },
                                          //                   //   child: Text(
                                          //                   //     AppLocalizations.of(context)!.translate('buy_now')!,
                                          //                   //   ),
                                          //                   // ),
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //           );
                                          //         },
                                          //       )
                                          //     ],
                                          //   ):Text(' ')

                                          // else if(_value=='multiple') ...[
                                          //   _multipleDevices.isNotEmpty?  Column(
                                          //     crossAxisAlignment: CrossAxisAlignment.start,
                                          //     children: [
                                          //
                                          //       Row(
                                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //         children: [
                                          //           Text(
                                          //             AppLocalizations.of(context)!
                                          //                 .translate('multiple_device')!,
                                          //             style: TextStyle(
                                          //               fontWeight: FontWeight.w500,
                                          //               fontSize: 16.sp,
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //       SizedBox(
                                          //         height: 10.h,
                                          //       ),
                                          //       GridView.builder(
                                          //         addRepaintBoundaries: false,
                                          //         shrinkWrap: true,
                                          //         physics: NeverScrollableScrollPhysics(),
                                          //         itemCount: _multipleDevices.length,
                                          //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          //           mainAxisSpacing: (4.0.h),
                                          //           crossAxisSpacing: (4.0.w),
                                          //           childAspectRatio: 0.4 / 0.813,
                                          //           crossAxisCount: 2,
                                          //         ),
                                          //         itemBuilder: (contxt, i) {
                                          //           double val = _multipleDevices[i].validity / 86400;
                                          //           print('this is value--$val');
                                          //           String abc = val.toStringAsFixed(0);
                                          //
                                          //           var parts = _multipleDevices[i].description.split('2');
                                          //           var prefix = parts[0].trim();
                                          //
                                          //           return Card(
                                          //             elevation: 0,
                                          //             shape: RoundedRectangleBorder(
                                          //               side: BorderSide(
                                          //                 color: Colors.grey.shade300,
                                          //                 width: 1.w,
                                          //               ),
                                          //               borderRadius: BorderRadius.circular(10),
                                          //             ),
                                          //             // decoration: BoxDecoration(
                                          //             //   borderRadius: BorderRadius.circular(10),
                                          //             //   border: Border.all()
                                          //             // ),
                                          //             child: Column(
                                          //               crossAxisAlignment: CrossAxisAlignment.start,
                                          //               children: [
                                          //                 Container(
                                          //                   // width: double.infinity,
                                          //                   // height: 120.h,
                                          //                   decoration: BoxDecoration(
                                          //                     color: Colors.pink.shade50,
                                          //                     borderRadius: BorderRadius.only(
                                          //                       topLeft: Radius.circular(10.r),
                                          //                       topRight: Radius.circular(10.r),
                                          //                     ),
                                          //                   ),
                                          //                   child: Padding(
                                          //                     padding: EdgeInsets.all(8.0.h),
                                          //                     child: Column(
                                          //                       crossAxisAlignment:
                                          //                       CrossAxisAlignment.start,
                                          //                       children: [
                                          //                         Row(
                                          //                           children: [
                                          //                             Container(
                                          //                               padding: EdgeInsets.only(left: 10,right: 10),
                                          //                               decoration: BoxDecoration(
                                          //                                 gradient: LinearGradient(
                                          //                                   colors:
                                          //                                   _multipleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                          //                                       : _multipleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                          //                                       : _multipleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       : _multipleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       :_multipleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                          //                                       : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                          //                                   begin: const FractionalOffset(
                                          //                                       0.2, 0.0),
                                          //                                   end: const FractionalOffset(
                                          //                                       1.1, 0.0),
                                          //                                 ),
                                          //
                                          //                                 // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                          //                                 //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                          //                                 //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                          //
                                          //                                 borderRadius: BorderRadius.all(
                                          //                                   Radius.circular(50.r),
                                          //                                 ),
                                          //                               ),
                                          //                               height: 30.h,
                                          //                               // width: 100.w,
                                          //                               child: Row(
                                          //                                 mainAxisAlignment: MainAxisAlignment.center,
                                          //                                 crossAxisAlignment: CrossAxisAlignment.center,
                                          //                                 children: [
                                          //                                   Image.asset(
                                          //                                     _multipleDevices[i].name == "GOLD" || _multipleDevices[i].name == "GOLD+" || _multipleDevices[i].name == "PLATINUM" || _multipleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                          //                                         : "assets/images/wifi_icon.png",
                                          //                                     color: Colors.white,
                                          //                                     height: 16.h,
                                          //                                     scale: 8,
                                          //                                   ),
                                          //                                   SizedBox(
                                          //                                     width: 5.w,
                                          //                                   ),
                                          //                                   Text(
                                          //                                     _multipleDevices[i].name,
                                          //                                     style: TextStyle(
                                          //                                       color: Colors.white,
                                          //                                       fontWeight: FontWeight.w600,
                                          //                                       fontSize: 12.sp,
                                          //                                       height: 1.8,
                                          //                                     ),
                                          //                                     textAlign: TextAlign.center,
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                             ),
                                          //                           ],
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 5,
                                          //                         ),
                                          //                         Container(
                                          //                           height: height * 0.07,
                                          //                           child: //ReadMore
                                          //                           Text(
                                          //                             prefix,
                                          //                             overflow: TextOverflow.clip,
                                          //                             maxLines: 3,
                                          //                             style: TextStyle(fontSize: 12),
                                          //                           ),
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 7.h,
                                          //                         ),
                                          //                         Text(
                                          //                           "${_multipleDevices[i].price.toString()} AED",
                                          //                           style: TextStyle(
                                          //                             fontSize: 28.sp,
                                          //                             fontWeight: FontWeight.w700,
                                          //                           ),
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 20.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Validity",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "$abc days",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "# of Devices",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_multipleDevices[i].devices.toString()}",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Speed upto",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_multipleDevices[i].bandwidth.toString()}Mbps",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Divider(),
                                          //                 Container(
                                          //                   height:45,
                                          //                   //color:Colors.red,
                                          //                   child: Center(
                                          //                     child: CustomButton(
                                          //                       height: 40.h,
                                          //                       width: 140.w,
                                          //                       onPressed: () {
                                          //                         Navigator.push(
                                          //                             context,
                                          //                             MaterialPageRoute(
                                          //                                 builder: (context) => PaymentMethod(
                                          //                                   price: _multipleDevices[i]
                                          //                                       .price
                                          //                                       .toString(),
                                          //                                   id: _multipleDevices[i]
                                          //                                       .id
                                          //                                       .toString(),
                                          //                                 )));
                                          //                       },
                                          //                       text: AppLocalizations.of(context)!
                                          //                           .translate('buy_now')!,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //
                                          //               ],
                                          //             ),
                                          //           );
                                          //         },
                                          //       ),
                                          //     ],
                                          //   ):Text(' '),
                                          //
                                          // ]else...[
                                          //   _singleDevices.isNotEmpty?   Column(
                                          //     crossAxisAlignment: CrossAxisAlignment.start,
                                          //     children: [
                                          //       Text(
                                          //         AppLocalizations.of(context)!
                                          //             .translate('single_device')!,
                                          //         style: TextStyle(
                                          //           fontWeight: FontWeight.w500,
                                          //           fontSize: 18.sp,
                                          //         ),
                                          //       ),
                                          //       SizedBox(
                                          //         height: 10.h,
                                          //       ),
                                          //       GridView.builder(
                                          //         addRepaintBoundaries: false,
                                          //         shrinkWrap: true,
                                          //         physics: NeverScrollableScrollPhysics(),
                                          //         itemCount: _singleDevices.length,
                                          //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          //           mainAxisSpacing: (4.0.h),
                                          //           crossAxisSpacing: (4.0.w),
                                          //           childAspectRatio: 0.4 / 0.813,
                                          //           crossAxisCount: 2,
                                          //         ),
                                          //         itemBuilder: (contxt, i) {
                                          //           double val = _singleDevices[i].validity / 86400;
                                          //           print('this is value--$val');
                                          //           String abc = val.toStringAsFixed(0);
                                          //
                                          //           var parts = _singleDevices[i].description.split('2');
                                          //           var prefix = parts[0].trim();
                                          //
                                          //           return Card(
                                          //             elevation: 0,
                                          //             shape: RoundedRectangleBorder(
                                          //               side: BorderSide(
                                          //                 color: Colors.grey.shade300,
                                          //                 width: 1.w,
                                          //               ),
                                          //               borderRadius: BorderRadius.circular(10),
                                          //             ),
                                          //             // decoration: BoxDecoration(
                                          //             //   borderRadius: BorderRadius.circular(10),
                                          //             //   border: Border.all()
                                          //             // ),
                                          //             child: Column(
                                          //               crossAxisAlignment: CrossAxisAlignment.start,
                                          //               children: [
                                          //                 Container(
                                          //                   // width: double.infinity,
                                          //                   // height: 120.h,
                                          //                   decoration: BoxDecoration(
                                          //                     color: Colors.pink.shade50,
                                          //                     borderRadius: BorderRadius.only(
                                          //                       topLeft: Radius.circular(10.r),
                                          //                       topRight: Radius.circular(10.r),
                                          //                     ),
                                          //                   ),
                                          //                   child: Padding(
                                          //                     padding: EdgeInsets.all(8.0.h),
                                          //                     child: Column(
                                          //                       crossAxisAlignment:
                                          //                       CrossAxisAlignment.start,
                                          //                       children: [
                                          //                         Row(
                                          //                           children: [
                                          //                             Container(
                                          //                               padding: EdgeInsets.only(left: 10,right: 10),
                                          //                               decoration: BoxDecoration(
                                          //                                 gradient: LinearGradient(
                                          //                                   colors:
                                          //                                   _singleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                          //                                       : _singleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                          //                                       : _singleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       : _singleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       :_singleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                          //                                       : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                          //                                   begin: const FractionalOffset(
                                          //                                       0.2, 0.0),
                                          //                                   end: const FractionalOffset(
                                          //                                       1.1, 0.0),
                                          //                                 ),
                                          //
                                          //                                 // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                          //                                 //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                          //                                 //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                          //
                                          //                                 borderRadius: BorderRadius.all(
                                          //                                   Radius.circular(50.r),
                                          //                                 ),
                                          //                               ),
                                          //                               height: 30.h,
                                          //                               //width: 100.w,
                                          //                               child: Row(
                                          //                                 mainAxisAlignment: MainAxisAlignment.center,
                                          //                                 crossAxisAlignment: CrossAxisAlignment.center,
                                          //                                 children: [
                                          //                                   Image.asset(
                                          //                                     _singleDevices[i].name == "GOLD" || _singleDevices[i].name == "GOLD+" || _singleDevices[i].name == "PLATINUM" || _singleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                          //                                         : "assets/images/wifi_icon.png",
                                          //                                     color: Colors.white,
                                          //                                     height: 16.h,
                                          //                                     scale: 8,
                                          //                                   ),
                                          //                                   SizedBox(
                                          //                                     width: 5.w,
                                          //                                   ),
                                          //                                   Text(
                                          //                                     _singleDevices[i].name,
                                          //                                     style: TextStyle(
                                          //                                       color: Colors.white,
                                          //                                       fontWeight: FontWeight.w600,
                                          //                                       fontSize: 12.sp,
                                          //                                       height: 1.8,
                                          //                                     ),
                                          //                                     textAlign: TextAlign.center,
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                             ),
                                          //                           ],
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 5,
                                          //                         ),
                                          //                         Container(
                                          //                           height: height * 0.07,
                                          //                           child: //ReadMore
                                          //                           Text(
                                          //                             prefix,
                                          //                             overflow: TextOverflow.clip,
                                          //                             maxLines: 3,
                                          //                             style: TextStyle(fontSize: 12),
                                          //                           ),
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 7.h,
                                          //                         ),
                                          //                         Text(
                                          //                           "${_singleDevices[i].price.toString()} AED",
                                          //                           style: TextStyle(
                                          //                             fontSize: 28.sp,
                                          //                             fontWeight: FontWeight.w700,
                                          //                           ),
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 20.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Validity",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "$abc days",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "# of Devices",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_singleDevices[i].devices.toString()}",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Speed upto",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_singleDevices[i].bandwidth.toString()}Mbps",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Divider(),
                                          //                 Container(
                                          //                   height:45,
                                          //                   //color:Colors.red,
                                          //                   child: Center(
                                          //                     child: CustomButton(
                                          //                       height: 40.h,
                                          //                       width: 140.w,
                                          //                       onPressed: () {
                                          //                         Navigator.push(
                                          //                             context,
                                          //                             MaterialPageRoute(
                                          //                                 builder: (context) => PaymentMethod(
                                          //                                   price: _singleDevices[i]
                                          //                                       .price
                                          //                                       .toString(),
                                          //                                   id: _singleDevices[i]
                                          //                                       .id
                                          //                                       .toString(),
                                          //                                 )));
                                          //                       },
                                          //                       text: AppLocalizations.of(context)!
                                          //                           .translate('buy_now')!,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //
                                          //               ],
                                          //             ),
                                          //           );
                                          //         },
                                          //       ),
                                          //     ],
                                          //   ):Text(' '),
                                          //
                                          //   _multipleDevices.isNotEmpty?  Column(
                                          //     crossAxisAlignment: CrossAxisAlignment.start,
                                          //     children: [
                                          //       SizedBox(
                                          //         height: 20.h,
                                          //       ),
                                          //       Row(
                                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //         children: [
                                          //           Text(
                                          //             AppLocalizations.of(context)!
                                          //                 .translate('multiple_device')!,
                                          //             style: TextStyle(
                                          //               fontWeight: FontWeight.w500,
                                          //               fontSize: 16.sp,
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //       SizedBox(
                                          //         height: 10.h,
                                          //       ),
                                          //       GridView.builder(
                                          //         addRepaintBoundaries: false,
                                          //         shrinkWrap: true,
                                          //         physics: NeverScrollableScrollPhysics(),
                                          //         itemCount: _multipleDevices.length,
                                          //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          //           mainAxisSpacing: (4.0.h),
                                          //           crossAxisSpacing: (4.0.w),
                                          //           childAspectRatio: 0.4 / 0.813,
                                          //           crossAxisCount: 2,
                                          //         ),
                                          //         itemBuilder: (contxt, i) {
                                          //           double val = _multipleDevices[i].validity / 86400;
                                          //           print('this is value--$val');
                                          //           String abc = val.toStringAsFixed(0);
                                          //
                                          //           var parts = _multipleDevices[i].description.split('2');
                                          //           var prefix = parts[0].trim();
                                          //
                                          //           return Card(
                                          //             elevation: 0,
                                          //             shape: RoundedRectangleBorder(
                                          //               side: BorderSide(
                                          //                 color: Colors.grey.shade300,
                                          //                 width: 1.w,
                                          //               ),
                                          //               borderRadius: BorderRadius.circular(10),
                                          //             ),
                                          //             // decoration: BoxDecoration(
                                          //             //   borderRadius: BorderRadius.circular(10),
                                          //             //   border: Border.all()
                                          //             // ),
                                          //             child: Column(
                                          //               crossAxisAlignment: CrossAxisAlignment.start,
                                          //               children: [
                                          //                 Container(
                                          //                   // width: double.infinity,
                                          //                   // height: 120.h,
                                          //                   decoration: BoxDecoration(
                                          //                     color: Colors.pink.shade50,
                                          //                     borderRadius: BorderRadius.only(
                                          //                       topLeft: Radius.circular(10.r),
                                          //                       topRight: Radius.circular(10.r),
                                          //                     ),
                                          //                   ),
                                          //                   child: Padding(
                                          //                     padding: EdgeInsets.all(8.0.h),
                                          //                     child: Column(
                                          //                       crossAxisAlignment:
                                          //                       CrossAxisAlignment.start,
                                          //                       children: [
                                          //                         Row(
                                          //                           children: [
                                          //                             Container(
                                          //                               padding: EdgeInsets.only(left: 10,right: 10),
                                          //                               decoration: BoxDecoration(
                                          //                                 gradient: LinearGradient(
                                          //                                   colors:
                                          //                                   _multipleDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                          //                                       : _multipleDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                          //                                       : _multipleDevices[i].name == "GOLD+" ? [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       : _multipleDevices[i].name == "GOLD" ?   [Color(0xFFF4C73E), Color(0xFFB99013),]
                                          //                                       :_multipleDevices[i].name == "CRYSTAL" ?  [Color(0xFFF19164), Color(0xFFF19164),]
                                          //                                       : [Color(0xFF1A1A1A), Color(0xFF1A1A1A),],
                                          //                                   begin: const FractionalOffset(
                                          //                                       0.2, 0.0),
                                          //                                   end: const FractionalOffset(
                                          //                                       1.1, 0.0),
                                          //                                 ),
                                          //
                                          //                                 // color: lovedDevices[i].name == "GOLD" ? Color(0xFFB99013)
                                          //                                 //     :lovedDevices[i].name == "PLATINUM"? Color(0xFF1A1A1A)
                                          //                                 //     :lovedDevices[i].name == "BLUE"?Color(0xFF5787E3):Color(0xFFC8C5BD),
                                          //
                                          //                                 borderRadius: BorderRadius.all(
                                          //                                   Radius.circular(50.r),
                                          //                                 ),
                                          //                               ),
                                          //                               height: 30.h,
                                          //                               // width: 100.w,
                                          //                               child: Row(
                                          //                                 mainAxisAlignment: MainAxisAlignment.center,
                                          //                                 crossAxisAlignment: CrossAxisAlignment.center,
                                          //                                 children: [
                                          //                                   Image.asset(
                                          //                                     _multipleDevices[i].name == "GOLD" || _multipleDevices[i].name == "GOLD+" || _multipleDevices[i].name == "PLATINUM" || _multipleDevices[i].name == "PLATINUM+" ? "assets/images/crown.png"
                                          //                                         : "assets/images/wifi_icon.png",
                                          //                                     color: Colors.white,
                                          //                                     height: 16.h,
                                          //                                     scale: 8,
                                          //                                   ),
                                          //                                   SizedBox(
                                          //                                     width: 5.w,
                                          //                                   ),
                                          //                                   Text(
                                          //                                     _multipleDevices[i].name,
                                          //                                     style: TextStyle(
                                          //                                       color: Colors.white,
                                          //                                       fontWeight: FontWeight.w600,
                                          //                                       fontSize: 12.sp,
                                          //                                       height: 1.8,
                                          //                                     ),
                                          //                                     textAlign: TextAlign.center,
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                             ),
                                          //                           ],
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 5,
                                          //                         ),
                                          //                         Container(
                                          //                           height: height * 0.07,
                                          //                           child: //ReadMore
                                          //                           Text(
                                          //                             prefix,
                                          //                             overflow: TextOverflow.clip,
                                          //                             maxLines: 3,
                                          //                             style: TextStyle(fontSize: 12),
                                          //                           ),
                                          //                         ),
                                          //                         SizedBox(
                                          //                           height: 7.h,
                                          //                         ),
                                          //                         Text(
                                          //                           "${_multipleDevices[i].price.toString()} AED",
                                          //                           style: TextStyle(
                                          //                             fontSize: 28.sp,
                                          //                             fontWeight: FontWeight.w700,
                                          //                           ),
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 20.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Validity",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "$abc days",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "# of Devices",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_multipleDevices[i].devices.toString()}",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Speed upto",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${_multipleDevices[i].bandwidth.toString()}Mbps",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Divider(),
                                          //                 Container(
                                          //                   height:45,
                                          //                   //color:Colors.red,
                                          //                   child: Center(
                                          //                     child: CustomButton(
                                          //                       height: 40.h,
                                          //                       width: 140.w,
                                          //                       onPressed: () {
                                          //                         Navigator.push(
                                          //                             context,
                                          //                             MaterialPageRoute(
                                          //                                 builder: (context) => PaymentMethod(
                                          //                                   price: _multipleDevices[i]
                                          //                                       .price
                                          //                                       .toString(),
                                          //                                   id: _multipleDevices[i]
                                          //                                       .id
                                          //                                       .toString(),
                                          //                                 )));
                                          //                       },
                                          //                       text: AppLocalizations.of(context)!
                                          //                           .translate('buy_now')!,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //
                                          //               ],
                                          //             ),
                                          //           );
                                          //         },
                                          //       ),
                                          //     ],
                                          //   ):Text(' '),
                                          //
                                          // ]

                                          // affordableDevices.isNotEmpty?  Column(
                                          //   crossAxisAlignment: CrossAxisAlignment.start,
                                          //     children: [
                                          //       SizedBox(
                                          //         height: 20.h,
                                          //       ),
                                          //       Text(
                                          //         AppLocalizations.of(context)!
                                          //             .translate('network_device')!,
                                          //         style: TextStyle(
                                          //           fontWeight: FontWeight.w500,
                                          //           fontSize: 16.sp,
                                          //         ),
                                          //       ),
                                          //       SizedBox(
                                          //         height: 10.h,
                                          //       ),
                                          //       GridView.builder(
                                          //         addRepaintBoundaries: false,
                                          //         shrinkWrap: true,
                                          //         physics: NeverScrollableScrollPhysics(),
                                          //         itemCount: affordableDevices.length,
                                          //         gridDelegate:
                                          //         SliverGridDelegateWithFixedCrossAxisCount(
                                          //           mainAxisSpacing: (4.0.h),
                                          //           crossAxisSpacing: (4.0.w),
                                          //           childAspectRatio: 0.4 / 0.9,
                                          //           crossAxisCount: 2,
                                          //         ),
                                          //         itemBuilder: (contxt, i) {
                                          //           double val =
                                          //               affordableDevices[i].validity / 86400;
                                          //           print('this is value--$val');
                                          //           String abc = val.toStringAsFixed(0);
                                          //           return Card(
                                          //             elevation: 0,
                                          //             shape: RoundedRectangleBorder(
                                          //               side: BorderSide(
                                          //                 color: Colors.grey.shade300,
                                          //                 width: 1.w,
                                          //               ),
                                          //               borderRadius: BorderRadius.circular(10),
                                          //             ),
                                          //             child: Column(
                                          //               crossAxisAlignment:
                                          //               CrossAxisAlignment.start,
                                          //               children: [
                                          //                 Container(
                                          //                   width: double.infinity,
                                          //                   height: 170.h,
                                          //                   decoration: BoxDecoration(
                                          //                     color: Colors.pink.shade50,
                                          //                     borderRadius: BorderRadius.only(
                                          //                       topLeft: Radius.circular(10.r),
                                          //                       topRight: Radius.circular(10.r),
                                          //                     ),
                                          //                   ),
                                          //                   child: Padding(
                                          //                     padding: EdgeInsets.all(8.0.h),
                                          //                     child: Column(
                                          //                       crossAxisAlignment:
                                          //                       CrossAxisAlignment.start,
                                          //                       children: [
                                          //                         Container(
                                          //                           decoration: BoxDecoration(
                                          //                             gradient: LinearGradient(
                                          //                               colors: affordableDevices[i].name == "BLUE" ? [Color(0xFF5787E3), Color(0xFF5787E3),]
                                          //                                   : affordableDevices[i].name == "SILVER" ? [Color(0xFF3D3C3A), Color(0xFFC8C5BD),]
                                          //                                   : [Color(0xFFF19164), Color(0xFFF19164),],
                                          //                               begin:
                                          //                               const FractionalOffset(
                                          //                                   0.2, 0.0),
                                          //                               end: const FractionalOffset(
                                          //                                   1.1, 0.0),
                                          //                             ),
                                          //                             color: affordableDevices[i]
                                          //                                 .name ==
                                          //                                 "BLUE"
                                          //                                 ? Colors.blue
                                          //                                 : affordableDevices[i]
                                          //                                 .name ==
                                          //                                 "SILVER"
                                          //                                 ? Colors.grey
                                          //                                 : affordableDevices[i]
                                          //                                 .name ==
                                          //                                 "CRYSTAL"
                                          //                                 ? Colors.blue
                                          //                                 : Color(
                                          //                                 0xFFC8C5BD),
                                          //                             borderRadius:
                                          //                             BorderRadius.all(
                                          //                               Radius.circular(50.r),
                                          //                             ),
                                          //                           ),
                                          //                           height: 30.h,
                                          //                           width: 100.w,
                                          //                           child: Row(
                                          //                             mainAxisAlignment:
                                          //                             MainAxisAlignment.center,
                                          //                             crossAxisAlignment:
                                          //                             CrossAxisAlignment.center,
                                          //                             children: [
                                          //                               Image.asset(
                                          //                                 affordableDevices[i]
                                          //                                     .name ==
                                          //                                     "GOLD"
                                          //                                     ? "assets/images/crown.png"
                                          //                                     : affordableDevices[i]
                                          //                                     .name ==
                                          //                                     "PLATINUM"
                                          //                                     ? "assets/images/crown.png"
                                          //                                     : "assets/images/wifi_icon.png",
                                          //                                 color: Colors.white,
                                          //                                 height: 16.h,
                                          //                                 scale: 8,
                                          //                               ),
                                          //                               SizedBox(
                                          //                                 width: 5.w,
                                          //                               ),
                                          //                               Text(
                                          //                                 affordableDevices[i].name,
                                          //                                 style: TextStyle(
                                          //                                   color: Colors.white,
                                          //                                   fontWeight:
                                          //                                   FontWeight.w600,
                                          //                                   fontSize: 12.sp,
                                          //                                   height: 1.8,
                                          //                                 ),
                                          //                                 textAlign:
                                          //                                 TextAlign.center,
                                          //                               ),
                                          //                             ],
                                          //                           ),
                                          //                         ),
                                          //                         Container(
                                          //                           height: height * 0.12,
                                          //                           child: //ReadMore
                                          //                           Text(
                                          //                             affordableDevices[i]
                                          //                                 .description,
                                          //                             overflow:
                                          //                             TextOverflow.ellipsis,
                                          //                             maxLines: 4,
                                          //                           ),
                                          //                         ),
                                          //                         Text(
                                          //                           "${affordableDevices[i].price.toString()} AED",
                                          //                           style: TextStyle(
                                          //                             fontSize: 28.sp,
                                          //                             fontWeight: FontWeight.w700,
                                          //                           ),
                                          //                         )
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 20.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Validity",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "$abc days",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "# of Devices",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${affordableDevices[i].devices.toString()}",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(
                                          //                     left: 10.w,
                                          //                     right: 10.w,
                                          //                   ),
                                          //                   child: Row(
                                          //                     mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                     children: [
                                          //                       Text(
                                          //                         "Speed upto",
                                          //                         style: TextStyle(
                                          //                           color: Colors.grey.shade500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                       Text(
                                          //                         "${affordableDevices[i].bandwidth.toString()}Mbps",
                                          //                         style: TextStyle(
                                          //                           color: Colors.black,
                                          //                           fontWeight: FontWeight.w500,
                                          //                           fontSize: 12.sp,
                                          //                         ),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                 ),
                                          //                 SizedBox(
                                          //                   height: 10.h,
                                          //                 ),
                                          //                 Divider(),
                                          //                 Center(
                                          //                     child: CustomButton(
                                          //                       height: 40.h,
                                          //                       width: 140.w,
                                          //                       onPressed: () {
                                          //                         Navigator.push(
                                          //                             context,
                                          //                             MaterialPageRoute(
                                          //                                 builder: (context) =>
                                          //                                     PaymentMethod(
                                          //                                       price:
                                          //                                       affordableDevices[i]
                                          //                                           .price
                                          //                                           .toString(),
                                          //                                       id: affordableDevices[i]
                                          //                                           .id
                                          //                                           .toString(),
                                          //                                     )));
                                          //                       },
                                          //                       text: AppLocalizations.of(context)!
                                          //                           .translate('buy_now')!,
                                          //                     )
                                          //
                                          //                   // TextButton(
                                          //                   //   style: TextButton.styleFrom(
                                          //                   //     minimumSize: Size(140.w, 40.h),
                                          //                   //     backgroundColor: Colors.pink,
                                          //                   //     primary: Colors.white,
                                          //                   //   ),
                                          //                   //   onPressed: () {
                                          //                   //     Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentMethod(price: netWorkDevices[i].price.toString(), id: netWorkDevices[i].id.toString(),)));
                                          //                   //   },
                                          //                   //   child: Text(
                                          //                   //     AppLocalizations.of(context)!.translate('buy_now')!,
                                          //                   //   ),
                                          //                   // ),
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //           );
                                          //         },
                                          //       )
                                          //     ],
                                          //   ):Text(' ')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              )),
                  )
                : NoDataScreen(
                    title: AppLocalizations.of(context)!.translate('wifi')!,
                    desc: "Seems, there is no wifi packages",
                    buttontxt: "Get Wifi, Today!",
                    ontap: () async {
                      navigationService.navigateTo(HomeScreenRoute);
                    },
                  );
          })
        : NoInternet();
  }
}
