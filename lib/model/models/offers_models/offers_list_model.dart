import 'offers_categories_model.dart';

class OffersList {
  int? id;
  int? timestamp;
  String? name;
  List<String>? images;
  String? shortText;
  String? fullText;
  List<OfferCategories>? offerCategories;
  String? link;
  int? cardWidth;
  int? cardHeight;
  int? regularPrice;
  int? salePrice;
  num? installmentPrice;
  String? stockStatus;
  int? dateCreated;

  OffersList(
      {this.id,
      this.timestamp,
      this.name,
      this.images,
      this.shortText,
      this.fullText,
      this.offerCategories,
      this.link,
      this.cardWidth,
      this.cardHeight,
      this.regularPrice,
      this.salePrice,
      this.installmentPrice,
      this.stockStatus,
      this.dateCreated});

  OffersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    name = json['name'];
    images = json['images'].cast<String>();
    shortText = json['shortText'];
    fullText = json['fullText'];
    if (json['offerCategories'] != null) {
      offerCategories = new List<OfferCategories>.empty(growable: true);
      json['offerCategories'].forEach((v) {
        offerCategories!.add(new OfferCategories.fromJson(v));
      });
    }
    link = json['link'];
    cardWidth = json['cardWidth'];
    cardHeight = json['cardHeight'];
    regularPrice = json['regularPrice'];
    salePrice = json['salePrice'];
    installmentPrice = json['installmentPrice'];
    stockStatus = json['stockStatus'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['name'] = this.name;
    data['images'] = this.images;
    data['shortText'] = this.shortText;
    data['fullText'] = this.fullText;
    if (this.offerCategories != null) {
      data['offerCategories'] =
          this.offerCategories!.map((v) => v.toJson()).toList();
    }
    data['link'] = this.link;
    data['cardWidth'] = this.cardWidth;
    data['cardHeight'] = this.cardHeight;
    data['regularPrice'] = this.regularPrice;
    data['salePrice'] = this.salePrice;
    data['installmentPrice'] = this.installmentPrice;
    data['stockStatus'] = this.stockStatus;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}
