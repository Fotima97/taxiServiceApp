import 'package:flutter/material.dart';
import 'package:taxiservice/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxiservice/helpers/dialog_boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:taxiservice/helpers/app_constants.dart';

//String savedUserName;
//String savedPhoneNumber;
int editMode;
/*
EditMode
1--userName edit
2--phoneNumber edit
 */

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  DocumentReference clientReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    initConnectivity();
  }

  getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      savedUserName = pref.getString('userName');
      savedPhoneNumber = pref.getString('phoneNumber');
      clientDocRef = pref.getString('userId');
      //   clientReference =
      //     Firestore.instance.collection('data').document('$clientDocRef');
      print('clinetId' + clientRef.documentID);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //getUserInfo();

    return Scaffold(
        appBar: AppBar(
          title: Text('Профиль'),
        ),
        body: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            ListTile(
              title: Text('$savedUserName'),
              trailing: Material(
                  child: InkWell(
                splashColor: Colors.blue,
                child: Icon(Icons.edit),
                onTap: () {
                  if (hasConnection) {
                    editMode = 1;
                    print('show dialog box $editMode');
                    profileEditDialogBox(context, savedUserName);
                  } else {
                    connectionErrorDialogbox(context);
                  }
                },
              )),
            ),
            Divider(),
            ListTile(
                title: Text('$savedPhoneNumber'),
                trailing: Material(
                    child: InkWell(
                  splashColor: Colors.blue,
                  child: Icon(Icons.edit),
                  onTap: () {
                    if (hasConnection) {
                      editMode = 2;
                      profileEditDialogBox(context, savedPhoneNumber);
                    } else {
                      connectionErrorDialogbox(context);
                    }
                  },
                ))),
            Divider(),
            ListTileTheme(
                selectedColor: Colors.red,
                child: Container(
                    color: Colors.red,
                    child: ListTile(
                      title: Text(
                        'Удалить Профиль',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      onTap: () {
                        profileDeleteDialogBox(context);
                      },
                    ))),
            Divider()
          ],
        ));
  }
}

editUserNameLocally(String newUserName) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (savedUserName != newUserName) {
    pref.setString('userName', newUserName);
    print('prifile name edited to $newUserName');
  }
}

editPhoneNumberLocally(String newPhoneNumber) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (savedPhoneNumber != newPhoneNumber) {
    pref.setString('phoneNumber', '$newPhoneNumber');
    print('phoneNumber edited locally');
  }
}

editUserName(String newUserName) {
  clientRef.updateData({"userName": '$newUserName'}).whenComplete(() {
    print('UserName is updated in the database to $newUserName');
  }).catchError((e) => print(e));
}

editPhoneNumber(String newPhoneNumber) {
  clientRef.updateData({"phoneNumber": '$newPhoneNumber'}).whenComplete(() {
    print('PhoneNumber is updated in the database');
  }).catchError((e) => print(e));
}

deleteProfile() {
  clientRef.delete().whenComplete(() {
    print('Profile is deleted');
  }).catchError((e) => print(e));
}

editRegistred() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool(isRegistered, false);
  print('user registred false');
}
