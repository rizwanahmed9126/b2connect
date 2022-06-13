import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../model/services/navigation_service.dart';
import '../../model/services/storage_service.dart';
import '../../model/utils/service_locator.dart';

class NotificationScreen extends StatefulWidget {
  final String? title;
  final String? description;
  final String? dateTime;
  const NotificationScreen(
      {Key? key, this.title, this.description, this.dateTime})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var _navigationService = locator<NavigationService>();
  //var storageService = locator<StorageService>();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15.h),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.030.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigationService.closeScreen();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: height * 0.035.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.040.h,
                ),
                Text(
                  widget.title!,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      // height: height*0.12,
                      width: width,
                      //color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.045,
                              width: height * 0.045,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFEBF2),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.email,
                                  color: Color.fromRGBO(197, 109, 222, 1),
                                  size: 11,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            Column(
                              children: [
                                Container(
                                    width: width * 0.65,
                                    child: Text(
                                      "${widget.description!}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 12),
                                    )),
                                SizedBox(
                                  height: 7.h,
                                ),
                                Container(
                                    width: width * 0.65,
                                    child: Text(
                                      widget.dateTime!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    )),
                              ],
                            )
                          ],
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
    );
  }
}
