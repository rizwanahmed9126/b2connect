import 'dart:convert';

import 'package:b2connect_flutter/model/models/blogs_model/blogs.dart';
import 'package:b2connect_flutter/model/services/http_service.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'Repository/repository_pattern.dart';

class BlogsProvider with ChangeNotifier {
  Repository? http = locator<HttpService>();

  get utilsService => null;
  List<Blogs> wellnessBlogsList = [];
  List<Blogs> moneyBlogsList = [];
  List<Blogs> mediaBlogsList = [];
  List<Blogs> healthBlogsList = [];
  List<Blogs> fitnessBlogsList = [];
  List<Blogs> meditationBlogsList = [];
  List<Blogs> paymentsBlogsList = [];


  Future<dynamic> getBlogsContent({
    int? page,
    String? category,
    String? screen,
  }) async {
    try {
      var response = await http!.getBlogs(page!, category!);
      if (response.statusCode == 200) {
        for (var data in response.data) {
          //  popularList.clear();
          if (screen == 'money') {
            moneyBlogsList.add(Blogs.fromJson(data));
          } else if (screen == 'health') {
            healthBlogsList.add(Blogs.fromJson(data));
          } else if (screen == 'wellness'){
            wellnessBlogsList.add(Blogs.fromJson(data));
          }
          else if (screen == 'media'){
            mediaBlogsList.add(Blogs.fromJson(data));
          }
          else if (screen == 'fitness'){
            fitnessBlogsList.add(Blogs.fromJson(data));
          }
          else if (screen == 'meditation'){
            meditationBlogsList.add(Blogs.fromJson(data));
          }
          else if (screen == 'payments'){
            paymentsBlogsList.add(Blogs.fromJson(data));
          }
        }
        EasyLoading.dismiss();
        return response;
      } else {
        return utilsService
            .showToast("Something went wrong, Please Enter again");
      }
    } catch (e) {
      EasyLoading.dismiss();
      //popularList.clear();
      return utilsService.showToast(e.toString());
    }
  }
}
