import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:math';
import 'package:sms/sms.dart';
import 'code_page.dart';
import 'dart:async';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:taxiservice/helpers/dialog_boxes.dart';
import 'package:taxiservice/helpers/auth.dart';

final numberController = new TextEditingController();
final nameController = new TextEditingController();
String userName;
String phoneNumber;
bool hasConnection = false;
bool createnewProfile;
String randomCode;

class StartApp extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<StartApp>  implements AuthStateListener{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    LoginPageState() {
    var authStateProvider = AuthStateProvider();
    authStateProvider.subscribe(this);
  }
  @override
  void onAuthStateChanged(AuthState state) {
      if (state == AuthState.LOGGED_IN) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
  }

  void sendMessageCode() {
    SmsSender smsSender = new SmsSender();
    // String address = '+' + numberController.text;

    SmsMessage message = new SmsMessage('+998972300209', 'Hello flutter!');
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      } else if (state == SmsMessageState.None) {
        print('Sms is not Delivered');
      }
    });
    smsSender.sendSms(message);
    smsSender.onSmsDelivered.listen((SmsMessage message) {
      print('${message.address} received your message.');
    });
    // sender.sendSms(message);
    //   smsSender
    //       .sendSms(new SmsMessage('+998' + numberController.text, randomCode));
    //   print('message is sent');
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      initConnectivity();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: new Image.asset(
          'assets/taxi-512.png',
          width: 100.0,
          height: 100.0,
        ));
    final phoneNumber = Row(
      children: <Widget>[
        new Expanded(
          flex: 1,
          child: TextFormField(
            autofocus: false,
            decoration: InputDecoration(
                enabled: false,
                hintText: '+998',
                contentPadding:
                    const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 4,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Пожалуйста введите ваш номер';
              }
            },
            keyboardType: TextInputType.phone,
            controller: numberController,
            autofocus: false,
            decoration: InputDecoration(
                labelText: 'Номер Телефона',
                hintText: '979991239',
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
          ),
        )
      ],
    );

    final fullname = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Пожалуйста введите ваше имя';
        }
      },
      keyboardType: TextInputType.text,
      controller: nameController,
      autofocus: false,
      decoration: InputDecoration(
          labelText: 'Имя',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    // TODO: implement build
    return new Scaffold(
        backgroundColor: Colors.blue[20],
        appBar: AppBar(
          title: Text('Taxi Service'),
        ),
        body: Center(
            child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24.0),
            children: <Widget>[
              logo,
              SizedBox(
                height: 48.0,
              ),
              fullname,
              SizedBox(
                height: 12.0,
              ),
              phoneNumber,
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  shadowColor: Colors.lightBlueAccent.shade100,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 50.0,
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        initConnectivity();
                        if (hasConnection) {
                          generateRandomCode();
                          // sendMessageCode();
                          createnewProfile = true;
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => CodePage()));
                        } else {
                          connectionErrorDialogbox(context);
                        }
                      }
                    },
                    color: Colors.blue,
                    child:
                        Text('Log In', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}

Future<Null> initConnectivity() async {
  final Connectivity _connectivity = new Connectivity();
  var connectionStatus;
  try {
    connectionStatus = await (_connectivity.checkConnectivity());
    if (connectionStatus == ConnectivityResult.mobile ||
        connectionStatus == ConnectivityResult.wifi) {
      hasConnection = true;
    } else {
      hasConnection = false;
    }
  } on PlatformException catch (e) {
    {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }
  }
  print('connection $hasConnection');
}

generateRandomCode() {
  Random random = new Random();
  String messageCode = random.nextInt((100000 + 1 - 99999) + 99999).toString();
  print(messageCode);
  randomCode = messageCode;
}
