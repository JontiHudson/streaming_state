/// A simple, yet powerful global state library for **flutter** projects.
///
/// Uses **MapStream**s from [package:map_stream] to hold state, which
/// automatically pushes updates as streams
///
/// **StreamingState** extends **StatefulWidget**'s **State** class, allowing
/// a **MapStream** to attach. Whenever an update from the stream arrives the
/// **Widget** rerenders.
///
/// **MapStreamBuilder**, similar to **StreamBuilder**, is a Widget that builds
/// itself based on the current **MapStream** state.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_stream/map_stream.dart';

/// An extension of **StatefulWidget**'s **State** class, allowing
/// a **MapStream** to attach.
///
/// Whenever an update from the stream arrives the**Widget** rerenders.
abstract class StreamingState<W extends StatefulWidget> extends State<W> {
  final Map<MapStream, List?> _mapStreamsMap;
  final List<StreamSubscription<MapUpdate>> _stateStreamSubscriptions = [];

  /// Attaches [mapStream] to **StatefullWidget** so any recieved updates
  /// causes a rerender.
  ///
  /// Optional [listenFor] restricts rerenders to only updates to specific keys.
  /// Helpful for reducing unecessary rerendering.
  StreamingState(MapStream mapStream, [List? listenFor])
      : _mapStreamsMap = {mapStream: listenFor},
        super();

  /// Attach multiple **MapStream**/listenFor pairs to listen for changes from
  /// multiple **MapStreams**.
  ///
  /// [listenFor] values restricts rerenders to **MapStream** updates to those
  /// specific keys. Set null to update on any **MapStream** change.
  StreamingState.multiState(Map<MapStream, List?> mapStreams)
      : _mapStreamsMap = mapStreams,
        super();

  @override
  void initState() {
    super.initState();

    final mapStreamsMap = _mapStreamsMap;

    mapStreamsMap.forEach((mapStream, keys) {
      _stateStreamSubscriptions.add(
        mapStream.listen(
          (_) => setState(() => {}),
          keys,
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stateStreamSubscriptions.forEach((subscription) => subscription.cancel());
  }
}

/// Widget that builds itself based on the current **MapStream** state.
///
/// Optional [listenFor] restricts rerenders to only updates to specific keys.
/// Helpful for reducing unecessary rerendering.
class MapStreamBuilder extends StatefulWidget {
  final MapStream _mapStream;
  final List? _listenFor;
  final Widget Function(BuildContext context) _builder;

  MapStreamBuilder({
    required Widget Function(BuildContext context) builder,
    Key? key,
    List? listenFor,
    required MapStream mapStream,
  })  : _builder = builder,
        _listenFor = listenFor,
        _mapStream = mapStream,
        super(key: key);

  @override
  _MapStreamBuilderState createState() => _MapStreamBuilderState(
        _mapStream,
        _listenFor,
      );
}

class _MapStreamBuilderState extends StreamingState<MapStreamBuilder> {
  _MapStreamBuilderState(
    MapStream mapStream, [
    List? listenFor,
  ]) : super(
          mapStream,
          listenFor,
        );

  @override
  Widget build(BuildContext context) {
    return widget._builder(context);
  }
}
