// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manage_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ManageState {
  bool get isAdmin => throw _privateConstructorUsedError;

  /// Create a copy of ManageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManageStateCopyWith<ManageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManageStateCopyWith<$Res> {
  factory $ManageStateCopyWith(
          ManageState value, $Res Function(ManageState) then) =
      _$ManageStateCopyWithImpl<$Res, ManageState>;
  @useResult
  $Res call({bool isAdmin});
}

/// @nodoc
class _$ManageStateCopyWithImpl<$Res, $Val extends ManageState>
    implements $ManageStateCopyWith<$Res> {
  _$ManageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAdmin = null,
  }) {
    return _then(_value.copyWith(
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManageStateImplCopyWith<$Res>
    implements $ManageStateCopyWith<$Res> {
  factory _$$ManageStateImplCopyWith(
          _$ManageStateImpl value, $Res Function(_$ManageStateImpl) then) =
      __$$ManageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isAdmin});
}

/// @nodoc
class __$$ManageStateImplCopyWithImpl<$Res>
    extends _$ManageStateCopyWithImpl<$Res, _$ManageStateImpl>
    implements _$$ManageStateImplCopyWith<$Res> {
  __$$ManageStateImplCopyWithImpl(
      _$ManageStateImpl _value, $Res Function(_$ManageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAdmin = null,
  }) {
    return _then(_$ManageStateImpl(
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ManageStateImpl implements _ManageState {
  const _$ManageStateImpl({required this.isAdmin});

  @override
  final bool isAdmin;

  @override
  String toString() {
    return 'ManageState(isAdmin: $isAdmin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManageStateImpl &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isAdmin);

  /// Create a copy of ManageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManageStateImplCopyWith<_$ManageStateImpl> get copyWith =>
      __$$ManageStateImplCopyWithImpl<_$ManageStateImpl>(this, _$identity);
}

abstract class _ManageState implements ManageState {
  const factory _ManageState({required final bool isAdmin}) = _$ManageStateImpl;

  @override
  bool get isAdmin;

  /// Create a copy of ManageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManageStateImplCopyWith<_$ManageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
