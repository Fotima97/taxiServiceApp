import 'package:flutter/material.dart';
import 'package:taxiservice/profile_page.dart';
import 'package:taxiservice/login_page.dart';
import 'package:taxiservice/code_page.dart';
import 'package:sms/sms.dart';

TextEditingController newData = new TextEditingController();

void locationDialogBox(BuildContext context) {
  AlertDialog alert = new AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 30.0, 10.0, 20.0),
      content: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Text(
            'Мы ищем ваше местоположение. \n Нажмите на геолокацию чтобы мы его определили',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            height: 0.2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            child: Material(
              color: Colors.transparent,
              child: MaterialButton(
                highlightColor: Colors.transparent,
                minWidth: 250.0,
                height: 30.0,
                child: Text(
                  'OK',
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      )));
  showDialog(context: context, child: alert);
}

void orderDialogBox(BuildContext context) {
  AlertDialog alert = new AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 30.0, 10.0, 20.0),
      content: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Text('Заказ принят', style: TextStyle(fontWeight: FontWeight.w400)),
          Text(
            ' Водитель будет через несколько минут \n',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Водитель:  ',
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            ' Машина: ',
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            height: 0.2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            child: Material(
              color: Colors.transparent,
              child: MaterialButton(
                highlightColor: Colors.transparent,
                minWidth: 250.0,
                height: 40.0,
                child: Text(
                  'OK',
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pop(context, '/home');
                  Navigator.pushReplacementNamed(context, '/history');
                },
              ),
            ),
          )
        ],
      )));
  showDialog(context: context, child: alert);
}

void connectionErrorDialogbox(BuildContext context) {
  AlertDialog alert = new AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
      content: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Text(
            'Проверьте подключение к Интернету',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            height: 0.2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            child: Material(
              color: Colors.transparent,
              child: MaterialButton(
                highlightColor: Colors.transparent,
                minWidth: 250.0,
                height: 40.0,
                child: Text('Продолжить',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      )));
  showDialog(context: context, child: alert);
}

void profileDeleteDialogBox(BuildContext context) {
  AlertDialog alert = new AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
      content: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              Text('Вы действительно хотите удалить свой профиль?'),
              SizedBox(
                height: 20.0,
              ),
              Divider(
                height: 0.2,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Material(
                          color: Colors.transparent,
                          child: MaterialButton(
                            highlightColor: Colors.transparent,
                            minWidth: 250.0,
                            height: 40.0,
                            child: Text('Нет',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Material(
                          color: Colors.transparent,
                          child: MaterialButton(
                            highlightColor: Colors.transparent,
                            minWidth: 250.0,
                            height: 40.0,
                            child: Text('Да',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () {
                              deleteProfile();
                              editRegistred();
                              numberController.clear();
                              nameController.clear();
                              Navigator.of(context).pushAndRemoveUntil(
                                  new MaterialPageRoute(
                                      builder: (context) => StartApp()),
                                  (Route<dynamic> route) => false);
                            },
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          )));
  showDialog(context: context, child: alert);
}

void profileEditDialogBox(BuildContext context, String data) {
  newData.text = data;
  AlertDialog alert = new AlertDialog(
      title: Text(editMode == 1 ? 'Имя пользователя' : 'Номер телефона'),
      content: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              TextField(
                keyboardType:
                    editMode == 1 ? TextInputType.text : TextInputType.phone,
                controller: newData,
                decoration:
                    InputDecoration(contentPadding: EdgeInsets.all(10.0)),
              ),
              SizedBox(
                height: 30.0,
              ),
              Divider(
                height: 0.2,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Material(
                          color: Colors.transparent,
                          child: MaterialButton(
                            highlightColor: Colors.transparent,
                            minWidth: 250.0,
                            height: 40.0,
                            child: Text('Отмена',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Material(
                          color: Colors.transparent,
                          child: MaterialButton(
                            highlightColor: Colors.transparent,
                            minWidth: 250.0,
                            height: 40.0,
                            child: Text('Сохранить',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () {
                              Navigator.pop(context);
                              if (editMode == 1) {
                                editUserName(newData.text);
                                editUserNameLocally(newData.text);
                                // getUserInfo();
                              } else if (editMode == 2) {
                                generateRandomCode();
                                // sendMessageCode();
                                codeController.clear();
                                createnewProfile = false;
                                print('create profile $createnewProfile');
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => CodePage()));
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          )));
  showDialog(context: context, child: alert);
}

void sendMessageCode() {
  SmsSender smsSender = new SmsSender();
  // String address = '+' + numberController.text;
  smsSender.sendSms(new SmsMessage('+998' + newData.text, randomCode));
  print('message is sent');
}
