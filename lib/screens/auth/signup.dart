import 'package:brewcrew/services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign Up to RDN Coffee'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Sign In'))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
            child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              validator: (value) => value.isEmpty ? 'email is required' : null,
              onChanged: (value) {
                setState(() => email = value);
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              validator: (value) =>
                  value.length < 6 ? 'Password Too Short' : null,
              obscureText: true,
              onChanged: (value) {
                setState(() => password = value);
              },
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.pink[400],
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  dynamic result =
                      await _auth.signUpWithEmailAndPassword(email, password);
                  if (result == null) {
                    setState(() => error = 'Invalid Email');
                  }
                }
              },
            ),
            SizedBox(height: 12.0),
            Text(error, style: TextStyle(color: Colors.redAccent,fontSize: 14)),
          ],
        )),
      ),
    );
  }
}
