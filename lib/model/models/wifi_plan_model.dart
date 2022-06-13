import 'package:json_annotation/json_annotation.dart';

// WifiPackagesIdModel wifiPackagesIdModelFromJson(String str) => WifiPackagesIdModel.fromJson(json.decode(str));
//
// String wifiPackagesIdModelToJson(WifiPackagesIdModel data) => json.encode(data.toJson());
part 'wifi_plan_model.g.dart';

// ignore: deprecated_member_use
@JsonSerializable(nullable: false)
class WifiPlanModel {
  WifiPlanModel({
    this.packageLabel,
    this.packageName,
    this.assignmentTime,
    this.expirationTime,
    this.contactNumber,
    this.packageCurrency,
    this.packagePrice,
    this.status

  });

  String? packageLabel;
  String? packageName;
  List<int>? assignmentTime;
  List<int>? expirationTime;
  String? packageCurrency;
  double? packagePrice;
  String? contactNumber;
  String? status;

  factory WifiPlanModel.fromJson(Map<String, dynamic> json) => _$WifiPlanModelFromJson(json);
  Map<String, dynamic> toJson() => _$WifiPlanModelToJson(this);
}

