// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_drawer_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppDrawerState {
  bool get isLoggedIn => throw _privateConstructorUsedError;

  /// Create a copy of AppDrawerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppDrawerStateCopyWith<AppDrawerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppDrawerStateCopyWith<$Res> {
  factory $AppDrawerStateCopyWith(
          AppDrawerState value, $Res Function(AppDrawerState) then) =
      _$AppDrawerStateCopyWithImpl<$Res, AppDrawerState>;
  @useResult
  $Res call({bool isLoggedIn});
}

/// @nodoc
class _$AppDrawerStateCopyWithImpl<$Res, $Val extends AppDrawerState>
    implements $AppDrawerStateCopyWith<$Res> {
  _$AppDrawerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppDrawerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoggedIn = null,
  }) {
    return _then(_value.copyWith(
      isLoggedIn: null == isLoggedIn
          ? _value.isLoggedIn
          : isLoggedIn // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppDrawerStateImplCopyWith<$Res>
    implements $AppDrawerStateCopyWith<$Res> {
  factory _$$AppDrawerStateImplCopyWith(_$AppDrawerStateImpl value,
          $Res Function(_$AppDrawerStateImpl) then) =
      __$$AppDrawerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoggedIn});
}

/// @nodoc
class __$$AppDrawerStateImplCopyWithImpl<$Res>
    extends _$AppDrawerStateCopyWithImpl<$Res, _$AppDrawerStateImpl>
    implements _$$AppDrawerStateImplCopyWith<$Res> {
  __$$AppDrawerStateImplCopyWithImpl(
      _$AppDrawerStateImpl _value, $Res Function(_$AppDrawerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppDrawerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoggedIn = null,
  }) {
    return _then(_$AppDrawerStateImpl(
      isLoggedIn: null == isLoggedIn
          ? _value.isLoggedIn
          : isLoggedIn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AppDrawerStateImpl implements _AppDrawerState {
  const _$AppDrawerStateImpl({required this.isLoggedIn});

  @override
  final bool isLoggedIn;

  @override
  String toString() {
    return 'AppDrawerState(isLoggedIn: $isLoggedIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDrawerStateImpl &&
            (identical(other.isLoggedIn, isLoggedIn) ||
                other.isLoggedIn == isLoggedIn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoggedIn);

  /// Create a copy of AppDrawerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppDrawerStateImplCopyWith<_$AppDrawerStateImpl> get copyWith =>
      __$$AppDrawerStateImplCopyWithImpl<_$AppDrawerStateImpl>(
          this, _$identity);
}

abstract class _AppDrawerState implements AppDrawerState {
  const factory _AppDrawerState({required final bool isLoggedIn}) =
      _$AppDrawerStateImpl;

  @override
  bool get isLoggedIn;

  /// Create a copy of AppDrawerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppDrawerStateImplCopyWith<_$AppDrawerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
