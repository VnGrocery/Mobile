import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/widgets/map_projection.dart';
import 'package:vngrocery/widgets/osm_tile_map.dart';

/// What part of the world the map is looking at.
@immutable
class MapCamera {
  final GeoPoint center;
  final double zoom;

  const MapCamera({required this.center, required this.zoom});

  MapCamera copyWith({GeoPoint? center, double? zoom}) =>
      MapCamera(center: center ?? this.center, zoom: zoom ?? this.zoom);

  @override
  bool operator ==(Object other) =>
      other is MapCamera && other.center == center && other.zoom == zoom;

  @override
  int get hashCode => Object.hash(center, zoom);

  /// The camera after a drag or pinch, keeping the place that was under the
  /// fingers under them.
  ///
  /// Measured from where the gesture began rather than from the previous frame,
  /// so rounding cannot accumulate into drift over a long drag. A plain drag is
  /// this with [scale] of 1.
  static MapCamera transformed({
    required MapCamera start,
    required Size viewport,
    required Offset focalStart,
    required Offset focalNow,
    double scale = 1,
    double minZoom = 3,
    double maxZoom = 18,
  }) {
    if (viewport.isEmpty) return start;

    // A pinch reports scale as a ratio; zoom levels are its logarithm.
    final zoom = (start.zoom + _log2(scale)).clamp(minZoom, maxZoom);

    final before = MapProjection(
      center: start.center,
      zoom: start.zoom,
      viewport: viewport,
    );
    final anchor = before.unproject(focalStart);

    final after = MapProjection(
      center: start.center,
      zoom: zoom,
      viewport: viewport,
    );
    // How far the anchor has slipped from the fingers; move the centre by the
    // same amount to put it back.
    final drift = after.project(anchor) - focalNow;
    final center = after.unproject(
      Offset(viewport.width / 2, viewport.height / 2) + drift,
    );

    return MapCamera(center: _clampLatitude(center), zoom: zoom);
  }

  /// Web Mercator has no pixels past the poles; dragging there would show blank
  /// space and never come back.
  static GeoPoint _clampLatitude(GeoPoint point) => GeoPoint(
    point.latitude.clamp(MapProjection.minLatitude, MapProjection.maxLatitude),
    point.longitude,
  );

  static double _log2(double value) =>
      value <= 0 ? 0 : math.log(value) / math.ln2;
}

/// A map the reader can drag and pinch.
///
/// The map used to be a fixed picture: it opened at one place and nothing you
/// did to it moved it, so a shop pinned just off the edge could not be reached
/// at all.
class InteractiveMap extends StatefulWidget {
  final MapCamera initialCamera;

  /// Draws whatever sits on top of the tiles — pins, rings — positioned with
  /// the projection for the camera as it is right now.
  final Widget Function(BuildContext context, MapProjection projection)
  overlayBuilder;

  /// Reported after every gesture so a parent can keep its own state in step.
  final ValueChanged<MapCamera>? onCameraChanged;

  /// False renders the same view but ignores gestures, for the small preview
  /// that is a link to the full map rather than a map in its own right.
  final bool interactive;

  final double minZoom;
  final double maxZoom;

  const InteractiveMap({
    super.key,
    required this.initialCamera,
    required this.overlayBuilder,
    this.onCameraChanged,
    this.interactive = true,
    this.minZoom = 3,
    this.maxZoom = 18,
  });

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  late MapCamera _camera = widget.initialCamera;

  /// Camera and finger position when the current gesture began. Every update is
  /// measured from these rather than from the previous frame, so rounding does
  /// not accumulate into drift over a long drag.
  MapCamera? _gestureStart;
  Offset _gestureStartFocal = Offset.zero;
  Size _viewport = Size.zero;

  @override
  void didUpdateWidget(InteractiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The parent re-centres the map (the locate button, opening on a shop);
    // a change it did not ask for must not yank the map from under a drag.
    if (widget.initialCamera != oldWidget.initialCamera &&
        _gestureStart == null) {
      _camera = widget.initialCamera;
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    _gestureStart = _camera;
    _gestureStartFocal = details.localFocalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final start = _gestureStart;
    if (start == null) return;

    _setCamera(
      MapCamera.transformed(
        start: start,
        viewport: _viewport,
        focalStart: _gestureStartFocal,
        focalNow: details.localFocalPoint,
        scale: details.scale,
        minZoom: widget.minZoom,
        maxZoom: widget.maxZoom,
      ),
    );
  }

  void _onScaleEnd(ScaleEndDetails details) => _gestureStart = null;

  /// Double tap zooms in one level, towards the point tapped.
  void _onDoubleTapDown(TapDownDetails details) {
    final zoom = math.min(_camera.zoom + 1, widget.maxZoom);
    if (zoom == _camera.zoom) return;

    _setCamera(
      MapCamera.transformed(
        start: _camera,
        viewport: _viewport,
        focalStart: details.localPosition,
        focalNow: details.localPosition,
        scale: math.pow(2, zoom - _camera.zoom).toDouble(),
        minZoom: widget.minZoom,
        maxZoom: widget.maxZoom,
      ),
    );
  }

  void _setCamera(MapCamera camera) {
    setState(() => _camera = camera);
    widget.onCameraChanged?.call(camera);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Size(constraints.maxWidth, constraints.maxHeight);
        // Read during gestures, so it has to be up to date before one starts.
        _viewport = viewport;

        final map = Stack(
          children: [
            Positioned.fill(
              child: OsmTileMap(
                latitude: _camera.center.latitude,
                longitude: _camera.center.longitude,
                zoom: _camera.zoom,
              ),
            ),
            Positioned.fill(
              child: widget.overlayBuilder(
                context,
                MapProjection(
                  center: _camera.center,
                  zoom: _camera.zoom,
                  viewport: viewport,
                ),
              ),
            ),
          ],
        );

        if (!widget.interactive) return map;

        return GestureDetector(
          // Opaque so a drag starting on empty water still moves the map.
          behavior: HitTestBehavior.opaque,
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onScaleEnd: _onScaleEnd,
          onDoubleTapDown: _onDoubleTapDown,
          onDoubleTap: () {},
          child: map,
        );
      },
    );
  }
}
