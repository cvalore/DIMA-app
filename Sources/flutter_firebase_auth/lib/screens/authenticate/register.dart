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

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return _loading ? Loading() : Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text('Sign up to BookYourBook', style: TextStyle(color: Colors.white),),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: _isTablet ? EdgeInsets.symmetric(vertical: 30.0) : EdgeInsets.all(15.0),
          child: Container(
            //decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2.0)),
            width: _isTablet ? MediaQuery.of(context).size.width/1.5 : MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFormField(
                        cursorColor: Colors.black,
                        initialValue: _email == '' ? null : _email,
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
                          contentPadding: EdgeInsets.symmetric(vertical: _isTablet ? 20.0 : 10.0, horizontal: 0.0),
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
                      Container(height: _isTablet ? 20.0 : 10.0,),
                      TextFormField(
                        cursorColor: Colors.black,
                        initialValue: _password == '' ? null : _password,
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
                          contentPadding: EdgeInsets.symmetric(vertical: _isTablet ? 20.0 : 10.0, horizontal: 0.0),
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
                    ],
                  ),
                ),
                Container(
                  width: _isTablet ? MediaQuery.of(context).size.width/2.5 : MediaQuery.of(context).size.width/2,
                  child: TextButton(
                    style: ButtonStyle(
                      //backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]),
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
                    child: Text('Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _registerWithEmailAndPassword(context);
                    },
                  ),
                ),
                Text(_error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[400], fontSize: 14),),
                Row(
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
                Text('or', style: TextStyle(color: Colors.white),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('', style: TextStyle(color: Colors.white),),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      ),
                      child: Text('Continue anonymously',
                          style: TextStyle(color: Colors.red[600])),
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });

                        await _auth.signInAnonymously().then((result) {
                          if(result == null) {
                            setState(() {
                              _loading = false;
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  _registerWithEmailAndPassword(BuildContext context) async {
    String email = _email;
    String password = _password;

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
        } else if (authResult == 'Username already used'){
          setState(() {
            print(
                "Username already used");
            _error = 'Username already used\nPlease, choose a different username';
            _loading = false;
          });
          print(_email);
          print(_password);
        }
      }
    }
  }

}
