import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxiservice/helpers/floating_button.dart';
import 'code_page.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';
import 'places_search_page.dart';
import 'main.dart';
import 'package:taxiservice/helpers/dialog_boxes.dart';
import 'package:taxiservice/helpers/date_time_format.dart';

DocumentReference orderRef;
final CollectionReference colRefOrders =
    Firestore.instance.collection("orders");
String addressToField;
String addressFromLocation;
String addressFromQuery;
bool fromfieldPressed;
double fromLong;
double fromLat;
double toLong;
double toLat;
Color locationIconColor = Colors.grey;
Color locationIconColor2 = Colors.grey;
final fromAddress = new TextEditingController();
final toAddress = new TextEditingController();

class OrderPage extends StatefulWidget {
  @override
  State createState() => OrderPageState();
}

final homeScaffoldKey = new GlobalKey<ScaffoldState>();
final searchScaffoldKey = new GlobalKey<ScaffoldState>();

class OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  final CollectionReference colRef = Firestore.instance.collection('tariffs');

  List tablist2 = new List<Widget>();
  Color flatButtonColor = Colors.transparent;

  FocusNode _focus1 = new FocusNode();
  FocusNode _focus2 = new FocusNode();
  var tariffName2 = "Эконом";
  var oneKmCost2 = '1200';
  var oneKmCost3;
  var availableCars2;
  var tarrifMin2;
  var waiting2;
  var carsDefault;
  var minDefault;
  var oneKmDefault;
  var waitingDefault;
  var tariffNameDefault;

  String userId;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  //String tariff = "Эконом";

  @override
  void initState() {
    super.initState();
    initConnectivity();
    print(clientDocRef);
    fromAddress.text = currentAddress;
    setState(() {
      colorControllers();
      print(latitude.toString());
      print(longitude.toString());
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: _date,
        lastDate: _date.add(Duration(days: 7)));
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        //print('selected date $_date');
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      // print('selected time $_date');
      setState(() {
        _time = picked;
      });
    }
  }

  void getPressedField() {}

  void addOrder() {
    orderRef = colRefOrders.document();
    orderRef.setData({
      'clientId': clientDocRef,
      'fromLat': fromLat,
      'fromLong': fromLong,
      'toLat': toLat,
      'toLong': toLong,
      'tarif': tariffName2,
      'date': _date,
      'time':
          _time.hour.toString() + ':' + convertMinute(_time.minute.toString()),
      // 'dateTime': DateTime.now(),
      'fromAddress': fromAddress.text,
      'toAddress': toAddress.text
    }).whenComplete(() {
      print("Order is made");
      fromLat = null;
      fromLong = null;
      toLat = null;
      toLong = null;
    }).catchError((e) => print(e));
  }

  void colorControllers() {
    if (toAddress.text.isNotEmpty) {
      locationIconColor2 = Colors.blue;
    } else {
      locationIconColor2 = Colors.grey;
    }
    if (fromAddress.text.isNotEmpty) {
      locationIconColor = Colors.blue;
    } else {
      locationIconColor = Colors.grey;
    }
  }

  getPlaceFromQuery() async {
    var query = "1600 Amphiteatre Parkway, Mountain View";
    var address = await Geocoder.local.findAddressesFromQuery(query);
    addressFromQuery = address.first.addressLine.toString();
  }

  void openSearch() async {
    Prediction p = await showGooglePlacesAutocomplete(
        context: context,
        apiKey: kGoogleApiKey,
        onError: (res) {
          homeScaffoldKey.currentState
              .showSnackBar(new SnackBar(content: new Text(res.errorMessage)));
        },
        mode: Mode.fullscreen,
        language: "uzb",
        components: [new Component(Component.country, "uzb")]);

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    _focus1.dispose();
    _focus2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    colorControllers();
    return Scaffold(
      appBar: new AppBar(
        title: Text('Детали заказа'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: new Container(
              decoration: BoxDecoration(color: Colors.white),
              height: 60.0,
              child: new StreamBuilder(
                stream: colRef.snapshots(),
                builder: (context, snapshot) {
                  if (!hasConnection || !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.documents[index];
                      var tariffName = ds['name'];
                      var oneKmCost = ds['one_km'];
                      tariffNameDefault =
                          snapshot.data.documents[0]['name'].toString();
                      oneKmDefault =
                          snapshot.data.documents[0]['one_km'].toString();
                      minDefault = snapshot.data.documents[0]['min'].toString();
                      waitingDefault =
                          snapshot.data.documents[0]['waiting'].toString();
                      carsDefault =
                          snapshot.data.documents[0]['cars'].toString();
                      return new Container(
                          decoration: BoxDecoration(
                              border: const Border(
                                  right: BorderSide(
                                      width: 0.2, color: Colors.grey))),
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                tariffName2 = tariffName;
                                oneKmCost2 = oneKmCost.substring(0, 4);
                                oneKmCost3 = oneKmCost;
                                tarrifMin2 = ds['min'];
                                availableCars2 = ds['cars'];
                                waiting2 = ds['waiting'];
                              });
                            },
                            child: Text(tariffName,
                                style: TextStyle(fontSize: 15.0)),
                          ));
                    },
                  );
                },
              )),
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(5.0),
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: locationIconColor,
              ),
              title: InkWell(
                child: TextField(
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: fromAddress,
                  autofocus: false,
                  decoration: InputDecoration(hintText: "Откуда"),
                  focusNode: _focus1,
                ),
                onTap: () {
                  fromfieldPressed = true;
                  openSearch();
                },
              ),
              trailing: InkWell(
                child: Icon(
                  Icons.close,
                ),
                onTap: () {
                  // fromAddress.clear();
                  addressFromLocation = '';
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: locationIconColor2),
              title: InkWell(
                
                child: TextField(
                  onChanged: (text) {
                    locationIconColor2 = Colors.blue;
                  },
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: toAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Куда',
                  ),
                  focusNode: _focus2,
                ),
                onTap: () {
                  fromfieldPressed = false;
                  openSearch();
                },
              ),
              trailing: InkWell(
                child: Icon(Icons.close),
                onTap: () {
                  toAddress.clear();
                  addressToField = '';
                },
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
                  child: Text(
                    'Тариф',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[500]),
                  ),
                ),
               Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                  child: Material(
                    child: InkWell(
                   child: Card(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0),
                        height: 120.0,
                        width: 250.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.directions_car),
                            SizedBox(height: 5.0),
                            Text(
                              tariffName2,
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              ' $oneKmCost2 сум за 1 км',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16.0),
                            )
                          ],
                        ),
                      )),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return new Container(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      30.0, 20.0, 30.0, 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                tariffName2,
                                                textAlign: TextAlign.center,
                                                style:
                                                    TextStyle(fontSize: 24.0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                      Icon(Icons.donut_large),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                      availableCars2 == null
                                                          ? carsDefault
                                                              .toString()
                                                          : availableCars2,
                                                      style: TextStyle(
                                                          fontSize: 14.0)),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                      Icon(Icons.donut_large),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    tarrifMin2 == null
                                                        ? minDefault.toString()
                                                        : tarrifMin2,
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                      Icon(Icons.donut_large),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                      oneKmCost3 == null
                                                          ? oneKmDefault
                                                              .toString()
                                                          : oneKmCost3,
                                                      style: TextStyle(
                                                          fontSize: 14.0)),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                      Icon(Icons.donut_large),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                      waiting2 == null
                                                          ? waitingDefault
                                                              .toString()
                                                          : waiting2,
                                                      style: TextStyle(
                                                          fontSize: 14.0)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 30.0, bottom: 10.0),
                                            padding: EdgeInsets.fromLTRB(
                                                5.0, 15.0, 15.0, 5.0),
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            alignment: Alignment.center,
                                            child: MaterialButton(
                                              child: Text(
                                                'Закрыть',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.date_range, color: Colors.blue),
                  title: InkWell(
                    child: Text('${_date.day.toString()}' +
                        ' ' +
                        convertMonth(_date.month) +
                        ' ' +
                        _date.year.toString()),
                    onTap: () => _selectDate(context),
                  ),
                  trailing: InkWell(
                    child: Icon(Icons.edit),
                    onTap: () => _selectDate(context),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.blue),
                  title: InkWell(
                    child: Text(_time.hour.toString() +
                        ':' +
                        convertMinute(_time.minute.toString())),
                    onTap: () {
                      setState(() {
                        _selectTime(context);
                      });
                    },
                  ),
                  trailing: InkWell(
                      child: Icon(Icons.edit),
                      onTap: () {
                        setState(() {
                          _selectTime(context);
                        });
                      }),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.green),
        height: 70.0,
        child: Material(
          color: Colors.green,
          child: MaterialButton(
            splashColor: Colors.green[600],
            height: 50.0,
            minWidth: 320.0,
            child: Text('Вызвать такси',
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
            onPressed: () {
              orderDialogBox(context);
              addOrder();
            },
          ),
        ),
      ),
    );
  }
}
