import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'login_page.dart';

class Tariffs extends StatefulWidget {
  @override
  State createState() => new TariffState();
}

class TariffState extends State<Tariffs> with SingleTickerProviderStateMixin {
  final CollectionReference colRef = Firestore.instance.collection('tariffs');
  final PageController pageController = new PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    initConnectivity();
    return new Scaffold(
        appBar: new AppBar(
          title: Text("Тарифы"),
        ),
        body: new StreamBuilder(
          stream: colRef.snapshots(),
          builder: (context, snapshot) {
            if (!hasConnection) {
              return Center(
                child: new Text(
                  'Проверьте подключение к сети',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            if (!snapshot.hasData)
              return const Center(
                  child: CircularProgressIndicator(
                value: null,
                strokeWidth: 1.0,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ));
            return new Stack(
              children: <Widget>[
                PageView.builder(
                    controller: pageController,
                    physics: new AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.documents[index];
                      return new ListView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 30.0),
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            " ${ds['name']}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.amber[900]),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Image(
                            image: AssetImage('assets/taksi_econom.png'),
                            height: 70.0,
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Text("•  ${ds['cars']}",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15.0)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("•  ${ds['min']}",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15.0)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("• ${ds['one_km']}",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15.0)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("•  ${ds['waiting']}",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15.0)),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      );
                    }),
                new CircleIndicator(
                  pageController: pageController,
                  size: snapshot.data.documents.length,
                )
              ],
            );
          },
        ));
  }
}

class CircleIndicator extends StatefulWidget {
  CircleIndicator({Key key, this.pageController, this.size}) : super(key: key);
  final PageController pageController;
  final int size;
  @override
  State createState() {
    return new CircleIndicatorState(pageController, size);
  }
}

class CircleIndicatorState extends State {
  int position = 0;
  int length;
  CircleIndicatorState(PageController pageController, int size) {
    length = size;
    pageController.addListener(() {
      if (pageController.page.toInt() != position) {
        setState(() {
          position = pageController.page.toInt();
          length = size;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 60.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicatorList(length)));
  }

  List<Widget> indicatorList(int size) {
    return new List.generate(
        size,
        (i) => i == position
            ? drawCircle(Colors.grey[300])
            : drawCircle(Colors.white));
  }

  Widget drawCircle(Color color) {
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[200]),
        color: color,
      ),
      width: 13.0,
      height: 13.0,
    );
  }
}
