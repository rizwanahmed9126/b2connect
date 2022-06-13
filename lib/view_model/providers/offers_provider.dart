import 'dart:convert';
import 'dart:core';

import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/models/filter_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/get_offers_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/offers_list_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/product_categories.dart';
import 'package:b2connect_flutter/model/models/offers_models/product_details_model.dart';
import 'package:b2connect_flutter/model/models/offers_models/product_details_model.dart';
import 'package:b2connect_flutter/model/services/http_service.dart';
import 'package:b2connect_flutter/model/services/util_service.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:b2connect_flutter/view/widgets/custom_buttons/gradiant_color_button.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view_model/providers/pay_by_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'Repository/repository_pattern.dart';

class OffersProvider with ChangeNotifier {
  Repository? http = locator<HttpService>();
  GetOffers? offersData;
  final searchQueryController = TextEditingController();

  ProductDetailsModel? productDetailsData;
  List<ProductCategories> productCategories = [];
  UtilService utilsService = locator<UtilService>();

  //List<dynamic> productIds = [];
  double totalPriceNow = 0.0;
  double installmentPrice = 0;
  double installmentPrice6x = 0;
  double firstInstallmentPrice3x = 0;
  double firstInstallmentPrice6x = 0;
  double _productPriceWithOutInstallment = 0;
  int index3xInstallment = -1;
  int index6xInstallment = -1;

  //double _totalInstallmentProductPrice = 0.0;
  //double totalPriceLater = 0.0;
  /*double installmentPrice = 0.0;
  double updatedInstallmentPrice = 0.0;*/
  List<ProductDetailsModel> cartData = [];

  bool onlySmartPhone = false;
  bool? showLoader;

  set3xInstallmentIndex() {
    final index = productDetailsData!.offer.installmentPrices
        .indexWhere((element) => element.tenure == 3);
    if (index < 0) {
      index3xInstallment = -1;
      notifyListeners();
    } else {
      index3xInstallment = index;
      notifyListeners();
    }
  }

  set6xInstallmentIndex() {
    final index = productDetailsData!.offer.installmentPrices
        .indexWhere((element) => element.tenure == 6);
    if (index < 0) {
      index6xInstallment = -1;
      notifyListeners();
    } else {
      index6xInstallment = index;
      notifyListeners();
    }
  }

  set3xInstallmentPrice(double value) {
    installmentPrice = value;
    setFirstInstallmentPrice();
    notifyListeners();
  }

  delete3xInstallmentPrice(double value) {
    installmentPrice = installmentPrice - value;
    notifyListeners();
  }

  set6xInstallmentPrice(double value) {
    installmentPrice6x = value;
    setFirstInstallmentPrice();
    notifyListeners();
  }

  delete6xInstallmentPrice(double value) {
    installmentPrice6x = installmentPrice - value;
    notifyListeners();
  }

  setProductWithOutInstallmentPrice(double value) {
    _productPriceWithOutInstallment = _productPriceWithOutInstallment + value;
    notifyListeners();
  }

  deleteProductWithOutInstallmentPrice(double value) {
    _productPriceWithOutInstallment = installmentPrice - value;
    notifyListeners();
  }

  setFirstInstallmentPrice() {
    firstInstallmentPrice3x =
        installmentPrice + _productPriceWithOutInstallment;
    firstInstallmentPrice6x =
        installmentPrice6x + _productPriceWithOutInstallment;
    notifyListeners();
  }

  removeFirstInstallmentPrice(double value) {
    firstInstallmentPrice3x = firstInstallmentPrice3x - value;
    firstInstallmentPrice6x = installmentPrice6x - value;
    notifyListeners();
  }

  // filter Variables

  FilterData filterData = FilterData(
      sortByListIndex: 0,
      availabilityListIndex: 0,
      listOfAllOptions: [],
      addAttributeId: [],
      selectedList: [],
      addAttribute: []);

