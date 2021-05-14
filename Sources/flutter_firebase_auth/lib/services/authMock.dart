import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/auth.dart';

class AuthMock implements AuthService {

  @override
  Stream<AuthCustomUser> get userStream {
    print("MOCK: userStream() stream");
    return StreamBuilder<AuthCustomUser>(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      return null;
    },).stream;
  }

  @override
  Future signOut() {

  }

  @override
  Future signUpGoogle(
      AuthCredential authCredential, String email, String username) {

  }

  @override
  Future signUpEmailPassword(String email, String password, String username) {

  }

  @override
  Future signInGoogle() {

  }

  @override
  Future signInEmailPassword(String email, String password) {

  }

  @override
  Future signInAnonymously() {

  }

  @override
  User currentUser(BuildContext context) {

  }
}