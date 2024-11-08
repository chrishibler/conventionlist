import 'package:convention_list/models/position.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'convention.freezed.dart';
part 'convention.g.dart';

@freezed
class Convention with _$Convention {
  const factory Convention({
    required String id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
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
    int? category,
  }) = _Convention;

  factory Convention.fromJson(Map<String, dynamic> json) => _$ConventionFromJson(json);
}
