import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeMyProfile.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:provider/provider.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    CustomUser userFromAuth = Provider.of<CustomUser>(context);
    DatabaseService _db = DatabaseService(user: userFromAuth);

    return StreamProvider<CustomUser>.value(
      value: _db.userInfo,
      child: Container(
        padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        VisualizeMyProfile(height: 60.0)
                        // i miei ordini
                        // i miei preferiti
                        // modalità vacanza ??
                        // invita amici // followers/following
                        // dettagli pagamento
                        /*
                        customSizedBox(1.0),
                        Status(insertedBook: insertedBook, height: 60, offset: 50.0),
                        customSizedBox(1.0),
                        edit ? Container() : Category(insertedBook: insertedBook, height: 60),
                        edit ? Container() : customSizedBox(1.0),
                        Comment(insertedBook: insertedBook, height: 60),
                        customSizedBox(1.0),
                        Price(insertedBook: insertedBook, height: 60),
                        customSizedBox(1.0),
                        Exchange(insertedBook: insertedBook, height: 60),
                        SizedBox(height: 100)
                         */

                        /*
                      Flexible(
                        flex: 4,
                        child: SizedBox(height: 20.0,),
                      ),
                      Flexible(
                        flex: 4,
                        child: SizedBox(height: 20.0,),
                      ),
                       */
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Widget customSizedBox(height) {
  return SizedBox(
    height: height,
    child: Container(
      color: Colors.black,
    ),
  );
}
