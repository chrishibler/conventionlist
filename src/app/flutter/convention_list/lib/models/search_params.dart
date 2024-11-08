import 'package:convention_list/models/position.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_params.freezed.dart';
part 'search_params.g.dart';

@freezed
class SearchParams with _$SearchParams {
  const factory SearchParams({
    @Default(OrderBy.distance) OrderBy orderBy,
    String? search,
    Position? position,
  }) = _SearchParams;

  const SearchParams._();

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
}

enum OrderBy {
  distance,
  startDate,
}
