import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/features/issues/application/map_provider.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  @override
  Widget build(BuildContext context) {
    final mapRead = ref.watch(mapProvider);
    return Scaffold(
        body: MapWidget(
      key: const ValueKey("mapWidget"),
      onMapCreated: (map) => mapRead.onMapCreated(map),
    ));
  }
}
