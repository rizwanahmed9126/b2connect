import 'package:json_annotation/json_annotation.dart';

part 'product_details_model.g.dart';

@JsonSerializable(nullable: false)

class ProductDetailsModel{
  ProductDetailsModel({
    required this.offer,
    required this.attributes,
    required this.recommendations,
  });

  Offer offer;
  List<Attribute> attributes;
  List<Offer> recommendations;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) => _$ProductDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsModelToJson(this);

}

class Offer {
  Offer({
    required this.id,
    required this.timestamp,
    required this.name,
    required this.images,
    required this.shortText,
    required this.fullText,
    required this.offerCategories,
    required this.link,
    required this.cardWidth,
    required this.cardHeight,
    required this.regularPrice,
    required this.salePrice,
    required this.installmentPrices,
    required this.emiEnabled,
    required this.addonEnabled,
    //required this.installmentPrice,
    required this.stockStatus,
    required this.dateCreated,
  });

  int id;
  int timestamp;
  String name;
  List<String> images;
  String shortText;
  String fullText;
  List<OfferCategory> offerCategories;
  String link;
  int cardWidth;
  int cardHeight;
  int regularPrice;
  int salePrice;
  List<InstallmentPrices> installmentPrices;
  bool emiEnabled;
  bool addonEnabled;
  //var installmentPrice;
  String stockStatus;
  int dateCreated;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);

}

class InstallmentPrices {

  InstallmentPrices({
    required this.tenure,
    required this.monthlyPrice,
    required this.monthlyPriceAddon,
});

  int tenure;
  int monthlyPrice;
  int monthlyPriceAddon;

  factory InstallmentPrices.fromJson(Map<String, dynamic> json) => _$InstallmentPricesFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentPricesToJson(this);

}

class Attribute {
  Attribute({
    required this.attributeId,
    required this.attributeName,
    required this.options,
  });

  int attributeId;
  String attributeName;
  List<Option> options;


  factory Attribute.fromJson(Map<String, dynamic> json) => _$AttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeToJson(this);
}

class Option {
  Option({
    required this.value,
    required this.offerId,
    required this.stockStatus,
    required this.isCurrent,
  });

  String value;
  int offerId;
  String stockStatus;
  bool isCurrent;

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);

  // factory Option.fromJson(Map<String, dynamic> json) => Option(
  //   value: json["value"],
  //   offerId: json["offerId"],
  //   stockStatus: json["stockStatus"],
  //   isCurrent: json["isCurrent"],
  // );
  //
  // Map<String, dynamic> toJson() => {
  //   "value": value,
  //   "offerId": offerId,
  //   "stockStatus": stockStatus,
  //   "isCurrent": isCurrent,
  // };
}

class OfferCategory {
  OfferCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  int id;
  String name;
  String slug;

  factory OfferCategory.fromJson(Map<String, dynamic> json) => _$OfferCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$OfferCategoryToJson(this);

  // factory OfferCategory.fromJson(Map<String, dynamic> json) => OfferCategory(
  //   id: json["id"],
  //   name: json["name"],
  //   slug: json["slug"],
  // );
  //
  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "name": name,
  //   "slug": slug,
  // };
}
