import 'dart:ui';
import 'package:b2connect_flutter/view/widgets/custom_buttons/gradiant_color_button.dart';
import 'package:b2connect_flutter/view/widgets/language_selection_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../model/services/util_service.dart';
import '../../model/utils/routes.dart';
import '../../view/widgets/progress_dialog.dart';
import '../../view/widgets/showOnWillPop.dart';
import '../../view_model/providers/auth_provider.dart';
import '../../view/widgets/column_scroll_view.dart';
import '../../model/utils/service_locator.dart';
import '../../model/services/storage_service.dart';
import '../../model/locale/app_localization.dart';
import '../../model/services/navigation_service.dart';


class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController _phnController = TextEditingController();
  String _phneNumberWcuntryCode = '';
  var _navigationService = locator<NavigationService>();
  //var storageService = locator<StorageService>();
  var _utilsService = locator<UtilService>();

  Color _txtFieldColor = Colors.transparent;
  String _ipAddress = '';
  String _macAddress = '';
  String? _validator;
  Color? _validateColor=Colors.green;

  @override
  void initState() {
    super.initState();
    _ipAddress = Provider.of<AuthProvider>(context, listen: false).getIpAddress;
    _macAddress =
        Provider.of<AuthProvider>(context, listen: false).getMacAddress;

    print('ip address from reset--$_ipAddress');
    print('mac address from reset--$_macAddress');
  }


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          showOnWillPop(context);
          return false;
        },
        child: ColumnScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 10.0,bottom: 10,top: 10),
                    //color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: (){
                            _navigationService.navigateTo(LoginScreenRoute);
                          },
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            color: Colors.black,
                            size: 25,
                          ),),

                        LanguageSelectionButton(),

                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('reset_password')!,
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              // Text(
                              //   "B2 Connect",
                              //   style: GoogleFonts.poppins(
                              //       fontSize: 30.sp,
                              //       letterSpacing: 1.5,
                              //       fontWeight: FontWeight.w600,
                              //       color: Colors.black),
                              // ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('reset_description')!,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade400),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('number')!,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    letterSpacing: 1,
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
                                      width: width * 0.25,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                      width: width * 0.03,
                                    ),

                                    Container(
                                      height: 30.h,
                                      width: width * 0.65,
                                      child: TextFormField(
                                        controller: _phnController,
                                        inputFormatters: [
                                          new LengthLimitingTextInputFormatter(
                                              9),
                                        ],

                                        onChanged: (value) {

                                          if(value.length > 9 || value.isEmpty || value.length < 9){
                                            setState(() {
                                              _validator='Wrong input';
                                              _validateColor=Colors.red;
                                            });

                                          }
                                          else{
                                            setState(() {
                                              _validator='Looks Good';
                                              _validateColor=Colors.green;
                                              if (value.length == 9) { //10 is the length of the phone number you're allowing
                                                FocusScope.of(context).requestFocus(FocusNode());
                                              }
                                            });
                                          }

                                          _phneNumberWcuntryCode = '971$value';
                                          print('input number-$value');

                                          if (_phnController.text.isEmpty) {
                                            print("if");
                                            setState(() {
                                              _txtFieldColor =
                                                  Colors.transparent;
                                            });
                                          } else if (_phnController.text.length <
                                              9) {
                                            print("else if");
                                            setState(() {
                                              _txtFieldColor = Colors.red;
                                            });
                                          } else {
                                            print("else");
                                            setState(() {
                                              _txtFieldColor = Colors.green;
                                            });
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        // TextInputType.numberWithOptions(
                                        //   signed: true, decimal: true),

                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 5.0,
                                            horizontal: 20,
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .translate('numberDigits')!,
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13.h,
                                          ),
                                          filled: true,
                                          suffixIcon:
                                              _phnController.value.text.isEmpty
                                                  ? Text(' ')
                                                  : GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _phnController.clear();
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.clear,
                                                        color: Colors.black,
                                                      )),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _validator!=null?  Text(
                                    '$_validator',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.w600,
                                        color: _validateColor),
                                  ):Text(' '),


                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: Column(
                    children: [

                      CustomButton(
                        onPressed: ()async{
                          print('method is called');
                          if (_phnController.text.length > 9 || _phnController.text.isEmpty || _phnController.text.length < 9) {
                            //utilsService.showToast('Please Enter Correct Phone Number');
                            setState(() {
                              _validator='Wrong input';
                              _validateColor=Colors.red;
                            });

                          } else {

                            var connectivityResult = await (Connectivity().checkConnectivity());
                            if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
                            {
                              Provider.of<AuthProvider>(context, listen: false).savePhneNumber(_phneNumberWcuntryCode);
                              await Provider.of<AuthProvider>(context, listen: false).calllogin(_phneNumberWcuntryCode, _ipAddress, _macAddress);

                            }else{
                              _utilsService.showToast("Sorry! but you don't seem to connected to any internet connection");
                            }


                          }
                        },
                        text:  AppLocalizations.of(context)!
                            .translate('reset_password')!,
                        height: height*0.07,
                        width: double.infinity,
                      ),

                      SizedBox(
                        height: 10.h,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


