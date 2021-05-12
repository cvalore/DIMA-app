import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/authMock.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

import 'authImpl.dart';

abstract class AuthService {

  factory AuthService () {
    if(Utils.mockedDb) {
      return AuthMock();
    }
    else {
      return AuthServiceImpl();
    }
  }

  //create a user obj based on Firebase user
  AuthCustomUser _userFromFirebaseUser(User user);


  //auth change user stream
  Stream<AuthCustomUser> get userStream;

  //return current signed in user
  User currentUser(BuildContext context);

  //sign in anonymously
  Future signInAnonymously();

  //sign in with email&password
  Future signInEmailPassword(String email, String password);


  //sign in with email&password
  Future signInGoogle();

  //register with email&password
  Future signUpEmailPassword(String email, String password, String username);


  Future signUpGoogle(AuthCredential authCredential, String email, String username);

  //sign out
  Future signOut();
}