import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/features/issues/data/map_provider.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  @override
  void initState() {
    ref.read(mapProvider.notifier).getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapRead = ref.watch(mapProvider);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => ref.read(mapProvider.notifier).getCurrentLocation(),
          child: const Icon(Icons.location_on),
        ),
        body: MapWidget(
          styleUri: "mapbox://styles/jeremiahseun/cm0ud5srb00qo01qub70them8",
          onMapLoadedListener: (mapLoadedEventData) =>
              ref.read(mapProvider.notifier).getCurrentLocation(),
          key: const ValueKey("mapWidget"),
          onMapCreated: (map) => mapRead.onMapCreated(map),
        ));
  }
}
