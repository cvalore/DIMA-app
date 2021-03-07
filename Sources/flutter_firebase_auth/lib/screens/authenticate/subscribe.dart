import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

import 'package:flutter_firebase_auth/services/auth.dart';



class Subscribe extends StatefulWidget {
  static const routeName = '/subscribe';

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

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: _username,
                      decoration: inputFieldDecoration.copyWith(hintText: 'Username'),
                      validator: (value) =>
                      value.isEmpty ? 'Enter a valid username' : null,
                      onChanged: (value) {
                        setState(() {
                          _username = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0.0),
                    child: Container(
                      width: width * 0.5,
                      child: TextButton(
                        style: ButtonStyle(
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
                            Navigator.pop(context, _username);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
