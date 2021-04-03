import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/favorites.dart';
import 'package:flutter_firebase_auth/screens/profile/orders.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:provider/provider.dart';


class ProfileMainPage extends StatefulWidget {
  @override
  _ProfileMainPageState createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, userFromAuth.email, userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

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
                        //do a sliver appbar with visualize profile??
                        VisualizeProfile(height: 120.0),
                        Divider(height: 15, thickness: 2,),
                        Favorites(height: 60.0),
                        Divider(height: 15, thickness: 2,),
                        Orders(height: 60.0),
                        Divider(height: 15, thickness: 2,),
                        // dettagli pagamento
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

Widget customSizedBox(height, colour) {
  return SizedBox(
    height: height,
    child: Container(
      color: colour,
    ),
  );
}
