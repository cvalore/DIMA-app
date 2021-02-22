import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:provider/provider.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a user obj based on Firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ?
      new User(uid: user.uid, isAnonymous: user.isAnonymous) :
      null;
  }

  //auth change user stream
  Stream<User> get userStream {
    return _auth.onAuthStateChanged.map(
            (FirebaseUser u) => _userFromFirebaseUser(u)
    );
  }

  //return current signed in user
  User currentUser(BuildContext context) {
    return Provider.of<User>(context);
  }

  //sign in anonymously
  Future signInAnonymously() async {
    try {
      AuthResult authResult = await _auth.signInAnonymously();
      FirebaseUser user = authResult.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email&password
  Future signInEmailPassword(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = authResult.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //register with email&password
  Future signUpEmailPassword(String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = authResult.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}