import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/view/screens/scan_your_emirates_id_screen.dart';
import 'package:b2connect_flutter/view/widgets/appbar_with_back_icon_and_language.dart';
import 'package:b2connect_flutter/view/widgets/custom_buttons/gradiant_color_button.dart';
import 'package:b2connect_flutter/view/widgets/change_language_bottom_sheet.dart';
import 'package:b2connect_flutter/view/widgets/choose_payment_plan_bottom_sheet.dart';
import 'package:b2connect_flutter/view/widgets/emirates_id_View_Widget.dart';
import 'package:b2connect_flutter/view/widgets/select_address_widget.dart';
import 'package:b2connect_flutter/view/widgets/shipping_widget.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:b2connect_flutter/view_model/providers/pay_by_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ShippingScreen extends StatefulWidget {
  final double? totalPriceNow;

/*
  final double? totalPriceLater;
*/
  const ShippingScreen({Key? key, this.totalPriceNow /*,this.totalPriceLater*/
      })
      : super(key: key);

  @override
  _ShippingScreenState createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  bool _checkbox = true;

  // String tagId = ' ';
  //
  // void active(
  //   dynamic val,
  // ) {
  //   setState(() {
  //     tagId = val;
  //   });
  // }

  // List shippingdetail = [
  //   {
  //     "id": "1",
  //     "name": "Hyder Ali",
  //     "address": "C101, Al Dhabi Building, Al Dhabi",
  //     "no": "+ 917 9099 9909",
  //     "mail": "Hyderali@example.com",
  //     "nationality": "Indian, ",
  //     "gender": "Male",
  //   },
  //   {
  //     "id": "2",
  //     "name": "Aiman Khan",
  //     "address": "C101, Al Burj Building, Al Burj",
  //     "no": "+ 917 8499 8088",
  //     "mail": "Aimankhan@example.com",
  //     "nationality": "Indian, ",
  //     "gender": "Female",
  //   },
  // ];
  // List shippingdetail1 = [
  //   {
  //     "id": "3",
  //     "name": "Hyder Ali",
  //     "address": "C101, Al Dhabi Building, Al Dhabi",
  //     "no": "+ 917 9099 9909",
  //     "mail": "Hyderali@example.com",
  //     "nationality": "Indian, ",
  //     "gender": "Male",
  //   },
  //   {
  //     "id": "4",
  //     "name": "Aiman Khan",
  //     "address": "C101, Al Burj Building, Al Burj",
  //     "no": "+ 917 8499 8088",
  //     "mail": "Aimankhan@example.com",
  //     "nationality": "Indian, ",
  //     "gender": "Female",
  //   },
  // ];

  final TextEditingController _salesAgentCode = TextEditingController();
  final TextEditingController _orderComment = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, i, _) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWithBackIconAndLanguage(
            onTapIcon: () {
              navigationService.closeScreen();
            },
          ),
          body: Consumer<AuthProvider>(builder: (context, i, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15.h),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('ship_to')!,
                              style: TextStyle(
                                fontSize: 36.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                height: 1.1.h,
                              ),
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     _addressModalBottomSheet(context);
                            //   },
                            //   child: Icon(
                            //     Icons.add,
                            //     color: Theme.of(context).primaryColor,
                            //     size: 30.h,
                            //   ),
                            // )
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('shipping_address')!,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          //shippingdetail.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ShippingWidget(
                              name:
                                  "${i.userInfoData!.firstName} ${i.userInfoData!.lastName}",
                              //data: "${i.userInfoData!.firstName} ${i.userInfoData!.lastName}",//shippingdetail[index],
                              gender: i.userInfoData!.emiratesGender,
                              number: i.userInfoData!.uid,
                              // tag: i.userInfoData!.uid,//shippingdetail[index]['id'],
                              // action: active,
                              // active: tagId == shippingdetail[index]['id'] ? true : false,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10.h,
                            );
                          },
                        ),
                        // SizedBox(
                        //   height: 30.h,
                        // ),
                        // Text(
                        //   AppLocalizations.of(context)!.translate('billing_address')!,
                        //   style: TextStyle(
                        //     color: Colors.grey.shade700,
                        //     fontSize: 16.sp,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 15.h,
                        // ),
                        // ListView.separated(
                        //   physics: NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true,
                        //   itemCount: shippingdetail.length,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return ShippingWidget(
                        //       data: shippingdetail1[index],
                        //       tag: shippingdetail1[index]['id'],
                        //       action: active,
                        //       active:
                        //           tagId == shippingdetail1[index]['id'] ? true : false,
                        //     );
                        //   },
                        //   separatorBuilder: (BuildContext context, int index) {
                        //     return SizedBox(
                        //       height: 10.h,
                        //     );
                        //   },
                        // ),

                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('emirates_id')!,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        EmiratesIdViewWidget(),
                        Visibility(
                          visible:
                              i.userInfoData!.emiratesId == "" ? true : false,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ScanYourEmiratesIDScreen()))
                                    .then((value) {
                                  /* setState(() {
                                      checkEmiratesId();
                                    });*/
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                textStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(6.0),
                                ),
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Text(AppLocalizations.of(context)!
                                  .translate('scan_now')!)),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        /* Text('SALES AGENT CODE'),*/

                        Text(
                          AppLocalizations.of(context)!
                              .translate('sales_promo_code')!,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          controller: _salesAgentCode,
                          decoration: new InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 15.0,
                              ),
                              isDense: true,
                              // Added this
                              // border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .translate('sales_promo_code_hint')!

                              //labelText: 'Sales Agent Code'
                              ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('order_comment')!,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          controller: _orderComment,
                          decoration: new InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 15.0,
                              ),
                              isDense: true,
                              // Added this
                              // border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .translate('optional')!

                              //labelText: 'Sales Agent Code'
                              ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: Theme.of(context).primaryColor,
                              side: BorderSide(
                                width: 2.w,
                                color: Colors.grey.shade400,
                              ),
                              value: _checkbox,
                              onChanged: (value) {
                                setState(() {
                                  _checkbox = !_checkbox;
                                });
                              },
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('ship_checkbox_text')!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        //Text(context.read<PayByProvider>().deviceId.toString()),

                        CustomButton(
                          height: 50.h,
                          width: double.infinity,
                          onPressed: () async {
                            i.userInfoData!.emiratesId == ""
                                ? _showToast(context)
                                : _paymentPlanBottomSheet(
                                    context,
                                    widget
                                        .totalPriceNow! /*,widget.totalPriceLater!*/);
                            Provider.of<PayByProvider>(context, listen: false)
                                .salesAgentCode = _salesAgentCode.text;
                            Provider.of<PayByProvider>(context, listen: false)
                                .comment = _orderComment.text;

                            /* EasyLoading.show(status: 'Please Wait');
                          await context
                              .read<PayByProvider>()
                              .payByOffersOrder(context);*/
                            //navigationService.navigateTo(PaymentMethodScreenRoute);
                          },
                          text: AppLocalizations.of(context)!
                              .translate('ship_next_button')!,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }));
    });
  }
}

void _showToast(BuildContext context) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: const Text(
          'Emirates ID must be verified.. Click Scan Now to scan your Emirates Id Card'),
      // action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

void _paymentPlanBottomSheet(
    context, double totalPriceNow /*,double totalPriceLater*/) {
  showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: [
            ChoosePaymentPlanBottomSheet(
                totalPriceNow:
                    totalPriceNow /*,totalPriceLater: totalPriceLater,*/),
          ],
        );
      });
}
