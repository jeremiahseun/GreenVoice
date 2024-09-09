import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

final mapProvider =
    ChangeNotifierProvider<MapProvider>((ref) => MapProvider(ref));

class MapProvider extends ChangeNotifier {
  final Ref ref;
  MapProvider(this.ref);
  MapboxMap? mapboxMap;

  void onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }
}
