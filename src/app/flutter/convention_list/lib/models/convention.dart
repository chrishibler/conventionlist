import 'package:convention_list/models/position.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'category.dart';
import 'converters/category_converter.dart';

part 'convention.freezed.dart';
part 'convention.g.dart';

@freezed
class Convention with _$Convention {
  const Convention._();

  const factory Convention({
    required String id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required bool isApproved,
    String? city,
    String? country,
    String? postalCode,
    Position? position,
    String? description,
    String? websiteAddress,
    String? venueName,
    String? address1,
    String? address2,
    String? state,
    @CategoryConverter() @Default(Category.unlisted) Category category,
  }) = _Convention;

  factory Convention.fromJson(Map<String, dynamic> json) => _$ConventionFromJson(json);

  String getLocationInfo() {
    String info = '$city';
    if (state != null) {
      info += ', $state, $country';
    } else {
      info += ', $country';
    }
    return info;
  }
}
