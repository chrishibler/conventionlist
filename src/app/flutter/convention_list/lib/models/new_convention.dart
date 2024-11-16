import 'package:freezed_annotation/freezed_annotation.dart';

import 'category.dart';
import 'converters/category_converter.dart';

part 'new_convention.freezed.dart';
part 'new_convention.g.dart';

@freezed
class NewConvention with _$NewConvention {
  const factory NewConvention({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    @Default(false) bool isApproved,
    String? city,
    String? country,
    String? postalCode,
    String? description,
    String? websiteAddress,
    String? venueName,
    String? address1,
    String? address2,
    String? state,
    @CategoryConverter() @Default(Category.unlisted) Category category,
  }) = _NewConvention;

  factory NewConvention.fromJson(Map<String, dynamic> json) => _$NewConventionFromJson(json);
}
