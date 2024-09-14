import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/features/issues/data/map_provider.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Visibility;

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
    final mapRead = ref.read(mapProvider);
    final mapWatch = ref.watch(mapProvider);
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Visibility(
                visible: mapWatch.isIssuesLoading,
                child: const LinearProgressIndicator()),
            Expanded(
              child: MapWidget(
                styleUri:
                    "mapbox://styles/jeremiahseun/cm0ud5srb00qo01qub70them8",
                onMapLoadedListener: (mapLoadedEventData) =>
                    ref.read(mapProvider.notifier).getCurrentLocation(),
                onStyleLoadedListener: (styleLoadedEventData) => ref
                    .read(mapProvider.notifier)
                    .onStyleLoaded(styleLoadedEventData),
                key: const ValueKey("mapWidget"),
                onMapCreated: (map) => mapRead.onMapCreated(map),
              ),
            ),
            const SizedBox(height: 40, width: double.infinity, child: Text(""))
          ],
        ));
  }
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}
