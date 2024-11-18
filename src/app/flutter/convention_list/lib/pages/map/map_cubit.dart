import 'package:convention_list/services/geo_service.dart';
import 'package:convention_list/util/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/bounds.dart' as api_bounds;
import '../../models/convention.dart';
import '../../models/position.dart';
import '../../models/response_page.dart';
import '../../services/api.dart';

part 'map_cubit.freezed.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final Api api;
  final cameraChangedSubject = BehaviorSubject<LatLngBounds>();

  MapCubit({required this.api, required GeoService geoService}) : super(const MapState()) {
    geoService.getPosition().then(
          (p) => emit(
            state.copyWith(position: p, hasPosition: true),
          ),
        );

    cameraChangedSubject.debounceTime(const Duration(milliseconds: 500)).listen(getConventions);
  }

  Future<void> getConventions(LatLngBounds bounds) async {
    var apiBounds = api_bounds.Bounds(
      north: bounds.north,
      south: bounds.south,
      east: bounds.east,
      west: bounds.west,
    );

    bool hasMore = true;
    int pageKey = 1;
    List<Convention> conventions = [];
    while (hasMore) {
      ResponsePage page = await api.getConventionsByBounds(
        pageKey: pageKey,
        bounds: apiBounds,
      );
      conventions.addAll(page.conventions);
      hasMore = pageKey < page.totalPages;
      pageKey++;
    }
    emit(state.copyWith(conventions: conventions));
  }
}

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(false) bool hasPosition,
    @Default(defaultPosition) Position position,
    @Default([]) List<Convention> conventions,
  }) = _MapState;
}