  Future<void> handleAttributeTap(
      String attributeId, String optionsName) async {
    if (filterData.addAttributeId.contains(attributeId)) {
      var idIndex = filterData.addAttributeId
          .indexWhere((element) => element == attributeId);
      print(idIndex);

      List<String> listOnIndex = filterData.listOfAllOptions[idIndex];

      if (filterData.listOfAllOptions[idIndex].contains(optionsName)) {
        List<String> addOptions = [];
        addOptions.addAll(listOnIndex);
        addOptions.removeWhere((element) => element == optionsName);
        filterData.listOfAllOptions.removeAt(idIndex);
        filterData.listOfAllOptions
            .insert(idIndex, addOptions.toList(growable: true));
        var optionsList = addOptions.join(';');
        if (optionsList == "") {
          filterData.addAttributeId.removeAt(idIndex);
          filterData.addAttribute.removeAt(idIndex);
          print(filterData.addAttribute.join(','));
          filterData.filterBy = filterData.addAttribute.join(',') == ""
              ? null
              : filterData.addAttribute.join(',');
        } else {
          var idWithOptions = '$attributeId:$optionsList';
          filterData.addAttribute[idIndex] = idWithOptions;
          print(filterData.addAttribute.join(','));
          filterData.filterBy = filterData.addAttribute.join(',');
          addOptions.clear();
        }
      } else {
        List<String> addOptions = [];

        addOptions.addAll(listOnIndex);
        addOptions.add(optionsName);
        filterData.listOfAllOptions.removeAt(idIndex);
        filterData.listOfAllOptions
            .insert(idIndex, addOptions.toList(growable: true));
        print(filterData.listOfAllOptions);
        var optionsList = addOptions.join(';');
        var idWithOptions = '$attributeId:$optionsList';
        filterData.addAttribute.removeAt(idIndex);
        filterData.addAttribute.insert(idIndex, idWithOptions);
        print(filterData.addAttribute.join(','));
        filterData.filterBy = filterData.addAttribute.join(',');
        addOptions.clear();
      }
    } else {
      List<String> addOptions = [];
      addOptions.add(optionsName);
      filterData.addAttributeId.add(attributeId);
      filterData.listOfAllOptions.add(addOptions.toList(growable: true));
      print(filterData.listOfAllOptions);
      var optionsList = addOptions.join(';');
      filterData.selectedList = [attributeId, optionsList];
      filterData.addAttribute.add(filterData.selectedList.join(':'));
      print(filterData.addAttribute.join(','));
      filterData.filterBy = filterData.addAttribute.join(',');
      addOptions.clear();
    }
  }

  Future<void> clearFilterData({int? catId}) async {
    filterData.availabilityListIndex = 0;
    filterData.filterByStock = null;
    // filterData.sortByListIndex = 0;
    filterData.sortBy = null;
    filterData.filterBy = null;
    filterData.selectedList.clear();
    filterData.addAttribute.clear();
    filterData.maximumPrice = null;
    filterData.minimumPrice = null;
    //filterData.addOptions.clear();
    filterData.listOfAllOptions.clear();
    filterData.addAttributeId.clear();
    filterData.colors = null;
    //EasyLoading.show(status: 'Please Wait...');
    if (catId != null) {
      await getOffers(categoryId: catId);
    }
  }

  void handleSortByTap(int index, sortByListId) {
    filterData.sortByListIndex = index;
    if (sortByListId == '2') {
      filterData.sortBy = 'PRICE_LOW_TO_HIGH';
    } else if (sortByListId == '3') {
      filterData.sortBy = 'PRICE_HIGH_TO_LOW';
    } else if (sortByListId == '4') {
      filterData.sortBy = 'NAME_A_Z';
    } else if (sortByListId == '5') {
      filterData.sortBy = 'NEWEST';
    } else {
      filterData.sortBy = null;
    }
  }

  void handleAvailabilityTap(int index, availabilityListId) {
    filterData.availabilityListIndex = index;
    if (availabilityListId == '2') {
      filterData.filterByStock = 'IN_STOCK';
    } else if (availabilityListId == '3') {
      filterData.filterByStock = 'ON_BACK_ORDER';
    } else {
      filterData.filterByStock = null;
    }
  }

  Future<GetOffers?> getOffers(
      {int? page,
      int? perPage,
      int? categoryId,
      String? sortBy,
      String? filterBy,
      String? filterByStock,
      String? name,
      int? minPrice,
      int? maxPrice}) async {
    try {
      var response = await http!.getOffers(page, perPage, categoryId, sortBy,
          filterBy, filterByStock, name, minPrice, maxPrice);
      if (response.statusCode == 200) {
        saveOffersList(GetOffers.fromJson(json.decode(response.body)));
        EasyLoading.dismiss();

        return offersData;
      } else {
        return utilsService
            .showToast("Something went wrong, Please Enter again");
      }
    } catch (e) {
      print(e);
      return utilsService.showToast(e.toString());
    }
  }

