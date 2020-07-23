import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/services/database.dart';
import 'package:brewcrew/shared/constants.dart';
import 'package:brewcrew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugar = ['0', '1', '2', '3', '4'];
  // form values
  String _currentName;
  String _currentSugar;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your brew  settings',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: _currentName ?? userData.name,
                    decoration: TextInputDeoration.copyWith(hintText: 'Name'),
                    validator: (value) =>
                        value.isEmpty ? 'name is required' : null,
                    onChanged: (value) {
                      setState(() => _currentName = value);
                    },
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField(
                      value: _currentSugar ?? userData.sugars,
                      decoration: TextInputDeoration,
                      items: sugar
                          .map((e) => DropdownMenuItem(
                                child: Text('$e sugars'),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _currentSugar = value;
                        });
                      }),
                  Slider(
                      value: (_currentStrength ?? userData.strength).toDouble(),
                      min: 100,
                      max: 900,
                      divisions: 8,
                      activeColor:
                          Colors.brown[_currentStrength ?? userData.strength],
                      inactiveColor:
                          Colors.brown[_currentStrength ?? userData.strength],
                      onChanged: (value) {
                        setState(() {
                          _currentStrength = value.round();
                        });
                      }),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentSugar ?? userData.sugars,
                            _currentName ?? userData.name,
                            _currentStrength ?? userData.strength
                            );
                            Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
