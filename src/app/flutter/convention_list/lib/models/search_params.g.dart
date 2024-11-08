// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchParamsImpl _$$SearchParamsImplFromJson(Map<String, dynamic> json) =>
    _$SearchParamsImpl(
      orderBy: $enumDecodeNullable(_$OrderByEnumMap, json['orderBy']) ??
          OrderBy.distance,
      search: json['search'] as String?,
      position: json['position'] == null
          ? null
          : Position.fromJson(json['position'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SearchParamsImplToJson(_$SearchParamsImpl instance) =>
    <String, dynamic>{
      'orderBy': _$OrderByEnumMap[instance.orderBy]!,
      'search': instance.search,
      'position': instance.position,
    };

const _$OrderByEnumMap = {
  OrderBy.distance: 'distance',
  OrderBy.startDate: 'startDate',
};
