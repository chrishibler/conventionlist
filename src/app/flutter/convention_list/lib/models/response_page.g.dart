// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResponsePageImpl _$$ResponsePageImplFromJson(Map<String, dynamic> json) =>
    _$ResponsePageImpl(
      totalCount: (json['totalCount'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      conventions: (json['conventions'] as List<dynamic>)
          .map((e) => Convention.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ResponsePageImplToJson(_$ResponsePageImpl instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'conventions': instance.conventions,
    };
