import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/models/userEmiratesData.dart';
import 'package:b2connect_flutter/model/models/userinfo_model.dart';
import 'package:b2connect_flutter/model/services/navigation_service.dart';
import 'package:b2connect_flutter/model/services/storage_service.dart';
import 'package:b2connect_flutter/model/services/util_service.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:b2connect_flutter/view/screens/view_all_offers_screen.dart';
import 'package:b2connect_flutter/view/widgets/csc_picker_widget.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

//import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

import 'custom_buttons/button_with_loader.dart';

class UserInformationWidget extends StatefulWidget {
  final bool edit;

  //final UserInfoModel userInfoData;

  const UserInformationWidget(this.edit, /*this.userInfoData,*/ {Key? key})
      : super(key: key);

  @override
  _UserInformationWidgetState createState() => _UserInformationWidgetState();
}

class _UserInformationWidgetState extends State<UserInformationWidget> {
  late UserEmiratesData user;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  bool checkbox1 = false;

  //bool _fieldEdit = false;

  // ignore: unused_field
  bool _showPassword = false;
  String initialCountry = 'NG';

  //PhoneNumber number = PhoneNumber(isoCode: 'NG');
  var navigationService = locator<NavigationService>();
  var storageService = locator<StorageService>();
  UtilService utilsService = locator<UtilService>();
  DateTime selectedFromDate = DateTime.now();
  late MaskedTextController phoneNumberTextMask;

  @override
  void initState() {
    super.initState();
  }

