import 'package:json_annotation/json_annotation.dart';

import 'convention.dart';

part 'response_page.g.dart';

@JsonSerializable()
class ResponsePage {
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<Convention> conventions;

  ResponsePage({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.conventions,
  });

  factory ResponsePage.fromJson(Map<String, dynamic> json) =>
      _$ResponsePageFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsePageToJson(this);
}
