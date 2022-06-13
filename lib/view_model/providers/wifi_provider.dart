import 'dart:convert';
import 'package:b2connect_flutter/model/models/wifi_plan_model.dart';
import 'package:flutter/cupertino.dart';
import '../../model/models/wifi_package_model.dart';
import '../../model/services/http_service.dart';
import '../../model/services/navigation_service.dart';
import '../../model/services/storage_service.dart';
import '../../model/services/util_service.dart';
import '../../model/utils/service_locator.dart';

class WifiProvider extends ChangeNotifier {
  HttpService? http = locator<HttpService>();
  NavigationService navigationService = locator<NavigationService>();
  StorageService storageService = locator<StorageService>();
  UtilService utilsService = locator<UtilService>();

  List<WifiModel> wifiData = [];
  WifiPlanModel? wifiPlanData;

  Future<dynamic> callWifi() async {
    try {
      var response = await http!.wifi();
      if (response.statusCode == 200) {
        var usersjson = json.decode(response.body);

        for (var userjson in usersjson) {
          wifiData.add(WifiModel.fromJson(userjson));
        }
        wifiData.forEach((element) {
          print('${element.id}');
        });

        return wifiData;
      } else {
        print('failed to get data from userinfo');

        return "failed";
        //utilsService.showToast("Something went wrong, Please Enter again");
      }
    } catch (e) {
      print(e);
      return "Failed";
    }
  }

  Future<dynamic> callWifiPlan() async {
    try {
      var response = await http!.wifiPlan();
      if (response.statusCode == 200) {

        saveWifiPlanData(WifiPlanModel.fromJson(response.data));
        print('from api${wifiPlanData!.packageName}');

        if(wifiPlanData!=null){
          return wifiPlanData;
        }
        else{
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


  saveWifiPlanData(WifiPlanModel value){
    wifiPlanData=value;
    notifyListeners();
  }




// Future<WifiPackagesIdModel>  callWifiPackages(String id)async{
//     try{
//
//       var response = await http!.wifiPackagesID(id);
//       if (response.statusCode == 200) {
//
//         //var usersjson=json.decode(response.body);
//
//         //for (var userjson in usersjson) {
//         WifiPackagesIdModel data=WifiPackagesIdModel.fromJson(json.decode(response.body));
//
//          // wifiData.add(WifiModel.fromJson(userjson));
//         //}
//         wifiData.forEach((element) {
//           print('${element.id}');
//         });
//
//         return data;
//
//       }
//
//       else {
//         print('failed to get data from userinfo');
//
//         return
//         utilsService.showToast("Something went wrong, Please Enter again");
//       }
//     }
//     catch(e){
//       print(e);
//       return utilsService.showToast("Something went wrong, Please Try again");
//     }
//
//   }

}
