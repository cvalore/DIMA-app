import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/authenticate/register.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  String _email = '';
  String _password = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Scaffold (
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
        title: Text('Sign in to BookYourBook'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: inputFieldDecoration.copyWith(hintText: 'Email'),
                    validator: (value) =>
                    (value.isEmpty | !value.contains('@') | !value.contains('.')) ?
                    'Enter a valid email' : null,
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: inputFieldDecoration.copyWith(hintText: 'Password'),
                    validator: (value) => value.length < 6 ?
                    'Enter password of at least 6 characters' : null,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0,),
                  TextButton(
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
                    child: Text('Sign In', style: TextStyle(color: Colors.white),),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() {
                          _loading = true;
                        });

                        dynamic result = await _auth.signInEmailPassword(_email, _password);
                        if(result == null) {
                          setState(() {
                            print("Wrong username or password");
                            _error = 'Wrong username or password';
                            _loading = false;
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                  Text(_error, style: TextStyle(color: Colors.red[400], fontSize: 14),),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Don\'t have an account yet?'),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        ),
                        child: Text('Create account',
                          style: TextStyle(color: Colors.blue[600])),
                        onPressed: () {
                          widget.toggleView();
                        },
                      ),
                    ],
                  ),
                  Text('or'),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    child: Text('Continue anonymously..',
                        style: TextStyle(color: Colors.blue[600])),
                    onPressed: () async {
                      await _auth.signInAnonymously();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
