// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomePageState {
  OrderBy get orderBy => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(OrderBy orderBy) $default, {
    required TResult Function(OrderBy orderBy) initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(OrderBy orderBy)? $default, {
    TResult? Function(OrderBy orderBy)? initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(OrderBy orderBy)? $default, {
    TResult Function(OrderBy orderBy)? initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HomePageState value) $default, {
    required TResult Function(_HomePageStateInitial value) initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HomePageState value)? $default, {
    TResult? Function(_HomePageStateInitial value)? initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HomePageState value)? $default, {
    TResult Function(_HomePageStateInitial value)? initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of HomePageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomePageStateCopyWith<HomePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageStateCopyWith<$Res> {
  factory $HomePageStateCopyWith(
          HomePageState value, $Res Function(HomePageState) then) =
      _$HomePageStateCopyWithImpl<$Res, HomePageState>;
  @useResult
  $Res call({OrderBy orderBy});
}

/// @nodoc
class _$HomePageStateCopyWithImpl<$Res, $Val extends HomePageState>
    implements $HomePageStateCopyWith<$Res> {
  _$HomePageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomePageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderBy = null,
  }) {
    return _then(_value.copyWith(
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as OrderBy,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomePageStateImplCopyWith<$Res>
    implements $HomePageStateCopyWith<$Res> {
  factory _$$HomePageStateImplCopyWith(
          _$HomePageStateImpl value, $Res Function(_$HomePageStateImpl) then) =
      __$$HomePageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({OrderBy orderBy});
}

/// @nodoc
class __$$HomePageStateImplCopyWithImpl<$Res>
    extends _$HomePageStateCopyWithImpl<$Res, _$HomePageStateImpl>
    implements _$$HomePageStateImplCopyWith<$Res> {
  __$$HomePageStateImplCopyWithImpl(
      _$HomePageStateImpl _value, $Res Function(_$HomePageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomePageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderBy = null,
  }) {
    return _then(_$HomePageStateImpl(
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as OrderBy,
    ));
  }
}

/// @nodoc

class _$HomePageStateImpl implements _HomePageState {
  const _$HomePageStateImpl({required this.orderBy});

  @override
  final OrderBy orderBy;

  @override
  String toString() {
    return 'HomePageState(orderBy: $orderBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomePageStateImpl &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderBy);

  /// Create a copy of HomePageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomePageStateImplCopyWith<_$HomePageStateImpl> get copyWith =>
      __$$HomePageStateImplCopyWithImpl<_$HomePageStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(OrderBy orderBy) $default, {
    required TResult Function(OrderBy orderBy) initial,
  }) {
    return $default(orderBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(OrderBy orderBy)? $default, {
    TResult? Function(OrderBy orderBy)? initial,
  }) {
    return $default?.call(orderBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(OrderBy orderBy)? $default, {
    TResult Function(OrderBy orderBy)? initial,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(orderBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HomePageState value) $default, {
    required TResult Function(_HomePageStateInitial value) initial,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HomePageState value)? $default, {
    TResult? Function(_HomePageStateInitial value)? initial,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HomePageState value)? $default, {
    TResult Function(_HomePageStateInitial value)? initial,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _HomePageState implements HomePageState {
  const factory _HomePageState({required final OrderBy orderBy}) =
      _$HomePageStateImpl;

  @override
  OrderBy get orderBy;

  /// Create a copy of HomePageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomePageStateImplCopyWith<_$HomePageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HomePageStateInitialImplCopyWith<$Res>
    implements $HomePageStateCopyWith<$Res> {
  factory _$$HomePageStateInitialImplCopyWith(_$HomePageStateInitialImpl value,
          $Res Function(_$HomePageStateInitialImpl) then) =
      __$$HomePageStateInitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({OrderBy orderBy});
}

/// @nodoc
class __$$HomePageStateInitialImplCopyWithImpl<$Res>
    extends _$HomePageStateCopyWithImpl<$Res, _$HomePageStateInitialImpl>
    implements _$$HomePageStateInitialImplCopyWith<$Res> {
  __$$HomePageStateInitialImplCopyWithImpl(_$HomePageStateInitialImpl _value,
      $Res Function(_$HomePageStateInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomePageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderBy = null,
  }) {
    return _then(_$HomePageStateInitialImpl(
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as OrderBy,
    ));
  }
}

/// @nodoc

class _$HomePageStateInitialImpl implements _HomePageStateInitial {
  const _$HomePageStateInitialImpl({required this.orderBy});

  @override
  final OrderBy orderBy;

  @override
  String toString() {
    return 'HomePageState.initial(orderBy: $orderBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomePageStateInitialImpl &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderBy);

  /// Create a copy of HomePageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomePageStateInitialImplCopyWith<_$HomePageStateInitialImpl>
      get copyWith =>
          __$$HomePageStateInitialImplCopyWithImpl<_$HomePageStateInitialImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(OrderBy orderBy) $default, {
    required TResult Function(OrderBy orderBy) initial,
  }) {
    return initial(orderBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(OrderBy orderBy)? $default, {
    TResult? Function(OrderBy orderBy)? initial,
  }) {
    return initial?.call(orderBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(OrderBy orderBy)? $default, {
    TResult Function(OrderBy orderBy)? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(orderBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HomePageState value) $default, {
    required TResult Function(_HomePageStateInitial value) initial,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HomePageState value)? $default, {
    TResult? Function(_HomePageStateInitial value)? initial,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HomePageState value)? $default, {
    TResult Function(_HomePageStateInitial value)? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _HomePageStateInitial implements HomePageState {
  const factory _HomePageStateInitial({required final OrderBy orderBy}) =
      _$HomePageStateInitialImpl;

  @override
  OrderBy get orderBy;

  /// Create a copy of HomePageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomePageStateInitialImplCopyWith<_$HomePageStateInitialImpl>
      get copyWith => throw _privateConstructorUsedError;
}
