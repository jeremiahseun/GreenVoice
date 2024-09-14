import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/src/features/issues/data/issues_provider.dart';
import 'package:greenvoice/src/features/issues/presentation/maps/map_view.dart';
import 'package:greenvoice/src/models/user/issue/issue_model.dart';
import 'package:greenvoice/src/services/location_service.dart';
import 'package:greenvoice/utils/styles/styles.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

final mapProvider =
    ChangeNotifierProvider<MapProvider>((ref) => MapProvider(ref));

class MapProvider extends ChangeNotifier {
  final Ref ref;
  MapProvider(this.ref);
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  Point? currentPointLocation;
  ByteData? bytes;
  bool isIssuesLoading = false;
  bool isMarkerLoading = false;
  IssueModel? selectedIssue;

  bool isCarouselVisible = true;

  void toggleCarouselVisibility() {
    isCarouselVisible = !isCarouselVisible;
    notifyListeners();
  }

  void onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    getCurrentLocation();
    mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true));
  }

  final locationService = locator<LocationService>();

  Future<void> removeAllAnnotations() async {
    await pointAnnotationManager?.deleteAll();
  }

  void updateAnnotation() {
    if (pointAnnotationManager != null) {
      // pointAnnotationManager?.update(annotation)
    }
  }

  Future<void> setCameraBounds(List<Point> points) async {
    if (points.isEmpty) return;
    log("Setting camera bounds");
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLon = double.infinity;
    double maxLon = -double.infinity;

    for (var point in points) {
      minLat = math.min(minLat, point.coordinates[1]!.toDouble());
      maxLat = math.max(maxLat, point.coordinates[1]!.toDouble());
      minLon = math.min(minLon, point.coordinates[0]!.toDouble());
      maxLon = math.max(maxLon, point.coordinates[0]!.toDouble());
    }

    await mapboxMap?.flyTo(
        CameraOptions(
            anchor: ScreenCoordinate(x: 0, y: 0),
            bearing: 90,
            pitch: 30,
            zoom: 17,
            center: points.first),
        MapAnimationOptions(
          duration: 2000,
        ));

    //* Camera Bound not working. Try later
    // CameraBoundsOptions bounds = CameraBoundsOptions(
    //   bounds: CoordinateBounds(
    //     southwest: Point(coordinates: Position(minLon, minLat)),
    //     northeast: Point(coordinates: Position(maxLon, maxLat)),
    //     infiniteBounds: false,
    //   ),
    // );
    // final cameraBound = await mapboxMap?.cameraForCoordinateBounds(
    //     CoordinateBounds(
    //       southwest: Point(coordinates: Position(minLon, minLat)),
    //       northeast: Point(coordinates: Position(maxLon, maxLat)),
    //       infiniteBounds: true,
    //     ),
    //     MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
    //     10,
    //     20,
    //     null,
    //     null);
    // // await mapboxMap?.setBounds(bounds);
    // log("Setting camera zoom");
    // await mapboxMap?.setCamera(cameraBound!);
  }

  Future<PointAnnotationManager?> getPointAnnotationManager() async {
    return await mapboxMap?.annotations.createPointAnnotationManager();
  }

  Future<Uint8List> loadCustomMarker() async {
    // Load your custom marker image
    bytes ??= await rootBundle.load('assets/icons/earth.png');
    final Uint8List list = bytes!.buffer.asUint8List();
    return list;
  }

  void onStyleLoaded(StyleLoadedEventData styleLoadedEventData) async {
    // Get the PointAnnotationManager
    pointAnnotationManager = await getPointAnnotationManager();
    final list = await loadCustomMarker();
    await loadInitialMarkers(list);
  }

  Future<void> loadInitialMarkers(Uint8List image) async {
    //* Get the lat and lon from the loaded issues
    ref.watch(issuesProvider).when(data: (data) async {
      isIssuesLoading = false;
      if (data.isEmpty) {
        //* Stop loading at this point.
        isMarkerLoading = false;
        notifyListeners();
        return;
      }
      isMarkerLoading = true;
      notifyListeners();
      //* ONLY TRY TO CREATE MARKER WHEN ISSUES ARE LOADED
      List<PointAnnotationOptions> options = <PointAnnotationOptions>[];
      List<Point> points = [];
      // Create a point annotation options
      for (var i = 0; i < data.length; i++) {
        final issue = data[i];
        final point = Point(
            coordinates: Position(
                double.parse(issue.longitude), double.parse(issue.latitude)));

        // Add the point to the list of points for camera bounds
        points.add(point);
        options.add(PointAnnotationOptions(
          geometry: point,
          image: image,
          iconSize: .3,
          textField: data[i].title,
          textOffset: [0.0, -3.0],
          textColor: AppColors.primaryColor.value,
        ));
        log("Adding point annotation to list ${options.length}");
      }

      // Confirm that the point annotation manager is available
      pointAnnotationManager ??= await getPointAnnotationManager();

      // Add the point annotations to the map
      await pointAnnotationManager?.createMulti(options);
      pointAnnotationManager!
          .addOnPointAnnotationClickListener(AnnotationClickListener(this));
      isMarkerLoading = false;
      notifyListeners();

      //* Animate camera bounds
      await setCameraBounds(points);
    }, error: (err, trace) {
      isIssuesLoading = false;
      notifyListeners();
    }, loading: () {
      isIssuesLoading = true;
      notifyListeners();
    });
  }

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

  void selectIssue(IssueModel issue) {
    selectedIssue = issue.copyWith(id: issue.id);
    notifyListeners();
    _moveCamera(issue);
  }

  void _moveCamera(IssueModel issue) {
    final cameraOptions = CameraOptions(
      center: Point(
          coordinates: Position(
              double.parse(issue.longitude), double.parse(issue.latitude))),
      zoom: 15.0,
    );
    mapboxMap?.flyTo(cameraOptions, MapAnimationOptions(duration: 500));
  }

  void onAnnotationClick(PointAnnotation annotation) {
    final clickedIssue = ref.read(issuesProvider).value?.firstWhere(
          (issue) =>
              issue.longitude ==
                  annotation.geometry.coordinates[0].toString() &&
              issue.latitude == annotation.geometry.coordinates[1].toString(),
        );

    if (clickedIssue != null) {
      selectIssue(clickedIssue);
    }
  }
}
