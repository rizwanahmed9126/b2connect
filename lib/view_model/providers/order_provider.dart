import 'dart:convert';

import 'package:b2connect_flutter/model/models/offer_transactions.dart';
import 'package:b2connect_flutter/model/models/order_detail_model.dart';
import 'package:b2connect_flutter/model/services/http_service.dart';
import 'package:b2connect_flutter/model/services/util_service.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'Repository/repository_pattern.dart';

class OrderProvider with ChangeNotifier {
  OfferTransactionsModel? offerOrderModelData;
  OrderDetailModel? orderDetailModel;
  Repository? http = HttpService();
  UtilService utilsService = locator<UtilService>();



  Future<dynamic> callOfferOrder() async {
    try {
      var response = await http!.offerOrders();
      if (response.statusCode == 200) {
        offerOrderModelData=null;

        saveOfferOrderModelData(OfferTransactionsModel.fromJson(response.data));
        //offerOrderModelData =OfferTransactionsModel.fromJson(response.data);
        print('id from ${offerOrderModelData!.items![0].orderId}');

        if(offerOrderModelData!.items!.length>0){
          return offerOrderModelData;
        }
        else{
          offerOrderModelData=null;
          return "failed";
        }

      } else {
        return "failed";
      }
    } catch (e) {
      print(e);
      return "failed";

    }
  }

  Future<OrderDetailModel?>getOrderDetails(int id) async {

    try {
      var response = await http!.getOrderDetail(id);
      if (response.statusCode == 200) {
        saveOrderDetailModelData(OrderDetailModel.fromJson(response.data));
        EasyLoading.dismiss();
        return orderDetailModel;
      } else {
        EasyLoading.dismiss();
        return utilsService
            .showToast("Something went wrong, Please Enter again");
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      return utilsService.showToast(e.toString());
    }
  }

  saveOrderDetailModelData(OrderDetailModel value){
    orderDetailModel=value;
    notifyListeners();
  }

  saveOfferOrderModelData(OfferTransactionsModel value){
    offerOrderModelData=value;
    notifyListeners();
  }

}