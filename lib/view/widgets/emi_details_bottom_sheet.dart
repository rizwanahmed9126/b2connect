import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<Map<String, dynamic>> _emiByList = [
  {"id": "1st Due", "title": "Paid"},
  {"id": "2nd Due", "title": "Pending"},
  {"id": "3rd Due", "title": "Not Paid"},
  {"id": "4th Due", "title": "Not Paid"},
  {"id": "5th Due", "title": "Not Paid"},
  {"id": "6th Due", "title": "Not Paid"},
  {"id": "7th Due", "title": "Not Paid"},
  {"id": "8th Due", "title": "Not Paid"},
  {"id": "9th Due", "title": "Not Paid"},
];

class EmiDetailsBottomSheet extends StatelessWidget {
  const EmiDetailsBottomSheet() : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            //mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'EMI Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.h),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.centerRight, child: Icon(Icons.clear)),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 320.h,
            padding: EdgeInsets.all(15.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Expanded(
              child: ListView.builder(
                physics: ScrollPhysics(),
                itemCount: _emiByList.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext, index) {
                  return Container(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _emiByList[index] == _emiByList.last?
                          Container(
                            width: 15.w,
                            height: 15.h,
                            decoration: BoxDecoration(
                                color: _emiByList[index]['title'] == 'Paid' ? Colors.lightGreen : _emiByList[index]['title'] == 'Pending'? Colors.deepOrange
                                    : Colors.grey.shade300,
                                shape: BoxShape.rectangle,borderRadius: BorderRadius.all(Radius.circular(2.h))),
                          ):
                          Column(
                            children: [
                              Container(
                                width: 15.w,
                                height: 15.h,
                                decoration: BoxDecoration(
                                    color: _emiByList[index]['title'] == 'Paid' ? Colors.lightGreen : _emiByList[index]['title'] == 'Pending'? Colors.deepOrange
                                    : Colors.grey.shade300,
                                    shape: BoxShape.circle),
                              ),
                              Container(
                                width: 5.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle),
                              ),
                              Container(
                                width: 5.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle),
                              ),
                              Container(
                                width: 5.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle),
                              ),
                              Container(
                                width: 5.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle),
                              ),
                              Container(
                                width: 5.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle),
                              ),
                              Container(
                                width: 5.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '1st Due | ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 14.sp),
                                    ),
                                    Text('${_emiByList[index]['title']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: _emiByList[index]['title'] == 'Paid' ? Colors.lightGreen : _emiByList[index]['title'] == 'Pending'? Colors.deepOrange
                                                : Colors.grey.shade300,
                                            fontSize: 14.sp)),
                                    Expanded(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'jan 1st 2022',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14.sp),
                                            ))),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'AED 224.00 | ',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12.sp),
                                    ),
                                    Text('Paid to kiosk',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12.sp)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                  );
                },
               /* children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Column(
                      children: [
                        Container(
                          width: 15.w,
                          height: 15.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '1st Due | ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 14.sp),
                              ),
                              Text('Paid',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.lightGreen,
                                      fontSize: 14.sp)),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'jan 1st 2022',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14.sp),
                                      ))),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'AED 224.00 | ',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.sp),
                              ),
                              Text('Paid to kiosk',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.sp)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Column(
                      children: [
                        Container(
                          width: 15.w,
                          height: 15.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '1st Due | ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 14.sp),
                              ),
                              Text('Paid',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.lightGreen,
                                      fontSize: 14.sp)),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'jan 1st 2022',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14.sp),
                                      ))),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'AED 224.00 | ',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.sp),
                              ),
                              Text('Paid to kiosk',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.sp)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],*/
              ),
            ),
          ),
        ],
      ),
    );
  }
}
