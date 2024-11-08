// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'response_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResponsePage _$ResponsePageFromJson(Map<String, dynamic> json) {
  return _ResponsePage.fromJson(json);
}

/// @nodoc
mixin _$ResponsePage {
  int get totalCount => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  List<Convention> get conventions => throw _privateConstructorUsedError;

  /// Serializes this ResponsePage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResponsePage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResponsePageCopyWith<ResponsePage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponsePageCopyWith<$Res> {
  factory $ResponsePageCopyWith(
          ResponsePage value, $Res Function(ResponsePage) then) =
      _$ResponsePageCopyWithImpl<$Res, ResponsePage>;
  @useResult
  $Res call(
      {int totalCount,
      int totalPages,
      int currentPage,
      int pageSize,
      List<Convention> conventions});
}

/// @nodoc
class _$ResponsePageCopyWithImpl<$Res, $Val extends ResponsePage>
    implements $ResponsePageCopyWith<$Res> {
  _$ResponsePageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResponsePage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? totalPages = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? conventions = null,
  }) {
    return _then(_value.copyWith(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      conventions: null == conventions
          ? _value.conventions
          : conventions // ignore: cast_nullable_to_non_nullable
              as List<Convention>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResponsePageImplCopyWith<$Res>
    implements $ResponsePageCopyWith<$Res> {
  factory _$$ResponsePageImplCopyWith(
          _$ResponsePageImpl value, $Res Function(_$ResponsePageImpl) then) =
      __$$ResponsePageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalCount,
      int totalPages,
      int currentPage,
      int pageSize,
      List<Convention> conventions});
}

/// @nodoc
class __$$ResponsePageImplCopyWithImpl<$Res>
    extends _$ResponsePageCopyWithImpl<$Res, _$ResponsePageImpl>
    implements _$$ResponsePageImplCopyWith<$Res> {
  __$$ResponsePageImplCopyWithImpl(
      _$ResponsePageImpl _value, $Res Function(_$ResponsePageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResponsePage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? totalPages = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? conventions = null,
  }) {
    return _then(_$ResponsePageImpl(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      conventions: null == conventions
          ? _value._conventions
          : conventions // ignore: cast_nullable_to_non_nullable
              as List<Convention>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResponsePageImpl implements _ResponsePage {
  const _$ResponsePageImpl(
      {required this.totalCount,
      required this.totalPages,
      required this.currentPage,
      required this.pageSize,
      required final List<Convention> conventions})
      : _conventions = conventions;

  factory _$ResponsePageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResponsePageImplFromJson(json);

  @override
  final int totalCount;
  @override
  final int totalPages;
  @override
  final int currentPage;
  @override
  final int pageSize;
  final List<Convention> _conventions;
  @override
  List<Convention> get conventions {
    if (_conventions is EqualUnmodifiableListView) return _conventions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conventions);
  }

  @override
  String toString() {
    return 'ResponsePage(totalCount: $totalCount, totalPages: $totalPages, currentPage: $currentPage, pageSize: $pageSize, conventions: $conventions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponsePageImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            const DeepCollectionEquality()
                .equals(other._conventions, _conventions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalCount, totalPages,
      currentPage, pageSize, const DeepCollectionEquality().hash(_conventions));

  /// Create a copy of ResponsePage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponsePageImplCopyWith<_$ResponsePageImpl> get copyWith =>
      __$$ResponsePageImplCopyWithImpl<_$ResponsePageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResponsePageImplToJson(
      this,
    );
  }
}

abstract class _ResponsePage implements ResponsePage {
  const factory _ResponsePage(
      {required final int totalCount,
      required final int totalPages,
      required final int currentPage,
      required final int pageSize,
      required final List<Convention> conventions}) = _$ResponsePageImpl;

  factory _ResponsePage.fromJson(Map<String, dynamic> json) =
      _$ResponsePageImpl.fromJson;

  @override
  int get totalCount;
  @override
  int get totalPages;
  @override
  int get currentPage;
  @override
  int get pageSize;
  @override
  List<Convention> get conventions;

  /// Create a copy of ResponsePage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResponsePageImplCopyWith<_$ResponsePageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
