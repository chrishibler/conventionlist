import 'package:freezed_annotation/freezed_annotation.dart';

import 'convention.dart';

part 'response_page.freezed.dart';
part 'response_page.g.dart';

@freezed
class ResponsePage with _$ResponsePage {
  const factory ResponsePage({
    required int totalCount,
    required int totalPages,
    required int currentPage,
    required int pageSize,
    required List<Convention> conventions,
  }) = _ResponsePage;

  factory ResponsePage.fromJson(Map<String, dynamic> json) => _$ResponsePageFromJson(json);
}
