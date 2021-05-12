import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'database.dart';

class AuthServiceImpl implements AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignin = GoogleSignIn();

  //create a user obj based on Firebase user
  AuthCustomUser _userFromFirebaseUser(User user) {
    return user != null ?
    new AuthCustomUser(user.uid, user.email, user.isAnonymous) :
    null;
  }


  //auth change user stream
  Stream<AuthCustomUser> get userStream {
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

      var userAlreadyExists = true;

      //check if user already exists
      CollectionReference usersCollection = DatabaseService().usersCollection();
      await usersCollection
          .where('email', isEqualTo: googleSignInAccount.email)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.size == 0) {
          userAlreadyExists = false;
        }
      });

      if (userAlreadyExists) {
        UserCredential credentialResult = await _auth.signInWithCredential(
            authCredential);
        User user = credentialResult.user;

        if (user != null) {
          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);
          User currentUser = _auth.currentUser;
          assert(currentUser.uid == user.uid);

          print('Google sign in succedeed');
          var map = Map<String,bool>();
          map['alreadyExists'] = true;
          return map;
        }
      } else {
        var map = Map<String,dynamic>();
        map['authCredentials'] = authCredential;
        map['alreadyExists'] = false;
        map['email'] = googleSignInAccount.email;
        return map;
      }
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //register with email&password
  Future signUpEmailPassword(String email, String password, String username) async {

    // check if username is already used
    dynamic usernameAlreadyExists = await DatabaseService().checkUsernameAlreadyUsed(username);
    if (usernameAlreadyExists) {
      return 'Username already used';
    }

    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;

      //add empty document for the new registered user
      CustomUser customUser = CustomUser(user.uid, email: user.email, isAnonymous: user.isAnonymous, username: username);
      await DatabaseService(user: customUser).initializeUser();

      return customUser;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  Future signUpGoogle(AuthCredential authCredential, String email, String username) async {
    try {

      UserCredential credentialResult = await _auth.signInWithCredential(authCredential);
      User user = credentialResult.user;

      if(user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        User currentUser = _auth.currentUser;
        assert(currentUser.uid == user.uid);

        print('Google sign in succedeed');

        //add empty document for the new registered user
        CustomUser customUser = CustomUser(user.uid, email: user.email, isAnonymous: user.isAnonymous, username: username);
        await DatabaseService(user: customUser).initializeUser();
        return customUser;
      }
      return null;

    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  //sign out
  Future signOut() async {
    try {
      print('Signed out');
      bool signedInWithGoogle = await _googleSignin.isSignedIn();
      if(signedInWithGoogle) {
        await _googleSignin.disconnect();
        await _googleSignin.signOut();
      }
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}