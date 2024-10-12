import 'package:json_annotation/json_annotation.dart';

import 'position.dart';

part 'convention.g.dart';

@JsonSerializable()
class Convention {
  final String id, name, city, postalCode, country;
  final Position position;
  DateTime startDate, endDate;
  final String? description,
      websiteAddress,
      venueName,
      address1,
      address2,
      state;
  final int? category;

  Convention({
    required this.id,
    required this.name,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.position,
    required this.startDate,
    required this.endDate,
    this.description,
    this.websiteAddress,
    this.venueName,
    this.address1,
    this.address2,
    this.state,
    this.category,
  });

  factory Convention.fromJson(Map<String, dynamic> json) =>
      _$ConventionFromJson(json);

  Map<String, dynamic> toJson() => _$ConventionToJson(this);
}
