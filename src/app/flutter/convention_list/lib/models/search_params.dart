import 'package:convention_list/models/position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_params.g.dart';

@JsonSerializable()
class SearchParams {
  final OrderBy orderBy;
  final String? search;
  final Position? position;

  SearchParams({this.orderBy = OrderBy.distance, this.search, this.position});

  String toQueryString() {
    String queryString = '&orderBy=${orderBy.name}';
    if (search != null && search!.isNotEmpty) {
      queryString += '&search=$search';
    }

    if (position != null) {
      queryString += '&lat=${position!.latitude}&lon=${position!.longitude}';
    }
    return queryString;
  }

  factory SearchParams.fromJson(Map<String, dynamic> json) => _$SearchParamsFromJson(json);

  Map<String, dynamic> toJson() => _$SearchParamsToJson(this);
}

enum OrderBy {
  distance,
  startDate,
}
