import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

import '../models/bounds.dart';
import '../models/convention.dart';
import '../models/position.dart' as model_position;
import 'api.dart';

class GeoService {
  static bool isEnabled = false;

  static Future<model_position.Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    isEnabled = true;
    var position = await Geolocator.getCurrentPosition();
    return model_position.Position(latitude: position.latitude, longitude: position.longitude);
  }

  static Future<void> addMarkers({
    required mapbox.MapboxMap map,
    required mapbox.PointAnnotationManager pointManager,
  }) async {
    var camera = await map.getCameraState();
    final bounds = await map.coordinateBoundsForCamera(mapbox.CameraOptions(
      center: camera.center,
      zoom: camera.zoom,
      pitch: camera.pitch,
    ));
    var ne = bounds.northeast.coordinates;
    var sw = bounds.southwest.coordinates;

    Bounds apiBounds = Bounds(
      north: ne.lat as double,
      south: sw.lat as double,
      east: ne.lng as double,
      west: sw.lng as double,
    );

    // Load the image from assets
    final ByteData bytes = await rootBundle.load('assets/logo-sm-round.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    var conventions = await Api().getAllConventionsByBounds(bounds: apiBounds);
    for (Convention c in conventions) {
      print(c.id);
      mapbox.PointAnnotationOptions pointAnnotationOptions = mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(
            coordinates: mapbox.Position(
              c.position!.longitude,
              c.position!.latitude,
            ),
          ),
          image: imageData,
          textOpacity: 0,
          textField: c.id,
          iconSize: 0.4);

      pointManager.create(pointAnnotationOptions);
    }
  }
}
