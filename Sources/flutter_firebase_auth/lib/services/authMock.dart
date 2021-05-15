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
    print("MOCK: signOut() method");
  }

  @override
  Future signUpGoogle(
      AuthCredential authCredential, String email, String username) {
    print("MOCK: signUpGoogle() method");
  }

  @override
  Future signUpEmailPassword(String email, String password, String username) {
    print("MOCK: signUpEmailPassword() method");
  }

  @override
  Future signInGoogle() {
    print("MOCK: signInGoogle() method");
  }

  @override
  Future signInEmailPassword(String email, String password) {
    print("MOCK: signInEmailPassword() method");
  }

  @override
  Future signInAnonymously() {
    print("MOCK: signInAnonymously() method");
  }

  @override
  User currentUser(BuildContext context) {
    print("MOCK: currentUser() method");
  }
}