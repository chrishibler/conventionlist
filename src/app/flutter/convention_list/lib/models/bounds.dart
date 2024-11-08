import 'package:freezed_annotation/freezed_annotation.dart';

part 'bounds.freezed.dart';
part 'bounds.g.dart';

@freezed
class Bounds with _$Bounds {
  const factory Bounds({
    required double north,
    required double south,
    required double east,
    required double west,
  }) = _Bounds;

  factory Bounds.fromJson(Map<String, dynamic> json) => _$BoundsFromJson(json);
}
