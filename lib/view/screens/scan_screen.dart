import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/services/util_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../model/services/navigation_service.dart';
import '../../model/utils/service_locator.dart';
import '../../view/widgets/border_painter_widget.dart';
import '../../view/widgets/clip_widget.dart';
import '../../view/widgets/indicator.dart';
import '../../view_model/providers/scanner_provider.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen(/*{
    required this.camera,
  }*/
      )
      : super();

  /*final CameraDescription camera;*/

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  //var navigationService = locator<NavigationService>();
  late CameraController _controller;
  late Future<CameraController> _initializeControllerFuture;
  //var _scanId;
  CameraImage? image;
  //Timer? timer;
  var scale;

//  bool _isScanBusy = false;
  var utilService = locator<UtilService>();
/*
  final _imagePicker = ImagePicker();
*/

  /*late final _size;*/

  @override
  initState() {
    super.initState();
    _initializeControllerFuture = startCamera();
    startStreaming();

   /* WidgetsBinding.instance?.addPostFrameCallback((_) {
      _size = MediaQuery.of(context).size;

    });*/
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    //_controller.stopImageStream();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ScannerProvider>(
        builder: (context, i, _) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<CameraController>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SafeArea(
              child: Stack(
                children: [
                Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: CameraPreview(_controller),
              ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: i.cardFace == 1 && i.cardType == 1 ? Text('Scan Front of Your Emirates ID',style: TextStyle(color: Colors.white, fontSize: 18),):
                      i.cardFace == 2 && i.cardType == 2 ? Text('Flip Your Emirates ID',style: TextStyle(color: Colors.white, fontSize: 18),):
                      Text('Processing ....',style: TextStyle(color: Colors.white, fontSize: 18),),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      IndicatorWidget("2"),
                      SizedBox(
                        height: 10.h,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            i.setCardType(1);
                            i.setCardFace(1);
                            i.setScanBusy(false);
                            i.controller!.stopImageStream();
                          },
                          icon: const Icon(Icons.arrow_back_outlined,
                              color: Colors.white, size: 24),
                        ),
                      ),

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: i.cardFace == 1
                              ? Text(
                                  AppLocalizations.of(context)!
                                      .translate('front')!,
                                  style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                )
                              : Text(
                                  AppLocalizations.of(context)!
                                      .translate('back_')!,
                                  style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.translate('scan_desc')!,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.4),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            );
            // CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );});
  }

  /*Widget cameraView() {
    return Stack(
      children: [
        Center(
          child:
              ClipPath(clipper: Clip(_size), child: CameraPreview(_controller)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.5),
          child: CustomPaint(
            painter: BorderPainter(),
            child: Container(
              height: _size.height / 3.7,
            ),
          ),
        ),
      ],
    );
  }*/

  Future<CameraController> startCamera() async {
    var cameras = await availableCameras();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.veryHigh ,
      enableAudio: false,
    );
    await _controller.initialize();
    await Provider.of<ScannerProvider>(context, listen: false).setController(_controller);
   // await  Provider.of<ScannerProvider>(context, listen: false).setContext(context);
    scale = 1 / (_controller.value.aspectRatio * MediaQuery.of(context).size.aspectRatio);



    // takePicture();
    /* });*/
    return _controller;
  }

  void startStreaming() {
    Future.delayed(Duration(seconds: 3),(){
      _controller.startImageStream((image) {

        if (Provider.of<ScannerProvider>(context, listen: false).isScanBusy) {
          // print("1.5 -------- isScanBusy, skipping...");
          return;
        }

        Provider.of<ScannerProvider>(context, listen: false).checkCardFaceAndType(image);
        /*await Provider.of<ScannerProvider>(context, listen: false)
          .scanImage(visionImage);*/
      });
    });
  }

  /*Future<void> takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      _cropImage(context, image.path, image.path, 10, 20);
    } catch (e) {
      print(e);
    }
  }*/

  /*Future<void> _cropImage(
      context, String filePath, String destPath, int x, int y) async {
    img.Image _image = decodeJpg(await File(filePath).readAsBytes());
    img.Image _cropped =
        copyCrop(_image, x, y, _image.width, _image.width ~/ 1.5);
    await File(destPath).writeAsBytes(encodeJpg(_cropped));

    if (Platform.isAndroid || Platform.isIOS) {
      await Provider.of<ScannerProvider>(context, listen: false)
          .scanImage(destPath);
    }
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CameraSliderScreen(destPath, _size)))
        .then((value) {
      setState(() {
        _scanId = Provider.of<ScannerProvider>(context, listen: false).scanId;
      });
    });
    EasyLoading.dismiss();
  }*/




}
