import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/utils/credentials.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

import 'package:flutter_firebase_auth/services/auth.dart';



class Subscribe extends StatefulWidget {
  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  String _username = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {

    final Credentials credentials = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Subscribe"),
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: _username,
                      decoration: inputFieldDecoration.copyWith(hintText: 'Username'),
                      validator: (value) =>
                      value.isEmpty ? 'Enter a username' : null,
                      onChanged: (value) {
                        setState(() {
                          _username = value;
                        });
                      },
                    ),
                  ),
                  Spacer(
                    flex: 5
                  ),
                  Expanded(
                    flex: 5,
                    child: TextButton(
                      style: ButtonStyle(
                        //backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.blueGrey[400];
                              }
                              else {
                                return Colors.blueGrey[600];
                              }
                            }),
                      ),
                      child: Text('Sign Up', style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          dynamic result = await _auth.signUpEmailPassword(credentials.email, credentials.password, _username);
                          if(result == null) {
                            setState(() {
                              print("Not a valid email or already registered");
                              _error = 'Not a valid email or already registered';
                              _loading = false;
                            });
                          }
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  Spacer(
                      flex: 5
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
