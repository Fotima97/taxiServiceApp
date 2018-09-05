import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'code_page.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _selected = 0;
  bool val;
  bool _callpermissionValue = false;
  Future<bool> perm;
  DocumentReference clientRefer =
      Firestore.instance.collection('data').document('$clientDocRef');
  void onChanged(int value) {
    setState(() {
      _selected = value;
      if (value == 0) {
        _saveMapTypeLocal(0);
      } else {
        _saveMapTypeLocal(1);
      }
    });
  }

  void _onChanged(bool value) {
    if (value) {
      _savePermissionLocal(true);
      _updateCallPemission(true);
    } else {
      _savePermissionLocal(false);
      _updateCallPemission(false);
    }
  }

  void _getCallPermission() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      if (pref.getBool('callPerm') != null) {
        _callpermissionValue = pref.getBool('callPerm');
      } else {
        _callpermissionValue == false;
      }
    });

    print('Call Pemisstion $_callpermissionValue');
  }

  _saveMapTypeLocal(int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setInt('mapType', value);
      pref.setInt('mapType', value);
    });
  }

  _getMapTypeLocal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      if (pref.getInt('mapType') != null) {
        _selected = pref.getInt('mapType');
      } else
        _selected == 0;
    });
    print('MAp type $_selected');
  }

  _savePermissionLocal(bool enable) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setBool('callPerm', enable);
    });
  }

  _updateCallPemission(bool enable) {
    //print('permission is updated');
    Map<String, bool> data = <String, bool>{"disableCall": enable};
    setState(() {
      clientRefer.updateData(data).whenComplete(() {
        print('permission updated to $enable');
      }).catchError((e) => print(e));
      print(clientRefer.documentID);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCallPermission();
    _getMapTypeLocal();
    print('reference' + clientRefer.documentID);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //_updateCallPemission(_callpermissionValue);
    return new Scaffold(
        appBar: AppBar(
          title: Text('Настройки'),
        ),
        body: ListView(padding: const EdgeInsets.all(15.0), children: <Widget>[
          ListTile(
            title: Text(
              'Тип Карты',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                  trailing: new Radio(
                      value: 0,
                      groupValue: _selected,
                      onChanged: (int value) {
                        onChanged(value);
                      }),
                  title: Text('Карта')),
              ListTile(
                  trailing: new Radio(
                      value: 1,
                      groupValue: _selected,
                      onChanged: (int value) {
                        onChanged(value);
                      }),
                  title: Text('Гибрид')),
            ],
          ),
          Divider(
            height: .1,
          ),
          ListTile(
            trailing: Switch(
              value: _callpermissionValue,
              onChanged: (bool value) {
                setState(() {
                  _onChanged(value);
                  print('valeue changed to $value');
                });
              },
              activeThumbImage: new AssetImage('assets/active_phone.png'),
              inactiveThumbImage: new AssetImage('assets/phone_inactive.png'),
            ),
            title: Text('Не звонить',
                style: TextStyle(fontWeight: FontWeight.w500)),
          )
        ]));
  }
}
