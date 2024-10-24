// string? Search,
// DateTime? StartRange,
// DateTime? EndRange,
// OrderBy OrderBy = OrderBy.Distance,
// int? DistanceInMiles = null)

import 'package:json_annotation/json_annotation.dart';

part 'search_params.g.dart';

@JsonSerializable()
class SearchParams {
  final OrderBy orderBy;
  final String? search;

  SearchParams({this.orderBy = OrderBy.distance, this.search});

  String toQueryString() {
    String queryString = '&orderBy=${orderBy.name}';
    if (search != null && search!.isNotEmpty) {
      queryString += '&search=$search';
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
