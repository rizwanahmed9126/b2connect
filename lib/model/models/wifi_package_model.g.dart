// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wifi_package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WifiModel _$WifiModelFromJson(Map<String, dynamic> json) => WifiModel(
      id: json['id'] as int,
      name: json['name'] as String,
      label: json['label'] as String,
      currency: json['currency'] as String,
      price: json['price'] as int,
      devices: json['devices'] as int,
      validity: json['validity'] as int,
      bandwidth: json['bandwidth'] as int,
      description: json['description'] as String,
    );

Map<String, dynamic> _$WifiModelToJson(WifiModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'label': instance.label,
      'currency': instance.currency,
      'price': instance.price,
      'devices': instance.devices,
      'validity': instance.validity,
      'bandwidth': instance.bandwidth,
      'description': instance.description,
    };
