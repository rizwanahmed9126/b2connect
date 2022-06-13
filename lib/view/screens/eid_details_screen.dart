import 'package:b2connect_flutter/view/widgets/appbar_with_back_icon_and_language.dart';
import 'package:b2connect_flutter/view/widgets/custom_buttons/gradiant_color_button.dart';
import 'package:b2connect_flutter/view/widgets/custom_buttons/tinted_color_button.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view_model/providers/scanner_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EidDetailsScreen extends StatefulWidget {
  const EidDetailsScreen() : super();

  @override
  _EidDetailsScreenState createState() => _EidDetailsScreenState();
}

class _EidDetailsScreenState extends State<EidDetailsScreen> {
  late TextEditingController _nationalityController;
  late TextEditingController _genderController;
  late MaskedTextController _birthDateController;
  late MaskedTextController _expiryDateController;

  /*late TextEditingController _birthDateController;
  late TextEditingController _expiryDateController;*/



  @override
  void initState() {
    super.initState();
    _nationalityController = new TextEditingController(text: '${Provider.of<ScannerProvider>(context, listen: false).userEmiratesData.emiratesNationality}');
    _genderController = new TextEditingController(text: '${Provider.of<ScannerProvider>(context, listen: false).userEmiratesData.emiratesGender}');
    _birthDateController = MaskedTextController(
        mask: '00/00/0000', text: '${Provider.of<ScannerProvider>(context, listen: false).userEmiratesData.emiratesBirthday}');
   //  _birthDateController = new TextEditingController(text: '${Provider.of<ScannerProvider>(context, listen: false).userEmiratesData.emiratesBirthday}');
    _expiryDateController = MaskedTextController(
        mask: '00/00/0000', text: '${Provider.of<ScannerProvider>(context, listen: false).userEmiratesData.emiratesExpiry}');
   // _expiryDateController = new TextEditingController(text: '${Provider.of<ScannerProvider>(context, listen: false).userEmiratesData.emiratesExpiry}');

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(builder: (context, i, _) {
      return Scaffold(
        appBar: AppBarWithBackIconAndLanguage(
          onTapIcon: () {
            var count = 0;
            Navigator.popUntil(context, (route) {
              i.setScanBusy(true);
              i.setCardType(1);
              i.setCardFace(1);
              i.controller!.stopImageStream();

              return count++ == 2;
            });
          },
        ),
        body: WillPopScope(

          onWillPop: () {
            var count = 0;
            Navigator.popUntil(context, (route) {
              i.setScanBusy(true);
              i.setCardType(1);
              i.setCardFace(1);
              i.controller!.stopImageStream();

              return count++ == 2;
            });          return Future.value(false);
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "Confirm Your Emirates Card Details",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Lexend',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    thickness: 1,
                    height: 2,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Name: ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Lexend',
                              fontSize: 18,
                            ),
                          ),
                          Flexible(
                            child: Container(
                              child: Text(
                                '${i.userEmiratesData.emiratesName}',
                                /*overflow:  TextOverflow.ellipsis,
                            maxLines: 2,*/
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Lexend',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'Emirates Id: ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Lexend',
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${i.userEmiratesData.emiratesId}',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Lexend',
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'Nationality: ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Lexend',
                              fontSize: 18,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _nationalityController,
                              /*'${i.userEmiratesData.emiratesNationality}'*/
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit,size: 14.h,color: Theme.of(context).primaryColor,),
                                // prefixIcon: Icon(Icons.done),
                                hintText: "Dubai",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                                //border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Lexend',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                     /* SizedBox(
                        height: 15,
                      ),*/
                      Row(
                        children: [
                          Text(
                            'Gender: ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Lexend',
                              fontSize: 18,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _genderController,
                              /*'${i.userEmiratesData.emiratesNationality}'*/
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit,size: 14.h, color: Theme.of(context).primaryColor,),
                                // prefixIcon: Icon(Icons.done),
                                hintText: "Male",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                                //border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Lexend',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                     /* SizedBox(
                        height: 15,
                      ),*/
                      Row(
                        children: [
                          Text(
                            'Date of Birth: ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Lexend',
                              fontSize: 18,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _birthDateController,
                              // '${i.userEmiratesData.emiratesNationality}'
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit,size: 14.h, color: Theme.of(context).primaryColor,),
                                // prefixIcon: Icon(Icons.done),
                                hintText: "Date/Month/Year",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                                //border: InputBorder.none,
                              ),
                              // '${i.userEmiratesData.emiratesBirthday}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Lexend',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                   /*   SizedBox(
                        height: 10.h,
                      ),*/
                      Row(
                        children: [
                          Text(
                            'Expiry Date: ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Lexend',
                              fontSize: 18,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _expiryDateController,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit,size: 14.h, color: Theme.of(context).primaryColor,),
                                // prefixIcon: Icon(Icons.done),
                                hintText: "Date/Month/Year",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                                //border: InputBorder.none,
                              ),
                            //  '${i.userEmiratesData.emiratesExpiry}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Lexend',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CustomButton2(
                                /*   height: 50,
                            width: 500,*/
                                txt: 'Re-Scan',
                                onTap: () async {
                                  i.controller!.stopImageStream();
                                  i.setScanBusy(false);
                                  i.setCardType(1);
                                  i.setCardFace(1);
                                  //  EasyLoading.show(status: 'Saving Emirates ID...');
                                  var count = 0;
/*
                              await Provider.of<ScannerProvider>(context, listen: false)
                                  .sendEmiratesData(context);
                              await Provider.of<AuthProvider>(context, listen: false)
                                  .callUserInfo();*/
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomButton(
                                height: 62,
                                width: 500,
                                text: 'Submit',
                                onPressed: () async {
                                  i.controller!.stopImageStream();
                                  i.setScanBusy(false);
                                  i.setCardType(1);
                                  i.setCardFace(1);
                                  i.userEmiratesData.emiratesExpiry = _expiryDateController.text;
                                  i.userEmiratesData.emiratesBirthday = _birthDateController.text;
                                  i.userEmiratesData.emiratesGender = _genderController.text;
                                  i.userEmiratesData.emiratesNationality = _nationalityController.text;
                                  EasyLoading.show(status: 'Saving Emirates ID...');
                                  await Provider.of<ScannerProvider>(context, listen: false)
                                      .sendEmiratesData(context);

                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
