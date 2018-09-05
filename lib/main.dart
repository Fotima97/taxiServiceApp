import 'package:flutter/material.dart';
import 'dart:async';
import 'package:map_view/map_view.dart';
import 'history_page.dart';
import 'info_page.dart';
import 'help_page.dart';
import 'settings_page.dart';
import 'login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'code_page.dart';
import 'settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxiservice/helpers/floating_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'order_page.dart';
import 'first_page.dart';
import 'package:geocoder/geocoder.dart';
import 'helpers/dialog_boxes.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:taxiservice/profile_page.dart';

var Api_key = 'AIzaSyDrHKl8IxB4cGXIoELXQOzzZwiH1xtsRf4';
String clientDocRef;

DocumentReference clientRef =
    Firestore.instance.collection('data').document('$clientDocRef');

String savedUserName;
String savedPhoneNumber;
StaticMapViewType staticmaptype = StaticMapViewType.roadmap;
MapViewType mapViewType = MapViewType.normal;

void main() {
  MapView.setApiKey(Api_key);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Taxi Service',
      home: StartApp(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MainPage(),
        '/login': (BuildContext context) => new StartApp(),
        '/code': (BuildContext context) => new CodePage(),
        '/settings': (BuildContext context) => new Settings(),
        '/history': (BuildContext context) => new History(),
        '/info': (BuildContext context) => new Info(),
        '/help': (BuildContext context) => new Help(),
        '/order': (BuildContext context) => new OrderPage(),
        '/profile': (BuildContext context) => new ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State createState() => new MainPageState();
}

getClientId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  clientDocRef = pref.getString('userId');
  //clientDocRef = '-LFaqn6H-5a-Z9s058vE';
  print(clientDocRef);
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  var mapView = new MapView();
  var provider = new StaticMapProvider(Api_key);
  CameraPosition cameraPosition;
  var urimap;
  showMap() {
    mapView.show(
      new MapOptions(
          mapViewType: mapViewType,
          showUserLocation: true,
          initialCameraPosition:
              new CameraPosition(new Location(41.311081, 69.240562), 14.0),
          title: "Map"),
    );

    mapView.zoomToFit(padding: 100);
    mapView.onLocationUpdated
        .listen((position) => this.onUserLocationUpdated(position, mapView));
  }

  onUserLocationUpdated(position, MapView mapview) async {
    double zoomLevel = await mapview.zoomLevel;
    mapview.setCameraPosition(position.latitude, position.longitude, zoomLevel);
    latitude = position.latitude;
    longitude = position.longitude;
    getCurrentAddress();
  }

  getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      savedUserName = pref.getString('userName');
      savedPhoneNumber = pref.getString('phoneNumber');
    });
  }

  Widget loadMap() {
    if (hasConnection) {
      return new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          ),
          InkWell(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: urimap.toString(),
              fit: BoxFit.cover,
            ),
            onTap: () {},
          )
        ],
      );
    } else
      return Center(
        child: Text(
          'Нет подключения к сети',
          style: TextStyle(color: Colors.grey[400], fontSize: 18.0),
        ),
      );
  }

  _getMapTypeLocal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int mapType = 0;
    mapType = pref.getInt('mapType');

    if (mapType == 0) {
      staticmaptype = StaticMapViewType.roadmap;
      mapViewType = MapViewType.normal;
    } else {
      staticmaptype = StaticMapViewType.hybrid;
      mapViewType = MapViewType.hybrid;
    }
  }

  @override
  initState() {
    super.initState();
    getUserInfo();
    getClientId();
    initConnectivity();
    _getMapTypeLocal();
    urimap = provider.getStaticUri(new Location(41.311081, 69.240562), 12,
        width: 1000, height: 1500, mapType: staticmaptype);
    cameraPosition =
        new CameraPosition(new Location(41.311081, 69.240562), 2.0);
    print(urimap.toString());
  }

  getCurrentAddress() async {
    print('current location');
    var coordinates = new Coordinates(latitude, longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    fromAddress.text = address.first.addressLine.toString();
    fromLat = latitude;
    fromLong = longitude;
    print(address.first.addressLine.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getUserInfo();
    return new Scaffold(
      backgroundColor: Colors.blue[20],
      bottomNavigationBar: Container(
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.green[500]),
        child: Material(
          color: Colors.green,
          child: MaterialButton(
            minWidth: 350.0,
            height: 60.0,
            splashColor: Colors.green[600],
            child: Text(
              'Заказать',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            onPressed: () {
              if (hasConnection && (latitude != null && longitude != null)) {
                toAddress.clear();
                fromLat = latitude;
                fromLong = longitude;
                Navigator.pushNamed(context, '/order');
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => OrderPage()));
              } else {
                locationDialogBox(context);
              }
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: new Text('Taxi Service'),
      ),
      floatingActionButton: FabAnim(),
      drawer: Drawer(
        child: new ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(
                '$savedUserName',
                style: TextStyle(fontSize: 20.0),
              ),
              accountEmail: new Text(
                '$savedPhoneNumber',
              ),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                image: new AssetImage('assets/drawer_back.jpeg'),
                fit: BoxFit.fill,
              )),
            ),
            ListTileTheme(
              child: new ListTile(
                title: Text('История поездок'),
                leading: new Icon(Icons.timelapse),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/history');
                },
              ),
              // iconColor: Colors.brown,
              selectedColor: Colors.red,
            ),
            Divider(),
            ListTileTheme(
              child: ListTile(
                title: Text('Профиль'),
                leading: new Icon(Icons.person),
                onTap: () {
                  Navigator.pop(context);
                  print('Profile' + clientDocRef);
                  // Navigator.push(
                  //   context,
                  //new MaterialPageRoute(
                  //  builder: (context) => ProfilePage()));
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              iconColor: Colors.blue[300],
              selectedColor: Colors.blueGrey,
            ),
            Divider(),
            ListTileTheme(
              child: ListTile(
                title: Text('Информация'),
                leading: new Icon(Icons.info),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/info');
                },
              ),
              iconColor: Colors.indigo,
              selectedColor: Colors.indigo,
            ),
            Divider(),
            ListTileTheme(
              child: ListTile(
                title: Text('Настройки'),
                leading: new Icon(Icons.settings),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              iconColor: Colors.blue[600],
              selectedColor: Colors.blue[600],
            ),
            Divider(),
            ListTileTheme(
              child: ListTile(
                title: Text('Служба поддержки'),
                leading: new Icon(Icons.help),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/help');
                },
              ),
              iconColor: Colors.orange,
              selectedColor: Colors.orange,
            )
          ],
        ),
      ),
      body: new Container(
        height: 1000.0,
        child: loadMap(),
      ),
    );
  }
}
