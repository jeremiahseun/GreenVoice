import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/src/services/location_service.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

final mapProvider =
    ChangeNotifierProvider<MapProvider>((ref) => MapProvider(ref));

class MapProvider extends ChangeNotifier {
  final Ref ref;
  MapProvider(this.ref);
  MapboxMap? mapboxMap;
  Point? currentPointLocation;

  void onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    getCurrentLocation();
    mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true));
  }

  final locationService = locator<LocationService>();

  Future<void> getCurrentLocation() async {
    log("Getting user location");
    final position = await locationService.getCurrentLocation();
    if (position != null) {
      log("Got user location: Lat ${position.latitude} and Long ${position.longitude}");
      currentPointLocation = Point(
          coordinates: Position(
              position.longitude, position.latitude, position.altitude));
      await mapboxMap?.flyTo(
          CameraOptions(
              anchor: ScreenCoordinate(x: 0, y: 0),
              bearing: 180,
              pitch: 55,
              zoom: 18,
              center: currentPointLocation),
          MapAnimationOptions(
            duration: 2000,
          ));
    }
  }
}
