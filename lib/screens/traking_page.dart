import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_mao/constatns/app_constants.dart';
import 'package:location/location.dart';
import 'package:vector_math/vector_math.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingPage extends StatefulWidget {
  static const String routeName = '/TrackingPage';

  const TrackingPage({Key? key}) : super(key: key);

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage>
    with TickerProviderStateMixin {
  LocationData? currentLocation;
  final List<Marker> _markers = <Marker>[];
  Animation<double>? _animation;
  late GoogleMapController _controller;
  List<LatLng> polylineCoordinates = [];
  final Completer<GoogleMapController> _cMapController = Completer();
  final _mapMarkerSC = StreamController<List<Marker>>();

  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;
  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;

  static const LatLng sourceLocation =
      LatLng(37.42796133580664, -122.085749655962);
  static const LatLng destination = LatLng(37.428714, -122.078301);

  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const currentLocationCamera = CameraPosition(
      target: sourceLocation,
      zoom: 14.5,
    );

    final googleMap = StreamBuilder<List<Marker>>(
        stream: mapMarkerStream,
        builder: (context, snapshot) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: currentLocationCamera,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCoordinates,
                color: const Color(0xFF7B61FF),
                width: 6,
              ),
            },
            markers: Set<Marker>.of(snapshot.data ?? []),
            padding: const EdgeInsets.all(8),
          );
        });

    return Scaffold(
      body: Stack(children: [googleMap]),
    );
  }

  initMarker() async {
    final sourceMarker = Marker(
      markerId: const MarkerId("source"),
      position: sourceLocation,
      icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/pin_source.png', 50)),
    );

    final destinationMarker = Marker(
      markerId: const MarkerId("destination"),
      position: destination,
      icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/pin_destination.png', 65)),
    );

    _markers.add(sourceMarker);
    _markers.add(destinationMarker);
    _mapMarkerSink.add(_markers);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void runMap(
    LatLng sourceLocation,
    LatLng destination,
    StreamSink<List<Marker>> mapMarkerSink,
    TickerProvider provider,
    GoogleMapController controller,
  ) async {
    final double bearing = getBearing(sourceLocation, destination);

    _markers.clear();

    await initMarker();
    // await getPolyPoints();

    //Initial marker
    var carMarker = Marker(
        markerId: const MarkerId("driverMarker"),
        position: sourceLocation,
        icon: BitmapDescriptor.fromBytes(await getBytesFromAsset(
            'assets/images/pin_current_location.png', 65)),
        rotation: bearing,
        draggable: false);

    _markers.add(carMarker);
    mapMarkerSink.add(_markers);

    animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: provider,
    );

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController)
      ..addListener(() async {
        final v = _animation!.value;
        double lng =
            v * destination.longitude + (1 - v) * sourceLocation.longitude;
        double lat =
            v * destination.latitude + (1 - v) * sourceLocation.latitude;
        LatLng newPos = LatLng(lat, lng);

        if (_markers.contains(carMarker)) _markers.remove(carMarker);
        //New marker
        carMarker = Marker(
            markerId: const MarkerId("driverMarker"),
            position: newPos,
            icon: BitmapDescriptor.fromBytes(await getBytesFromAsset(
                'assets/images/pin_current_location.png', 65)),
            rotation: bearing,
            draggable: false);

        _markers.add(carMarker);
        mapMarkerSink.add(_markers);

        final GoogleMapController controller = await _cMapController.future;

        if (_cMapController.isCompleted) {
          return;
        }

        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: newPos, zoom: 15.5)));
      });

    animationController.forward();
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return degrees(atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - degrees(atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return degrees(atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - degrees(atan(lng / lat))) + 270;
    }
    return -1;
  }

  getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBe99vrcjcB44-Q8aGBEVy7TGtQkW4tt6A",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _cMapController.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        // googleMapController.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       zoom: 13.5,
        //       target: LatLng(
        //         newLoc.latitude!,
        //         newLoc.longitude!,
        //       ),
        //     ),
        //   ),
        // );
        setState(() {});
      },
    );
  }
}