  Future<ProductDetailsModel?> getProductDetails(String id) async {
    print('id from api--${id}');
    try {
      var response = await http!.getProductsDetails(id);
      if (response.statusCode == 200) {
        saveProductDetails(
            ProductDetailsModel.fromJson(json.decode(response.body)));
        return productDetailsData;
      } else {
        return utilsService
            .showToast("Something went wrong, Please Enter again");
      }
    } catch (e) {
      print(e);
      return utilsService.showToast(e.toString());
    }
  }

  Future<List<ProductCategories>> getProductCategories() async {
    try {
      productCategories.clear();
      var response = await http!.productCategories();
      if (response.statusCode == 200) {
        for (var abc in response.data) {
          if (ProductCategories.fromJson(abc).parent == 0) {
            saveProductCategory(ProductCategories.fromJson(abc));
          }
        }
        return productCategories;
      } else {
        return utilsService
            .showToast("Something went wrong, Please Enter again");
      }
    } catch (e) {
      print(e);
      return utilsService.showToast(e.toString());
    }
  }

  saveTotalNow(double value) {
    totalPriceNow = totalPriceNow + value;
    notifyListeners();
  }

  minusTotalNow(double value) {
    totalPriceNow = totalPriceNow - value;
    notifyListeners();
  }

  saveOffersList(GetOffers value) {
    offersData = value;
    notifyListeners();
  }

  clearCartData() {
    this.cartData.clear();
    notifyListeners();
  }

  removeCartData(int value) {
    this.cartData.removeWhere((element) => element.offer.id == value);
    notifyListeners();
  }

  saveProductCategory(ProductCategories value) {
    this.productCategories.add(value);
    notifyListeners();
  }

  saveProductDetails(ProductDetailsModel value) {
    this.productDetailsData = value;
    notifyListeners();
  }

  updateFilterData(FilterData value) {
    this.filterData = value;
    notifyListeners();
  }

  void addToCart(BuildContext context) {
    if (productDetailsData!.offer.emiEnabled == false) {
      //TODO: Do Something
      Provider.of<PayByProvider>(context, listen: false).addToCartList(
          productDetailsData!
              .offer.id); //productIds.add(productDetailsData!.offer.id);
      this.saveTotalNow(productDetailsData!.offer.salePrice.toDouble());
      this.setProductWithOutInstallmentPrice(
          productDetailsData!.offer.salePrice.toDouble());
      navigationService.navigateTo(CartScreenRoute);
    } else {
      //TODO: Do Something
      if (this.onlySmartPhone == false) {
        //TODO: Do Something
        Provider.of<PayByProvider>(context, listen: false)
            .addToCartList(productDetailsData!.offer.id);
        this.saveTotalNow(productDetailsData!.offer.salePrice.toDouble());
        checkAndSetInstallmentPrices();
        this.onlySmartPhone = true;
        navigationService.navigateTo(CartScreenRoute);
      } else {
        //TODO: Do Something
        allReadyAdded(context, () {
          navigationService.closeScreen();
        });
      }
    }
  }

  void checkAndSetInstallmentPrices() {
    this.index3xInstallment != -1
        ? this.set3xInstallmentPrice(productDetailsData!
            .offer.installmentPrices[this.index3xInstallment].monthlyPrice
            .toDouble())
        : this.set3xInstallmentPrice(0);
    this.index6xInstallment != -1
        ? this.set6xInstallmentPrice(productDetailsData!
            .offer.installmentPrices[this.index6xInstallment].monthlyPrice
            .toDouble())
        : this.set6xInstallmentPrice(0);
  }

  allReadyAdded(context, VoidCallback onTap) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      //transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 100,
            margin: EdgeInsets.only(left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Similar item is already added'),
                  CustomButton(
                    height: 25,
                    width: 100,
                    text: "Ok",
                    onPressed: onTap,
                  ),
                ],
              ),
            ),
            //child: PhotoView(imageProvider: NetworkImage(url),backgroundDecoration: BoxDecoration(color: Colors.white))
          ),
        );
      },
    );
  }
}
