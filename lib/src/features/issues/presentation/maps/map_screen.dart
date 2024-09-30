import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/features/issues/data/issues_provider.dart';
import 'package:greenvoice/src/features/issues/data/map_provider.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Visibility;

import 'issue_carousel.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapProvider.notifier).getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapRead = ref.read(mapProvider.notifier);
    final mapWatch = ref.watch(mapProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: mapRead.toggleCarouselVisibility,
              child: Column(
                children: [
                  if (mapWatch.isIssuesLoading) const LinearProgressIndicator(),
                  Expanded(
                    child: MapWidget(
                      styleUri: dotenv.env['MAP_STYLE']!,
                      onStyleLoadedListener: mapRead.onStyleLoaded,
                      key: const ValueKey("mapWidget"),
                      onMapCreated: mapRead.onMapCreated,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 30,
              left: 20,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const BackButton(),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: IssueCarousel(
                isVisible: mapWatch.isCarouselVisible,
                onToggleVisibility: mapRead.toggleCarouselVisibility,
                issues: ref.watch(issuesProvider).when(
                    data: (data) => data,
                    error: (_, s) => [],
                    loading: () => []),
                onIssueSelected: mapRead.selectIssue,
                selectedIssueId: mapWatch.selectedIssue?.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  final MapProvider mapProvider;

  AnnotationClickListener(this.mapProvider);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    mapProvider.onAnnotationClick(annotation);
  }
}
