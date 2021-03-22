import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/authenticate/subscribe.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  String _email = '';
  String _password = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text('Sign up to BookYourBook', style: TextStyle(color: Colors.white),),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  //mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Spacer(
                        flex: 1
                    ),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        //decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          contentPadding: EdgeInsets.only(top: 25.0),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 17.0,),
                        validator: (value) =>
                        (value.isEmpty | !value.contains('@') | !value.contains('.')) ?
                          'Enter a valid email' : null,
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                    ),
                    Spacer(
                        flex: 1
                    ),
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          cursorColor: Colors.black,
                          //decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            contentPadding: EdgeInsets.only(top: 25.0),
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 17.0,),
                          validator: (value) => value.length < 6 ?
                            'Enter password of at least 6 characters' : null,
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                          obscureText: true,
                        ),
                      ),
                    Spacer(
                        flex: 2
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Spacer(
                            flex: 1
                          ),
                          Expanded(
                            flex: 5,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.pressed)) {
                                        return Colors.white10;
                                      }
                                      else {
                                        return Colors.white24;
                                      }
                                    }),
                              ),
                              child: Text('Sign Up', style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                _registerWithEmailAndPassword(context);
                              },
                            ),
                          ),
                          Spacer(
                              flex: 1
                          ),
                        ],
                      )
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(_error, style: TextStyle(color: Colors.red[400], fontSize: 14),),
                    ),
                    Spacer(
                        flex: 1
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Already have an account?', style: TextStyle(color: Colors.white),),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            ),
                            child: Text('Sign in',
                                style: TextStyle(color: Colors.red[600])),
                            onPressed: () {
                              widget.toggleView();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text('or', style: TextStyle(color: Colors.white),),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        ),
                        child: Text('Continue anonymously..',
                            style: TextStyle(color: Colors.red[600])),
                        onPressed: () async {
                          await _auth.signInAnonymously();
                        },
                      ),
                    ),
                    Spacer(
                      flex: 1
                    ),
                  ],
                ),
              ),
            ),
      );
  }


  _registerWithEmailAndPassword(BuildContext context) async {
    if(_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      final usernameAsResult = await Navigator.pushNamed(context,Subscribe.routeName) as String;
      if (usernameAsResult == null) {
        setState(() {
          _loading = false;
        });
      }
      else {
        dynamic authResult = await _auth
            .signUpEmailPassword(
            _email, _password,
            usernameAsResult);
        if (authResult == null) {
          setState(() {
            print(
                "Not a valid email or already registered");
            _error =
            'Not a valid email or already registered';
            _loading = false;
          });
        }
      }
    }
  }

}
