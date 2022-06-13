import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/services/navigation_service.dart';
import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:b2connect_flutter/view/screens/payment_method_screen.dart';
import 'package:b2connect_flutter/view_model/providers/offers_provider.dart';
import 'package:b2connect_flutter/view_model/providers/pay_by_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'custom_buttons/gradiant_color_button.dart';

class ChoosePaymentPlanBottomSheet extends StatefulWidget {
  final double? totalPriceNow;

  //final double? totalPriceLater;
  const ChoosePaymentPlanBottomSheet(
      {Key? key, this.totalPriceNow /*,this.totalPriceLater*/
      })
      : super(key: key);

  @override
  _ChoosePaymentPlanBottomSheetState createState() =>
      _ChoosePaymentPlanBottomSheetState();
}

class _ChoosePaymentPlanBottomSheetState
    extends State<ChoosePaymentPlanBottomSheet> {
  String? _firstInstallmentDate;
  String? _secondInstallmentDate;

  @override
  void initState() {
    super.initState();
    _firstInstallmentDate = DateFormat("LLL dd, yyyy")
        .format(DateTime.now().add(Duration(days: 30)));
    _secondInstallmentDate = DateFormat("LLL dd, yyyy")
        .format(DateTime.now().add(Duration(days: 60)));
  }

  var navigationService = locator<NavigationService>();

  bool _checkbox = false;

//bool _checkbox1 = false;

  void toggle() {
    setState(() {
      _checkbox = !_checkbox;
    });
  }

  String? price;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: new Wrap(
        children: <Widget>[
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(AppLocalizations.of(context)!
                    .translate('choose_payment_plan')!
                 ,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                // height: 20.h,
              ),
              /*SizedBox(
                height: 10,
              ),*/
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(AppLocalizations.of(context)!
                          .translate('pay_now')!
                        ,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Text(
                      'AED ${widget.totalPriceNow!.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: priceColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: Theme.of(context).primaryColor,
                      side: BorderSide(
                        width: 2,
                        color: Colors.grey.shade400,
                      ),
                      value: !_checkbox,
                      onChanged: (value) {
                        if (_checkbox == false) {
                          setState(() {
                            _checkbox = false;
                          });
                        } else {
                          toggle();
                        }

                        // setState(() {
                        //   _checkbox = !_checkbox;
                        // });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(AppLocalizations.of(context)!
                      .translate('buy_upfront')!
                    ,
                    style: TextStyle(
                        color: Colors.grey,
                        //  fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
              Visibility(
                visible: Provider.of<OffersProvider>(context, listen: false)
                            .installmentPrice == 0
                       /* Provider.of<OffersProvider>(context, listen: false)
                            .totalPriceNow*/
                    ? false
                    : true,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(AppLocalizations.of(context)!
                                .translate('pay_later')!
                              ,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          Text(
                            'AED ${Provider.of<OffersProvider>(context, listen: false).firstInstallmentPrice3x.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: priceColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Theme.of(context).primaryColor,
                            side: BorderSide(
                              width: 2,
                              color: Colors.grey.shade400,
                            ),
                            value: _checkbox,
                            onChanged: (value) {
                              if (_checkbox == true) {
                                setState(() {
                                  _checkbox = true;
                                });
                              } else {
                                toggle();
                              }

                              // setState(() {

                              //   _checkbox = !_checkbox;

                              // });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context)!
                            .translate('buy_3x')!
                          ,
                          style: TextStyle(
                              color: Colors.grey,

                              //  fontWeight: FontWeight.bold,

                              fontSize: 14),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(AppLocalizations.of(context)!
                                  .translate('1')!
                                ,
                                style: TextStyle(
                                    color: Colors.grey,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!
                                    .translate('pay_just')!
                                  ,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Text(
                                  'AED ${Provider.of<OffersProvider>(context, listen: false).firstInstallmentPrice3x.toStringAsFixed(2)}${AppLocalizations.of(context)!
                                      .translate('own_today')!}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30.0, top: 2, bottom: 2),
                      child: Container(
                          height: 30,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child:
                                  Image.asset('assets/images/downArrow.png'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: Text(AppLocalizations.of(context)!
        .translate('2')!
                                ,
                                style: TextStyle(
                                    color: Colors.grey,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!
                                    .translate('next_installment')!
                                  ,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Text(
                                  'AED ${Provider.of<OffersProvider>(context, listen: false).installmentPrice.toStringAsFixed(2)}${AppLocalizations.of(context)!
                                      .translate('due_on')!}$_firstInstallmentDate',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30.0, top: 2, bottom: 2),
                      child: Container(
                          height: 30,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child:
                                  Image.asset('assets/images/downArrow.png'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: Text(AppLocalizations.of(context)!
        .translate('3')!
                                ,
                                style: TextStyle(
                                    color: Colors.grey,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!
        .translate('last_installment')!
                                 ,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Text(
                                  'AED ${Provider.of<OffersProvider>(context, listen: false).installmentPrice.toStringAsFixed(2)}${AppLocalizations.of(context)!
                                      .translate('is_on')!}$_secondInstallmentDate',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton(
                  height: 50,
                  width: double.infinity,
                  onPressed: () async {
                    //_paymentPlanBottomSheet(context);
                    /* EasyLoading.show(status: 'Please Wait');
                            await context
                                .read<PayByProvider>()
                                .payByOffersOrder(context);*/

                    Provider.of<PayByProvider>(context, listen: false)
                        .payLater = _checkbox;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentMethod(
                                price: _checkbox
                                    ? '${Provider.of<OffersProvider>(context, listen: false).installmentPrice}'
                                    : '${widget.totalPriceNow!.toStringAsFixed(2)}',
                                comingFrom: _checkbox ? false : true)));
                    //navigationService.navigateTo(PaymentMethodScreenRoute);
                  },
                  text: AppLocalizations.of(context)!
                      .translate('ship_next_button')!,
                ),
              )

              /* Container(
                height: 110,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ElevatedButton(
                      onPressed: () {
                        navigationService.navigateTo(AddShippingAddressScreenRoute);


                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.transparent,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate('shipping_address1')!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        navigationService.navigateTo(AddShippingAddressScreenRoute);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.transparent,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate('billing_address1')!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),*/
              /*  SizedBox(
                height: height * 0.010,
              ),*/
              /*Padding(
                padding: EdgeInsets.all(8.0.h),
                child: Container(
                  height: 6,
                  width: width * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
