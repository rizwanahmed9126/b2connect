import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/models/offers_models/product_details_model.dart';
import 'package:b2connect_flutter/model/services/util_service.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:b2connect_flutter/view/screens/service_provider_list_screen.dart';
import 'package:b2connect_flutter/view/screens/view_all_offers_screen.dart';
import 'package:b2connect_flutter/view/screens/view_all_service_screen.dart';
import 'package:b2connect_flutter/view/widgets/appBar_with_cart_notification_widget.dart';
import 'package:b2connect_flutter/view/widgets/appbar_with_back_icon_and_language.dart';
import 'package:b2connect_flutter/view/widgets/custom_buttons/gradiant_color_button.dart';
import 'package:b2connect_flutter/view/widgets/service_provider_items_widget.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:b2connect_flutter/view_model/providers/offers_provider.dart';
import 'package:b2connect_flutter/view_model/providers/pay_by_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EditNumberTopUpScreen extends StatefulWidget {

/*
  final ProductDetailsModel? _productDetailsData;
*/
  const EditNumberTopUpScreen(/*this._productDetailsData*/) : super();


  @override
  _EditNumberTopUpScreenState createState() => _EditNumberTopUpScreenState();
}


class _EditNumberTopUpScreenState extends State<EditNumberTopUpScreen> {
  final TextEditingController _phnController = TextEditingController();
  Color _txtFieldColor = Colors.transparent;
  String? _validator;
  Color? _validateColor = Colors.green;
  String _phneNumberWcuntryCode = '';
  var utilsService = locator<UtilService>();


  List<dynamic> _serviceProviderList = [
    {'name': 'Du', 'color': '4284513675', 'type': 'Prepaid', 'logo': 'assets/images/du.png'}
    , {'name': 'Etisalat', 'color': '4294930176', 'type': 'Prepaid', 'logo': 'assets/images/etisalat.png'}
    , {'name': 'Virgin', 'color': '4294930176', 'type': 'eVoucher', 'logo': 'assets/images/virgin.png'}
    , {'name': 'Swyp', 'color': '4294930176', 'type': 'Prepaid', 'logo': 'assets/images/swyp.png'}
  ];

