import 'package:flutter/material.dart';
import 'package:taxiservice/helpers/app_constants.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';
import 'package:taxiservice/helpers/dialog_boxes.dart';

final codeController = new TextEditingController();
String newPhoneNumber;

class CodePage extends StatefulWidget {
  @override
  State createState() => new CodePageState();
}

class CodePageState extends State<CodePage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _codeFormKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _codePageScaffold =
      new GlobalKey<ScaffoldState>();
  final CollectionReference colRef = Firestore.instance.collection('data');
  StreamSubscription<DocumentSnapshot> subscription;
  AnimationController _loginButtonController;
  Animation<double> buttonSqueezeAnimation;
  Animation<double> buttonZoomOut;
  Animation<Color> fadeScreenAnimation;
  DocumentReference clienId;
  String currentPhoneNumber;

  saveRegistred(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(isRegistered, value);
    print('user registred');
  }

  void _addUser() {
    clienId = colRef.document();
    clienId.setData({
      "userName": nameController.text,
      "disableCall": false,
      "phoneNumber": '+998' + numberController.text,
    }).whenComplete(() {
      print("User Added");
    }).catchError((e) => print(e));
  }

  localSaveUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userName', nameController.text);
    pref.setString('phoneNumber', '+998' + numberController.text);
    pref.setString('userId', clienId.documentID);
    print(clienId.documentID);
    print('user saved localy');
  }

  getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('userName');
      phoneNumber = pref.getString('phoneNumber');
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  void initState() {
    super.initState();
    print('create $createnewProfile hklk');
    _loginButtonController = new AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    buttonSqueezeAnimation = new Tween(
      begin: 320.0,
      end: 70.0,
    ).animate(
      new CurvedAnimation(
        parent: _loginButtonController,
        curve: new Interval(0.0, 0.150),
      ),
    );
    buttonZoomOut = new Tween(
      begin: 70.0,
      end: 1000.0,
    ).animate(new CurvedAnimation(
        parent: _loginButtonController,
        curve: new Interval(0.550, 0.550, curve: Curves.bounceOut)));

    fadeScreenAnimation = new ColorTween(
      begin: const Color.fromRGBO(33, 150, 243, 1.0),
      end: const Color.fromRGBO(33, 150, 243, 0.0),
    ).animate(
      new CurvedAnimation(parent: _loginButtonController, curve: Curves.ease),
    );

    _loginButtonController.addListener(() {
      if (_loginButtonController.isCompleted) {
        Navigator.pushReplacementNamed(context, '/home');
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', (Route<dynamic> route) => false);
      }
    });
    if (createnewProfile) {
      currentPhoneNumber = '+998' + numberController.text;
    } else {
      currentPhoneNumber = newData.text;
    }
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      print('animation executed');
      await _loginButtonController.reverse();
    } on TickerCanceled {
      print('Problems with animation');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      key: _codePageScaffold,
      appBar: AppBar(
        title: Text('Taxi Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Form(
          key: _codeFormKey,
          child: Container(
            padding: buttonZoomOut.value == 70
                ? const EdgeInsets.all(50.0)
                : const EdgeInsets.all(0.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: buttonZoomOut.value == 70 ? 40.0 : 0.0,
                  child: Text(
                    buttonZoomOut.value == 70
                        ? 'Введите код, который вы получили на номер ' +
                            currentPhoneNumber
                        : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.2),
                  ),
                ),
                SizedBox(
                  height: buttonZoomOut.value == 70 ? 35.0 : 0.0,
                ),
                Container(
                  height: buttonZoomOut.value == 70 ? 50.0 : 0.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'введите отправленный код';
                      } else if (value != randomCode) {
                        print('option 2');
                        return 'Код введен неправильно';
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: codeController,
                    autofocus: false,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
                SizedBox(
                  height: buttonZoomOut.value == 70 ? 30.0 : 0.0,
                ),
                InkWell(
                  onTap: () {
                    print('EditMode $createnewProfile');
                    if (_codeFormKey.currentState.validate()) {
                      if (codeController.text == randomCode) {
                        if (!createnewProfile) {
                          editPhoneNumber(newData.text);
                          editPhoneNumberLocally(newData.text);
                          print('data updated to ' + newData.text);
                        } else {
                          localSaveUserInfo();
                          saveRegistred(true);
                          _addUser();
                        }

                        _loginButtonController.addListener(() {
                          setState(() {
                            _loginButtonController.forward();
                          });
                        });

                        _playAnimation();
                      }
                    }
                  },
                  child: new Hero(
                      tag: "fade",
                      child: new Container(
                          width: buttonZoomOut.value == 70
                              ? buttonSqueezeAnimation.value
                              : buttonZoomOut.value,
                          height: buttonZoomOut.value == 70
                              ? 60.0
                              : buttonZoomOut.value,
                          alignment: FractionalOffset.center,
                          decoration: new BoxDecoration(
                            color: const Color.fromRGBO(33, 150, 243, 1.0),
                            borderRadius: buttonZoomOut.value < 300
                                ? new BorderRadius.all(
                                    const Radius.circular(10.0))
                                : new BorderRadius.all(
                                    const Radius.circular(0.0)),
                          ),
                          child: buttonSqueezeAnimation.value > 75.0
                              ? new Text(
                                  "Продолжить",
                                  style: new TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : buttonZoomOut.value < 300.0
                                  ? new CircularProgressIndicator(
                                      value: null,
                                      strokeWidth: 1.0,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    )
                                  : null)),
                ),
                SizedBox(
                  height: buttonZoomOut.value == 70 ? 10.0 : 0.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
