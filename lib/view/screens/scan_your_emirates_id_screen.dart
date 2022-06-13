import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/view/widgets/appbar_with_back_icon_and_language.dart';
import 'package:b2connect_flutter/view/widgets/custom_buttons/gradiant_color_button.dart';
import 'package:b2connect_flutter/view_model/providers/scanner_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../model/services/navigation_service.dart';
import '../../model/services/storage_service.dart';
import '../../model/utils/service_locator.dart';
import '../../view/screens/scan_screen.dart';
import '../../view/widgets/indicator.dart';

class ScanYourEmiratesIDScreen extends StatefulWidget {
  @override
  _ScanYourEmiratesIDScreenState createState() =>
      _ScanYourEmiratesIDScreenState();
}

class _ScanYourEmiratesIDScreenState extends State<ScanYourEmiratesIDScreen> {
  //var navigationService = locator<NavigationService>();
  //var storageService = locator<StorageService>();
  var _firstCamera;
  //var scanId;

  // ignore: unused_field
  //int _current = 0;
  //List<int> listIndex = [0];

  // var locale;


  // CarouselController _controller = CarouselController();

  void initState() {
    super.initState();
    /*readCamera();*/
  }

  @override
  Widget build(BuildContext context) {
     final double height = MediaQuery.of(context).size.height;
     final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBarWithBackIconAndLanguage(
          onTapIcon: () {
            Navigator.pop(context);
          },
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(15.h),
                child: Column(
                  children: [
                    IndicatorWidget("1"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          AppLocalizations.of(context)!.translate('scan_your')!,
                          style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          AppLocalizations.of(context)!.translate('please_scan')!,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                              height: 1.4),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height*0.05,
                    ),
                    Image.asset(
                      "assets/images/cardscan.png",
                      width: width,
                      height: height*0.35,

                      // width: 350.0.w,
                      // height: 250.0.h,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  height: 50.h,
                  width: double.infinity,
                  onPressed: ()async{
                    await Provider.of<ScannerProvider>(context, listen: false)
                        .setCardFace(1);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) =>
                        TakePictureScreen(/*camera: _firstCamera*/)));
                  },
                  text: AppLocalizations.of(context)!.translate('continue')!,
                ),
              ),
              //SizedBox(height: 5,)
              // Container(
              //   padding: EdgeInsets.only(right: 10.w, left: 10.w),
              //   width: double.infinity,
              //   height: 50.h,
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       await Provider.of<ScannerProvider>(context, listen: false)
              //           .setScanId(1);
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>
              //                 TakePictureScreen(camera: firstCamera)),
              //       ); /*navigationService.navigateTo(ScanScreenRoute);*/
              //     },
              //     style: ElevatedButton.styleFrom(
              //       elevation: 0,
              //       textStyle:
              //           TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              //       shape: new RoundedRectangleBorder(
              //         borderRadius: new BorderRadius.circular(10.0),
              //       ),
              //       primary: Theme.of(context).primaryColor,
              //     ),
              //     child: new Text(
              //       "Continue",
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 16.sp,
              //           fontWeight: FontWeight.w600,
              //           letterSpacing: 1),
              //     ),
              //   ),
              // ),

            ]));
  }

/*  Future<void> readCamera() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    var cameras = await availableCameras();
    _firstCamera = cameras.first;
  }*/
}

/*
void _settingModalBottomSheet(context) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return ChangeLanguageBottomSheet();
      });
}
*/
