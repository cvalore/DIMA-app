import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignin = GoogleSignIn();

  bool _signedInGoogle = false;

  //create a user obj based on Firebase user
  CustomUser _userFromFirebaseUser(User user) {
    return user != null ?
      new CustomUser(user.uid, user.email, user.isAnonymous) :
      null;
  }


  //auth change user stream
  Stream<CustomUser> get userStream {
    return _auth.authStateChanges().map(
            (User u) => _userFromFirebaseUser(u)
    );
  }

  //return current signed in user
  User currentUser(BuildContext context) {
    return Provider.of<User>(context);
  }

  //sign in anonymously
  Future signInAnonymously() async {
    try {
      UserCredential authResult = await _auth.signInAnonymously();
      User user = authResult.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email&password
  Future signInEmailPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;

      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  //sign in with email&password
  Future signInGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignin.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken
      );

      UserCredential credentialResult = await _auth.signInWithCredential(authCredential);
      User user = credentialResult.user;

      if(user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        User currentUser = _auth.currentUser;
        assert(currentUser.uid == user.uid);

        print('Google sign in succedeed');
        _signedInGoogle = true;

        //add empty document for the new registered user
        CustomUser customUser = _userFromFirebaseUser(user);
        await DatabaseService(user: customUser).initializeUser(); //TODO add here the username

        return customUser;
      }

      return null;

    } catch(e) {
      print(e.toString());      //TODO stampare a schermo che la mail è già usata
      return null;
    }
  }

  //register with email&password
  Future signUpEmailPassword(String email, String password, String username) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;

      //add empty document for the new registered user
      CustomUser customUser = CustomUser(user.uid, user.email, user.isAnonymous, username: username);
      print("username is ${username }");
      await DatabaseService(user: customUser).initializeUser();

      return customUser;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  //sign out
  Future signOut() async {
    try {
      if(_signedInGoogle) {
        print('Google signed out');
        return await _googleSignin.signOut();
      }
      else {
        return await _auth.signOut();
      }
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}