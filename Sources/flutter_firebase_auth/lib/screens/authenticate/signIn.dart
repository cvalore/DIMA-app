import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/authenticate/subscribe.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/loading.dart';


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

  TextButtonThemeData _textButtonTheme = TextButtonThemeData(
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
      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) {
            return TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            );
          }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.white;
          }),
    ),
  );

  TextButtonThemeData _textButtonThemeRed = TextButtonThemeData(
    style: ButtonStyle(
      //backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.transparent;
          }),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) {
            return TextStyle(
              fontSize: 14,
            );
          }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.red[600];
          }),
    ),
  );

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return _loading ? Loading() : Scaffold (
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text('Sign in to BookYourBook'),
      ),
      //backgroundColor: Colors.black,
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
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textButtonTheme: _textButtonTheme,
                    ),
                    child: TextButton(
                      child: Text('Sign In'),
                      onPressed: () {
                        _signinWithEmailAndPassword(context);
                      },
                    ),
                  ),
                ),
                Text(_error, style: TextStyle(color: Colors.red[400], fontSize: 14),),
                _isPortrait ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Don\'t have an account yet?', style: TextStyle(color: Colors.white),),
                    Theme(
                      data: Theme.of(context).copyWith(
                        textButtonTheme: _textButtonThemeRed,
                      ),
                      child: TextButton(
                        child: Text('Create account',),
                        onPressed: () {
                          widget.toggleView();
                        },
                      ),
                    ),
                  ],
                ) : Container(),
                _isPortrait ? Text('or', style: TextStyle(color: Colors.white),) : Container(),
                _isPortrait ? OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))
                    ),
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text('Sign in with google', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    _signWithGoogle(context);
                  },
                ) : Container(),
                !_isPortrait ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Don\'t have an account yet?', style: TextStyle(color: Colors.white),),
                        Theme(
                          data: Theme.of(context).copyWith(
                            textButtonTheme: _textButtonThemeRed,
                          ),
                          child: TextButton(
                            child: Text('Create account',),
                            onPressed: () {
                              widget.toggleView();
                            },
                          ),
                        ),
                      ],
                    ),
                    Text('or', style: TextStyle(color: Colors.white),),
                    OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))
                        ),
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('Sign in with google', style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        _signWithGoogle(context);
                      },
                    ),
                  ],
                ) : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('You can also ', style: TextStyle(color: Colors.white),),
                    Theme(
                      data: Theme.of(context).copyWith(
                        textButtonTheme: _textButtonThemeRed,
                      ),
                      child: TextButton(
                        child: Text('continue anonymously',),
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


  _signinWithEmailAndPassword(BuildContext context) async {
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
  }

  _signWithGoogle(BuildContext context) async {
      final result = await _auth.signInGoogle();
      if(result == null) {
        print('Google sign in failed');
      } else if (!result['alreadyExists']) {
        final username = await Navigator.pushNamed(context, Subscribe.routeName) as String;
        print(username);
        if (username != null) {
          dynamic signupResult = await _auth.signUpGoogle(
              result['authCredentials'], result['email'],
              username);
          if (signupResult == null) {
            print('Google sign in failed');
          }
        }
      }
  }
}
