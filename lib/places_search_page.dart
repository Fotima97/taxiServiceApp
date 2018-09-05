import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';
import 'package:flutter/material.dart';
import 'order_page.dart';
import 'dart:async';

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
const kGoogleApiKey = "AIzaSyBkbkexloWnoHqaZNKPp1YLy-V2iEYWHSo";
GoogleMapsPlaces _places = new GoogleMapsPlaces(kGoogleApiKey);
double lat;
double lng;

class CustomSearchScaffold extends GooglePlacesAutocompleteWidget {
  CustomSearchScaffold()
      : super(
            apiKey: kGoogleApiKey,
            language: "rus, uzb",
            components: [new Component(Component.country, "uzb")]);

  @override
  _CustomSearchScaffoldState createState() => new _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends GooglePlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar(title: new AppBarPlacesAutoCompleteTextField());
    final body = new GooglePlacesAutocompleteResult(onTap: (p) {
      displayPrediction(p, searchScaffoldKey.currentState);
    });
    return new Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(response.errorMessage)));
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      searchScaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text("Got answer")));
    }
  }
}

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    lat = detail.result.geometry.location.lat;
    lng = detail.result.geometry.location.lng;
    if (fromfieldPressed) {
      fromAddress.text = p.description;
      fromLat = lat;
      fromLong = lng;
      print('fromAddress' + p.description);
    } else {
      toAddress.text = p.description;
      locationIconColor = Colors.blue;
      print('toAddress' + p.description);
      print(lat);
      print(lng);
      toLat = lat;
      toLong = lng;
    }
    /*scaffold.showSnackBar(
        new SnackBar(content: new Text("mk+${p.description} - $lat/$lng")));*/
  }
}
