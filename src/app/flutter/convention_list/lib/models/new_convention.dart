import 'package:json_annotation/json_annotation.dart';

part 'new_convention.g.dart';

@JsonSerializable()
class NewConvention {
  final String name;
  DateTime startDate, endDate;
  final String? description, websiteAddress, venueName, address1, address2, postalCode, city, country, state;
  final int? category;

  NewConvention({
    required this.name,
    required this.startDate,
    required this.endDate,
    this.city,
    this.country,
    this.postalCode,
    this.description,
    this.websiteAddress,
    this.venueName,
    this.address1,
    this.address2,
    this.state,
    this.category,
  });

  factory NewConvention.fromJson(Map<String, dynamic> json) => _$NewConventionFromJson(json);

  Map<String, dynamic> toJson() => _$NewConventionToJson(this);
}
