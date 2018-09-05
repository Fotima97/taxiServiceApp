import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => new _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          title: Text('Служба поддержки'),
        ),
        body: ListView(
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            ListTileTheme(
              child: ListTile(
                title: Text('Нажмите чтобы позвонить'),
                subtitle: Text('+9989777777'),
                trailing: Icon(Icons.call),
                onTap: () {
                  launch('tel://+998977777');
                },
              ),
              selectedColor: Colors.lightBlue,
            ),
            Divider(
              height: .1,
            )
          ],
        ));
  }
}
