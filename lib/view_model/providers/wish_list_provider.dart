import 'dart:convert';
import 'package:b2connect_flutter/model/models/offers_models/offers_list_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/product_details_model.dart';
import 'package:flutter/cupertino.dart';
import '../../model/models/wifi_package_model.dart';
import '../../model/services/http_service.dart';
import '../../model/services/navigation_service.dart';
import '../../model/services/storage_service.dart';
import '../../model/services/util_service.dart';
import '../../model/utils/service_locator.dart';

class WishListProvider extends ChangeNotifier {
  HttpService? http = locator<HttpService>();
  NavigationService navigationService = locator<NavigationService>();
  StorageService storageService = locator<StorageService>();
  UtilService utilsService = locator<UtilService>();


  List<OffersList> wishListData = [];
  bool? showLoader;


  Future<dynamic> showWishList() async {
    wishListData.clear();
    try {
      var response = await http!.showWishList();
      if (response.statusCode == 200) {

        var usersjson = response.data;

        for (var userjson in usersjson) {
          saveWishList(OffersList.fromJson(userjson));
        }
        if(wishListData.isNotEmpty){
          //saveWishList(wishListData);
          return wishListData;
        }

        else
          return "Failed";
      } else {
        print('failed to get data from userinfo');

        return "Failed";
      }
    } catch (e) {
      print(e);
      return "Failed";
    }
  }



  Future<dynamic> addToWishList(String id) async {
    try {
      var response = await http!.addWishList(id);
      if (response.statusCode == 200) {
        print('added suncessfull');
        return 'ok';
      } else {
        print('failed to get data from userinfo');

        return "Failed";
      }
    } catch (e) {
      print(e);
      return "Failed";
    }
  }

  Future<dynamic> deleteFromWishList(String id) async {
    try {
      var response = await http!.deleteFromWishList(id);
      if (response.statusCode == 200) {
        //print('delete suncessfull');
        return 'ok';
      } else {
        print('failed to get data from userinfo');

        return "Failed";
      }
    } catch (e) {
      print(e);
      return "Failed";
    }
  }

  Future<bool> checkWishList(String id) async {

      var response = await http!.checkWishList(id);
      if (response.statusCode == 200) {
        return response.data;
      }
      else{
        return false;
      }
      }



  saveWishList(OffersList value){
    wishListData.add(value);
    notifyListeners();
  }
  removeFromWishList(int value){
    wishListData.removeWhere((element) => element.id==value);  //addAll(value);
    notifyListeners();
  }
  setLoader(bool value){
    showLoader=value;
    notifyListeners();
  }
}
