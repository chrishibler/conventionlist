// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'convention.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Convention _$ConventionFromJson(Map<String, dynamic> json) {
  return _Convention.fromJson(json);
}

/// @nodoc
mixin _$Convention {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  Position? get position => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get websiteAddress => throw _privateConstructorUsedError;
  String? get venueName => throw _privateConstructorUsedError;
  String? get address1 => throw _privateConstructorUsedError;
  String? get address2 => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  int? get category => throw _privateConstructorUsedError;

  /// Serializes this Convention to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Convention
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConventionCopyWith<Convention> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConventionCopyWith<$Res> {
  factory $ConventionCopyWith(
          Convention value, $Res Function(Convention) then) =
      _$ConventionCopyWithImpl<$Res, Convention>;
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime startDate,
      DateTime endDate,
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
      int? category});

  $PositionCopyWith<$Res>? get position;
}

/// @nodoc
class _$ConventionCopyWithImpl<$Res, $Val extends Convention>
    implements $ConventionCopyWith<$Res> {
  _$ConventionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Convention
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? city = freezed,
    Object? country = freezed,
    Object? postalCode = freezed,
    Object? position = freezed,
    Object? description = freezed,
    Object? websiteAddress = freezed,
    Object? venueName = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? state = freezed,
    Object? category = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Position?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteAddress: freezed == websiteAddress
          ? _value.websiteAddress
          : websiteAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      address1: freezed == address1
          ? _value.address1
          : address1 // ignore: cast_nullable_to_non_nullable
              as String?,
      address2: freezed == address2
          ? _value.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of Convention
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res>? get position {
    if (_value.position == null) {
      return null;
    }

    return $PositionCopyWith<$Res>(_value.position!, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConventionImplCopyWith<$Res>
    implements $ConventionCopyWith<$Res> {
  factory _$$ConventionImplCopyWith(
          _$ConventionImpl value, $Res Function(_$ConventionImpl) then) =
      __$$ConventionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime startDate,
      DateTime endDate,
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
      int? category});

  @override
  $PositionCopyWith<$Res>? get position;
}

/// @nodoc
class __$$ConventionImplCopyWithImpl<$Res>
    extends _$ConventionCopyWithImpl<$Res, _$ConventionImpl>
    implements _$$ConventionImplCopyWith<$Res> {
  __$$ConventionImplCopyWithImpl(
      _$ConventionImpl _value, $Res Function(_$ConventionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Convention
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? city = freezed,
    Object? country = freezed,
    Object? postalCode = freezed,
    Object? position = freezed,
    Object? description = freezed,
    Object? websiteAddress = freezed,
    Object? venueName = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? state = freezed,
    Object? category = freezed,
  }) {
    return _then(_$ConventionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Position?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteAddress: freezed == websiteAddress
          ? _value.websiteAddress
          : websiteAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      address1: freezed == address1
          ? _value.address1
          : address1 // ignore: cast_nullable_to_non_nullable
              as String?,
      address2: freezed == address2
          ? _value.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConventionImpl extends _Convention {
  const _$ConventionImpl(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.endDate,
      this.city,
      this.country,
      this.postalCode,
      this.position,
      this.description,
      this.websiteAddress,
      this.venueName,
      this.address1,
      this.address2,
      this.state,
      this.category})
      : super._();

  factory _$ConventionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConventionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final String? postalCode;
  @override
  final Position? position;
  @override
  final String? description;
  @override
  final String? websiteAddress;
  @override
  final String? venueName;
  @override
  final String? address1;
  @override
  final String? address2;
  @override
  final String? state;
  @override
  final int? category;

  @override
  String toString() {
    return 'Convention(id: $id, name: $name, startDate: $startDate, endDate: $endDate, city: $city, country: $country, postalCode: $postalCode, position: $position, description: $description, websiteAddress: $websiteAddress, venueName: $venueName, address1: $address1, address2: $address2, state: $state, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConventionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.websiteAddress, websiteAddress) ||
                other.websiteAddress == websiteAddress) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.address1, address1) ||
                other.address1 == address1) &&
            (identical(other.address2, address2) ||
                other.address2 == address2) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      startDate,
      endDate,
      city,
      country,
      postalCode,
      position,
      description,
      websiteAddress,
      venueName,
      address1,
      address2,
      state,
      category);

  /// Create a copy of Convention
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConventionImplCopyWith<_$ConventionImpl> get copyWith =>
      __$$ConventionImplCopyWithImpl<_$ConventionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConventionImplToJson(
      this,
    );
  }
}

abstract class _Convention extends Convention {
  const factory _Convention(
      {required final String id,
      required final String name,
      required final DateTime startDate,
      required final DateTime endDate,
      final String? city,
      final String? country,
      final String? postalCode,
      final Position? position,
      final String? description,
      final String? websiteAddress,
      final String? venueName,
      final String? address1,
      final String? address2,
      final String? state,
      final int? category}) = _$ConventionImpl;
  const _Convention._() : super._();

  factory _Convention.fromJson(Map<String, dynamic> json) =
      _$ConventionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String? get city;
  @override
  String? get country;
  @override
  String? get postalCode;
  @override
  Position? get position;
  @override
  String? get description;
  @override
  String? get websiteAddress;
  @override
  String? get venueName;
  @override
  String? get address1;
  @override
  String? get address2;
  @override
  String? get state;
  @override
  int? get category;

  /// Create a copy of Convention
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConventionImplCopyWith<_$ConventionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