  @override
  void initState() {
    _phnController.text = Provider.of<AuthProvider>(context, listen: false).userInfoData!.uid.toString().substring(3);
    if(_phnController.text.isNotEmpty){
      _validator = 'Looks Good';
    Provider.of<PayByProvider>(context, listen: false).topUpMobileNumber = _phnController.text;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Consumer<PayByProvider>(builder: (context, i, _) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar:AppBarWithCartNotificationWidget(
          title: 'Top-Up',
          onTapIcon: () {
            navigationService.closeScreen();
          },
        ),/* AppBarWithBackIconAndLanguage(
          onTapIcon: () {
            Navigator.pop(context);
            i.offerItemsOrder.clear();
          },
        ),*/
        body: WillPopScope(

          onWillPop: () {
            Navigator.pop(context);
            return Future.value(false);
            },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mobile Top-Up',
                          style: TextStyle(
                              fontSize: 30.sp,
                              //letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      /*  Text(
                          "B2Connect",
                          style: TextStyle(
                              fontSize: 30.sp,
                              //letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),*/
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Enter valid & active UAE Mobile number to recharge. Ex: 5xxxxxxxx',
                          style: TextStyle(
                              fontSize: 14.sp,
                              //letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF757575)),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: (){
                              navigationService.navigateTo(TopUpIntroScreenRoute);
                            },
                            child: Text(
                              'How to recharge ?',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  //letterSpacing: 1,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Text(
                          AppLocalizations.of(context)!.translate('number')!,
                          style: TextStyle(
                              fontSize: 16.sp,
                              //letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          //color: Colors.red,
                          //padding: EdgeInsets.only(left: 5, right: 5),
                          //
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 30.h,
                                //width: width * 0.25,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: new BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 22.h,
                                      width: 22.w,
                                      child: Image.asset(
                                          'assets/images/united-arab-emirates.png'),
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Text(
                                      '+971',
                                      //style: GoogleFonts.poppins(),
                                    ),
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Icon(
                                        Icons.chevron_left,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                height: 30.h,
                                width: width * 0.65,
                                child: TextFormField(
                                  controller: _phnController,
                                  textInputAction: TextInputAction.done,
                                  //autofocus: true,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(9),
                                  ],

                                  onChanged: (value) {
                                    checkPhoneNumber(value , i);

                                  },
                                  keyboardType: TextInputType.number,
                                  // keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                  // TextInputType.numberWithOptions(
                                  //   signed: true, decimal: true),

                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: 20,
                                    ),

                                    suffixIcon: _phnController.value.text.isEmpty
                                        ? Text(' ')
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _phnController.clear();
                                                _validator = 'Wrong Input';
                                                _validateColor = Colors.red;
                                              });
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              color: Colors.black,
                                            )),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelText: '5xxxxxxxx',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.sp,
                                    ),
                                    // hintText: AppLocalizations.of(context)!.translate('numberDigits')!,
                                    // hintStyle: TextStyle(
                                    //   color: Colors.black,
                                    //   fontSize: 12.h,
                                    // ),
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: _txtFieldColor,
                                        width: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _validator != null
                                ? Text(
                                    '$_validator',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.w600,
                                        color: _validateColor),
                                  )
                                : Text(' '),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Service Providers',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ServiceProviderListScreen(
                                              _serviceProviderList, 'Service Providers', validator: _validator == null? 'Wrong Input' : _validator)));
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'View All',
                                  style: TextStyle(
                                    //fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      color: Theme.of(context).primaryColor
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            // margin: const EdgeInsets.symmetric(vertical: 20.0),
                            // height: 200,
                            //color: Colors.amber,
                            width: double.infinity,
                            child: GridView.builder(
                              // scrollDirection: Axis.horizontal,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _serviceProviderList.length < 4? _serviceProviderList.length : 4,
                              itemBuilder: (BuildContext context, int index) {
                                return ServiceProviderItemsWidget(index,_serviceProviderList,validator: _validator == null? 'Wrong Input' : _validator);
                              }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              childAspectRatio: 0.95.w,
                              //ScreenSize.productCardWidth / ScreenSize.productCardHeight,
                              crossAxisCount: 2,
                            ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /*Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                      children: [
                        CustomButton(
                          onPressed: () async {
                            if (_phnController.text.length > 9 ||
                                _phnController.text.isEmpty ||
                                _phnController.text.length < 9) {
                              setState(() {
                                _validator = 'Wrong input';
                                _validateColor = Colors.red;
                              });
                            } else {
                              EasyLoading.show(status: 'Please Wait...');
                              i.topUpMobileNumber = _phnController.text;
                             *//* payNow();*//*

                               await getOfferDetail(460).then((value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewAllOffersScreen(
                                            categoryId: 460,
                                          )),
                                );
                              });
                              *//* var connectivityResult =
                                  await (Connectivity().checkConnectivity());*//*
                              *//* if (connectivityResult == ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi) {
                                Provider.of<AuthProvider>(context, listen: false)
                                    .savePhneNumber(_phneNumberWcuntryCode);
                                await Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .calllogin(_phneNumberWcuntryCode, ipAddress,
                                        macAddress);
                              } else {
                                utilsService.showToast(
                                    "Sorry! but you don't seem to connected to any internet connection");
                              }*//*
                            }
                          },
                          text: AppLocalizations.of(context)!.translate('proceed')!,
                          height: height * 0.07,
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: 10.h,
                        )
                      ],
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      );
    });
  }

 /* Future<void> payNow() async {
    EasyLoading.show(
        status: AppLocalizations.of(context)!.translate('please_wait')!);
    await Provider.of<PayByProvider>(context, listen: false).getPayByDeviceId();
    await Provider.of<PayByProvider>(context, listen: false)
        .addServicesToOfferItems(widget._productDetailsData!.offer.id);
    await Provider.of<PayByProvider>(context, listen: false)
        .payByServiceOrder(context);
  }*/


  void checkPhoneNumber(String value, PayByProvider editNumber, ) {

    editNumber.topUpMobileNumber = _phnController.text;

    if (value.isEmpty || value.length < 9) {
           setState(() {
        _validator = 'Wrong Input';
        _validateColor = Colors.red;
        _txtFieldColor = Colors.red;

      });
    } else {
      setState(() {
        _validator = "Looks Good";
        _validateColor = Colors.green;
        _txtFieldColor = Colors.green;

        if (value.length == 9) {
          FocusScope.of(context)
              .requestFocus(FocusNode());
         // _phneNumberWcuntryCode = '971$value';
         // editNumber.topUpMobileNumber = value;
        }
      });
    }
   /* _phneNumberWcuntryCode = '971$value';
    print('input number-$value');
    if (_phnController.text.isEmpty) {
      setState(() {
        _txtFieldColor = Colors.transparent;
      });
    } else if (_phnController.text.length < 9) {
      print("else if");
      setState(() {
        _txtFieldColor = Colors.red;
      });
    } else {
      print("else");
      setState(() {
        _txtFieldColor = Colors.green;
      });
    }*/
  }
}
