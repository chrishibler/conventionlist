import 'package:convention_list/services/geo_service.dart';
import 'package:convention_list/util/constants.dart';
import 'package:convention_list/util/tile_providers.dart';
import 'package:convention_list/widgets/convention_list/convention_info.dart';
import 'package:convention_list/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/rxdart.dart';

import '../injection.dart';
import '../models/bounds.dart' as api_bounds;
import '../models/convention.dart';
import '../models/position.dart';
import '../models/response_page.dart';
import '../services/api.dart';
import '../widgets/app_progress_indicator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  var cameraChangedSubject = BehaviorSubject<LatLngBounds>();
  MapController controller = MapController();
  Set<Convention> conventions = {};
  Future<Position> positionFuture = Future.value(defaultPosition);
  final Api api = getIt<Api>();
  final GeoService geoService = getIt<GeoService>();

  @override
  void initState() {
    positionFuture = _setupPosition();
    cameraChangedSubject.debounceTime(const Duration(milliseconds: 500)).listen((args) async {
      // conventions.clear();
      var bounds = api_bounds.Bounds(
        north: args.north,
        south: args.south,
        east: args.east,
        west: args.west,
      );

      bool hasMore = true;
      int pageKey = 1;
      while (hasMore) {
        ResponsePage page = await api.getConventionsByBounds(
          pageKey: pageKey,
          bounds: bounds,
        );
        setState(() {
          print(conventions.length);
          conventions.addAll(page.conventions);
        });
        hasMore = pageKey < page.totalPages;
        pageKey++;
      }
    });
    super.initState();
  }

  Future<Position> _setupPosition() async {
    try {
      return await geoService.getPosition();
    } catch (e) {
      print(e);
      return defaultPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convention Map'),
        centerTitle: true,
      ),
      endDrawer: const AppDrawer(),
      body: FutureBuilder<Position>(
          future: positionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              // Future not done, return a temporary loading widget
              return const Center(
                child: AppProgressIndicator(),
              );
            }
            var lat = snapshot.data!.latitude;
            var lng = snapshot.data!.longitude;
            return FlutterMap(
                mapController: controller,
                options: MapOptions(
                  initialCenter: LatLng(lat, lng),
                  initialZoom: 6,
                  onPositionChanged: (camera, whoKnows) {
                    cameraChangedSubject.add(camera.visibleBounds);
                  },
                  onMapReady: () {
                    cameraChangedSubject.add(controller.camera.visibleBounds);
                  },
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  openStreetMapTileLayer,
                  MarkerLayer(
                    markers: conventions
                        .map(
                          (c) => Marker(
                            point: LatLng(
                              c.position!.latitude,
                              c.position!.longitude,
                            ),
                            child: GestureDetector(
                              onTap: () => _showInfo(context, c),
                              child: Image.asset('assets/logo-sm-round.png'),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ]);
          }),
    );
  }
}

void _showInfo(BuildContext context, Convention convention) async {
  showBottomSheet(
    context: context,
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 0.3,
          child: ConventionInfo(convention: convention),
        ),
      );
    },
  );
}
