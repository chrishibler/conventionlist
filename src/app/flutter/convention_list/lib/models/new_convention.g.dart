// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_convention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewConventionImpl _$$NewConventionImplFromJson(Map<String, dynamic> json) =>
    _$NewConventionImpl(
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isApproved: json['isApproved'] as bool? ?? false,
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

Map<String, dynamic> _$$NewConventionImplToJson(_$NewConventionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'isApproved': instance.isApproved,
      'city': instance.city,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'description': instance.description,
      'websiteAddress': instance.websiteAddress,
      'venueName': instance.venueName,
      'address1': instance.address1,
      'address2': instance.address2,
      'state': instance.state,
      'category': instance.category,
    };
