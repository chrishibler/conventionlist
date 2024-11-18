// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_edit_view_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddEditViewState {
  Convention? get convention => throw _privateConstructorUsedError;
  bool get isFinished => throw _privateConstructorUsedError;
  bool get isAdmin => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of AddEditViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddEditViewStateCopyWith<AddEditViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddEditViewStateCopyWith<$Res> {
  factory $AddEditViewStateCopyWith(
          AddEditViewState value, $Res Function(AddEditViewState) then) =
      _$AddEditViewStateCopyWithImpl<$Res, AddEditViewState>;
  @useResult
  $Res call(
      {Convention? convention,
      bool isFinished,
      bool isAdmin,
      bool isBusy,
      String? error});

  $ConventionCopyWith<$Res>? get convention;
}

/// @nodoc
class _$AddEditViewStateCopyWithImpl<$Res, $Val extends AddEditViewState>
    implements $AddEditViewStateCopyWith<$Res> {
  _$AddEditViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddEditViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? convention = freezed,
    Object? isFinished = null,
    Object? isAdmin = null,
    Object? isBusy = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      convention: freezed == convention
          ? _value.convention
          : convention // ignore: cast_nullable_to_non_nullable
              as Convention?,
      isFinished: null == isFinished
          ? _value.isFinished
          : isFinished // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AddEditViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConventionCopyWith<$Res>? get convention {
    if (_value.convention == null) {
      return null;
    }

    return $ConventionCopyWith<$Res>(_value.convention!, (value) {
      return _then(_value.copyWith(convention: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AddEditViewStateImplCopyWith<$Res>
    implements $AddEditViewStateCopyWith<$Res> {
  factory _$$AddEditViewStateImplCopyWith(_$AddEditViewStateImpl value,
          $Res Function(_$AddEditViewStateImpl) then) =
      __$$AddEditViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Convention? convention,
      bool isFinished,
      bool isAdmin,
      bool isBusy,
      String? error});

  @override
  $ConventionCopyWith<$Res>? get convention;
}

/// @nodoc
class __$$AddEditViewStateImplCopyWithImpl<$Res>
    extends _$AddEditViewStateCopyWithImpl<$Res, _$AddEditViewStateImpl>
    implements _$$AddEditViewStateImplCopyWith<$Res> {
  __$$AddEditViewStateImplCopyWithImpl(_$AddEditViewStateImpl _value,
      $Res Function(_$AddEditViewStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddEditViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? convention = freezed,
    Object? isFinished = null,
    Object? isAdmin = null,
    Object? isBusy = null,
    Object? error = freezed,
  }) {
    return _then(_$AddEditViewStateImpl(
      convention: freezed == convention
          ? _value.convention
          : convention // ignore: cast_nullable_to_non_nullable
              as Convention?,
      isFinished: null == isFinished
          ? _value.isFinished
          : isFinished // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AddEditViewStateImpl implements _AddEditViewState {
  const _$AddEditViewStateImpl(
      {this.convention,
      this.isFinished = false,
      this.isAdmin = false,
      this.isBusy = false,
      this.error});

  @override
  final Convention? convention;
  @override
  @JsonKey()
  final bool isFinished;
  @override
  @JsonKey()
  final bool isAdmin;
  @override
  @JsonKey()
  final bool isBusy;
  @override
  final String? error;

  @override
  String toString() {
    return 'AddEditViewState(convention: $convention, isFinished: $isFinished, isAdmin: $isAdmin, isBusy: $isBusy, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddEditViewStateImpl &&
            (identical(other.convention, convention) ||
                other.convention == convention) &&
            (identical(other.isFinished, isFinished) ||
                other.isFinished == isFinished) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, convention, isFinished, isAdmin, isBusy, error);

  /// Create a copy of AddEditViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddEditViewStateImplCopyWith<_$AddEditViewStateImpl> get copyWith =>
      __$$AddEditViewStateImplCopyWithImpl<_$AddEditViewStateImpl>(
          this, _$identity);
}

abstract class _AddEditViewState implements AddEditViewState {
  const factory _AddEditViewState(
      {final Convention? convention,
      final bool isFinished,
      final bool isAdmin,
      final bool isBusy,
      final String? error}) = _$AddEditViewStateImpl;

  @override
  Convention? get convention;
  @override
  bool get isFinished;
  @override
  bool get isAdmin;
  @override
  bool get isBusy;
  @override
  String? get error;

  /// Create a copy of AddEditViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddEditViewStateImplCopyWith<_$AddEditViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
