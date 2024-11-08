// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConventionImpl _$$ConventionImplFromJson(Map<String, dynamic> json) =>
    _$ConventionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      city: json['city'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      position: json['position'] == null
          ? null
          : Position.fromJson(json['position'] as Map<String, dynamic>),
      description: json['description'] as String?,
      websiteAddress: json['websiteAddress'] as String?,
      venueName: json['venueName'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      state: json['state'] as String?,
      category: (json['category'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ConventionImplToJson(_$ConventionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'city': instance.city,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'position': instance.position,
      'description': instance.description,
      'websiteAddress': instance.websiteAddress,
      'venueName': instance.venueName,
      'address1': instance.address1,
      'address2': instance.address2,
      'state': instance.state,
      'category': instance.category,
    };
