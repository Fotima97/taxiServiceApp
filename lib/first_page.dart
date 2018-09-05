import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taxiservice/helpers/auth.dart';

class FirstPage extends StatefulWidget {
  @override
  State createState() => new FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  @override
  initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.blue),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.blue,
                          size: 60.0,
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'Taxi Service',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'Удобное такси для  вас \n и для вашей семьи',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                  ],
                ))
          ],
        )
      ],
    ));
  }
}