  @override
  // TextEditingController emailController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  TextEditingController buildNumberController = TextEditingController();
  TextEditingController buildNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Consumer<AuthProvider>(builder: (context, i, _) {
        phoneNumberTextMask = MaskedTextController(
            mask: '+000 00 0000000', text: i.userInfoData!.uid.toString());
        return Container(
          child: Column(
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('number')!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                       fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: sx(500),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: TextField(
                          enabled: false,
                          controller: phoneNumberTextMask,
                          decoration: InputDecoration(
                              //hintText: 'e.g. 61101-1234524-1',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sy(10),
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('wifi_acct_no')!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: sx(500),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: TextField(
                          enabled: false,
                          controller: phoneNumberTextMask,
                          decoration: InputDecoration(
                              //hintText: 'e.g. 61101-1234524-1',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sy(12),
                    ),
                    /* Text(
                      AppLocalizations.of(context)!.translate('email_add')!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: sy(11),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      width: sx(500),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        readOnly: widget.edit == true ? false : true,
                        controller: emailController,
                        autocorrect: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15.0,
                          ),
                          hintText: i.userInfoData!.userEmail.toString() == ''
                              ? 'N/A'
                              : i.userInfoData!.userEmail.toString(),
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                            fontSize: sy(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sy(10),
                    ),*/
                    Text(
                      AppLocalizations.of(context)!.translate('room_no')!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: sx(500),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: roomController,
                        readOnly: widget.edit == true ? false : true,
                        autocorrect: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15.0,
                          ),
                          hintText: i.userInfoData!.room.toString() == ''
                              ? 'N/A'
                              : i.userInfoData!.room.toString(),
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w200,
                            fontSize: sy(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sy(10),
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('building_no')!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: sx(500),
                      child: TextFormField(
                        readOnly: widget.edit == true ? false : true,
                        keyboardType: TextInputType.emailAddress,
                        controller: buildNumberController,
                        autocorrect: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15.0,
                          ),
                          hintText: i.userInfoData!.property.toString() == ''
                              ? 'N/A'
                              : i.userInfoData!.property.toString(),
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w200,
                            fontSize: sy(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sy(10),
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('building_name')!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: sx(500),
                      child: TextFormField(
                        readOnly: widget.edit == true ? false : true,
                        keyboardType: TextInputType.text,
                        controller: buildNameController,
                        autocorrect: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15.0,
                          ),
                          hintText: i.userInfoData!.location.toString() == ''
                              ? 'N/A'
                              : i.userInfoData!.location.toString(),
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w200,
                            fontSize: sy(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sy(10),
                    ),
                    /*widget.edit == true
                      ? CSPickerWidget(
                          showStates: true,
                          showCities: true,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          disabledDropdownDecoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          selectedItemStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          dropdownHeadingStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          dropdownItemStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          dropdownDialogRadius: 10.0,
                          searchBarRadius: 20.0,
                          onStateChanged: (value) {
                            setState(() {
                              stateValue = value;
                            });
                          },
                          onCityChanged: (value) {
                            setState(() {
                              cityValue = value;
                            });
                          },
                          onCountryChanged: (value) {
                            setState(() {
                              countryValue = value;
                            });
                          },
                        )
                      :*/
                    /*Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.translate('country')!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: sy(11),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          width: sx(500),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
                            child: Text(
                              'United Arab Emirates',
                              style: TextStyle(
                                fontSize: sy(8),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),*/
                    Visibility(
                      visible: widget.edit == true ? true : false,
                      child: Container(
                       // width: double.infinity,
                       // height: 40.h,
                        child: ButtonWithLoader(
                          // showLoader: _showLoader,
                         height: height*0.07,
                         width: double.infinity,
                          disableColor: roomController.text.isNotEmpty ||
                                  buildNumberController.text.isNotEmpty ||
                                  buildNameController.text.isNotEmpty
                              ? null
                              : "showColor",
                          text: AppLocalizations.of(context)!
                              .translate('done')!,
                          onPressed: () async {
                            if (buildNumberController.text.isNotEmpty ||
                                roomController.text.isNotEmpty ||
                                buildNameController.text.isNotEmpty) {
                              var _roomNumber = roomController.text.isEmpty
                                  ? i.userInfoData!.room.toString()
                                  : roomController.text;
                              var _buildingNumber =
                                  buildNumberController.text.isEmpty
                                      ? i.userInfoData!.location.toString()
                                      : buildNumberController.text;
                              var _buildingName =
                                  buildNameController.text.isEmpty
                                      ? i.userInfoData!.property.toString()
                                      : buildNameController.text;

                              EasyLoading.show(
                                  status: AppLocalizations.of(context)!
                                      .translate('please_wait')!);
                              await Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .updateUserInfo(context, _buildingName,
                                      _buildingNumber, _roomNumber, 0, '');
                              await Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .callUserInfo();
                              Navigator.pop(context);
                              EasyLoading.dismiss();
                            } else {
                              //  utilsService.showToast('Already Updated');
                              EasyLoading.dismiss();
                              //EasyLoading.show(status: 'Al ready Upto Date');
                            }
                          },
                        ),

                        /*ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              textStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(6.0),
                              ),
                              primary: roomController.text.isNotEmpty ||
                                      buildNumberController.text.isNotEmpty ||
                                      buildNameController.text.isNotEmpty
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            onPressed: () async {
                              if (buildNumberController.text.isNotEmpty ||
                                  roomController.text.isNotEmpty ||
                                  buildNameController.text.isNotEmpty) {
                                var _roomNumber = roomController.text.isEmpty
                                    ? i.userInfoData!.room.toString()
                                    : roomController.text;
                                var _buildingNumber =
                                    buildNumberController.text.isEmpty
                                        ? i.userInfoData!.location.toString()
                                        : buildNumberController.text;
                                var _buildingName =
                                    buildNameController.text.isEmpty
                                        ? i.userInfoData!.property.toString()
                                        : buildNameController.text;

                                EasyLoading.show(status: AppLocalizations.of(context)!.translate('please_wait')!);
                                await Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .updateUserInfo(
                                        context,
                                        _buildingName,
                                        _buildingNumber,
                                        _roomNumber,0,'');
                                await Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .callUserInfo();
                                Navigator.pop(context);
                                EasyLoading.dismiss();
                              } else {
                                //  utilsService.showToast('Already Updated');
                                EasyLoading.dismiss();
                                //EasyLoading.show(status: 'Al ready Upto Date');
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.translate('done')!)),*/
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
    });
  }
}
