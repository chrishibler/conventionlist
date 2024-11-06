// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_convention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewConvention _$NewConventionFromJson(Map<String, dynamic> json) =>
    NewConvention(
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      city: json['city'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      description: json['description'] as String?,
      websiteAddress: json['websiteAddress'] as String?,
      venueName: json['venueName'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      state: json['state'] as String?,
      category: (json['category'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NewConventionToJson(NewConvention instance) =>
    <String, dynamic>{
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'description': instance.description,
      'websiteAddress': instance.websiteAddress,
      'venueName': instance.venueName,
      'address1': instance.address1,
      'address2': instance.address2,
      'postalCode': instance.postalCode,
      'city': instance.city,
      'country': instance.country,
      'state': instance.state,
      'category': instance.category,
    };
