import 'dart:convert';

import 'package:b2connect_flutter/model/models/fortune_model.dart';
import 'package:b2connect_flutter/model/services/http_service.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:flutter/cupertino.dart';

import 'Repository/repository_pattern.dart';

class FortuneProvider extends ChangeNotifier {
  Repository? http = locator<HttpService>();
  List<Fortune> fortuneList = [];

  Future<dynamic> getFortuneList() async {
    fortuneList.clear();
    try {
      var response = await http!.getFortuneItem();
      if (response.statusCode == 200) {
        for (var data in response.data) {
          fortuneList.add(Fortune.fromJson(data));
        }
        print(fortuneList);
      } else {
        print('failed to get data from userinfo');

        return "Failed";
      }
    } catch (e) {
      print(e);
      return "Failed";
    }
  }
}
