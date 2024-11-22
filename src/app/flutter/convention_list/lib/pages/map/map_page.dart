import 'package:convention_list/util/tile_providers.dart';
import 'package:convention_list/widgets/convention_list/convention_info.dart';
import 'package:convention_list/widgets/drawer/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../injection.dart';
import '../../models/convention.dart';
import '../../widgets/app_progress_indicator.dart';
import 'map_cubit.dart';

class MapPage extends StatelessWidget {
  final MapController controller = MapController();

  MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convention Map'),
        centerTitle: true,
      ),
      endDrawer: const AppDrawer(),
      body: BlocProvider(
        create: (context) => getIt<MapCubit>(),
        lazy: false,
        child: BlocBuilder<MapCubit, MapState>(builder: (context, state) {
          if (!state.hasPosition) {
            return const Center(child: AppProgressIndicator());
          }
          var lat = state.position.latitude;
          var lng = state.position.longitude;
          return FlutterMap(
              mapController: controller,
              options: MapOptions(
                initialCenter: LatLng(lat, lng),
                initialZoom: 6,
                onPositionChanged: (camera, whoKnows) {
                  MapCubit cubit = context.read<MapCubit>();
                  cubit.cameraChangedSubject.add(camera.visibleBounds);
                },
                onMapReady: () {
                  MapCubit cubit = context.read<MapCubit>();
                  cubit.cameraChangedSubject.add(controller.camera.visibleBounds);
                },
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                openStreetMapTileLayer,
                MarkerLayer(
                  markers: state.conventions
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
      ),
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
