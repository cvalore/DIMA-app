import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

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
    Utils.mockedLoggedUser = null;
  }

  @override
  Future signUpGoogle(
      AuthCredential authCredential, String email, String username) {
    print("MOCK: signUpGoogle() method");
  }

  @override
  Future signUpEmailPassword(String email, String password, String username) async {
    print("MOCK: signUpEmailPassword() method");
    CustomUser user = CustomUser("testUid", email: email, isAnonymous: false, username: username);
    Utils.mockedLoggedUser = AuthCustomUser(user.uid, user.email, user.isAnonymous);
    Utils.mockedUsers.addAll({
      email : password
    });
    return user;
  }

  @override
  Future signInGoogle() {
    print("MOCK: signInGoogle() method");
  }

  @override
  Future signInEmailPassword(String email, String password) async {
    print("MOCK: signInEmailPassword() method");
    if(Utils.mockedUsers.containsKey(email) && Utils.mockedUsers[email] == password) {
      AuthCustomUser user = AuthCustomUser("testUid", email, false);
      Utils.mockedLoggedUser = user;
      return user;
    }
    return null;
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