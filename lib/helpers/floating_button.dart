import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:taxiservice/main.dart';
import 'package:taxiservice/order_page.dart';
import 'package:geocoder/geocoder.dart';
import 'package:taxiservice/login_page.dart';
import 'package:taxiservice/helpers/dialog_boxes.dart';
import 'dart:async';

double latitude;
double longitude;
String currentAddress;

class FabAnim extends StatefulWidget {
  /* final Function() onPressed;
  final String tooltip;
  final IconData icon;

  FabAnim(this.onPressed, this.tooltip, this.icon);*/
  @override
  _FabAnimState createState() => _FabAnimState();
}

class _FabAnimState extends State<FabAnim> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.ease;
  double _fabHeight = 56.0;
  var mapView = new MapView();
  var provider = new StaticMapProvider(Api_key);
  CameraPosition cameraPosition;

  showMap() {
    mapView.show(
        new MapOptions(
          mapViewType: mapViewType,
          showUserLocation: true,
          initialCameraPosition:
              new CameraPosition(new Location(41.311081, 69.240562), 14.0),
          title: "Карта",
        ),
        toolbarActions: [new ToolbarAction('Закрыть', 1)]);

    mapView.zoomToFit(padding: 100);
    mapView.onLocationUpdated
        .lastWhere((position) => this.onUserLocationUpdated(position, mapView));
    mapView.onTouchAnnotation
        .listen((annotation) => print("annotation tapped"));
    mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });
    mapView.onMapTapped.listen((location) {
      print('$location tapped');
    });
    // mapView.onMapReady.listen(onData)
  }

  onUserLocationUpdated(position, MapView mapview) async {
    double zoomLevel = await mapview.zoomLevel;
    mapview.setCameraPosition(position.latitude, position.longitude, zoomLevel);
    latitude = position.latitude;
    longitude = position.longitude;
    getCurrentAddress();
  }

  getCurrentAddress() async {
    print('current location');
    var coordinates = new Coordinates(latitude, longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    currentAddress = address.first.addressLine.toString();
    fromAddress.text = currentAddress;
    fromLat = latitude;
    fromLong = longitude;
    print(address.first.addressLine.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    initConnectivity();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.00, 1.00, curve: _curve)));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.00, 1.00, curve: _curve)));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toogle() {
    return FloatingActionButton(
      backgroundColor: _animateColor.value,
      onPressed: animate,
      heroTag: 'toogle',
      tooltip: 'Toogle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  Widget location() {
    return new Container(
      child: FloatingActionButton(
        onPressed: () {
          showMap();
        },
        heroTag: 'showLocation',
        tooltip: 'location',
        child: Icon(Icons.location_on),
      ),
    );
  }

  Widget order() {
    return new Container(
      child: FloatingActionButton(
        heroTag: 'makeOrder',
        onPressed: () {
          if (hasConnection && (latitude != null && longitude != null)) {
            fromAddress.text == currentAddress;
            toAddress.clear();
            fromLat = latitude;
            fromLong = longitude;
            Navigator.pushNamed(context, '/order');
            //  Navigator.push(
            //    context, MaterialPageRoute(builder: (context) => OrderPage()));
          } else {
            locationDialogBox(context);
          }
        },
        tooltip: 'Order Taxi',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
            transform: Matrix4.translationValues(
                0.0, _translateButton.value * 2.0, 0.0),
            child: order()),
        Transform(
            transform:
                Matrix4.translationValues(0.0, _translateButton.value, 0.0),
            child: location()),
        toogle(),
      ],
    );
  }
}
