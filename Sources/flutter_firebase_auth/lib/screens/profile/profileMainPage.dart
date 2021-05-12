import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/myTransaction.dart';
import 'package:flutter_firebase_auth/models/shippingAddressInfo.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/chatProfileManager.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationProfileManager.dart';
import 'package:flutter_firebase_auth/screens/profile/favorites/favorites.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/orders.dart';
import 'package:flutter_firebase_auth/screens/profile/paymentInfo/paymentInfo.dart';
import 'package:flutter_firebase_auth/screens/profile/shippingAddress/shippingAddress.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';


class ProfileMainPage extends StatefulWidget {

  const ProfileMainPage({Key key}) : super(key: key);

  @override
  _ProfileMainPageState createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return StreamProvider<CustomUser>.value(
      value: _db.userInfo,
      child: Container(
        padding: EdgeInsets.fromLTRB(_isTablet ? 150.0 : 25.0, _isTablet ? 10.0 : 0.0, _isTablet ? 150.0 : 25.0, 20.0),
        child:
        _isPortrait ?
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        //do a sliver appbar with visualize profile??
                        VisualizeProfile(height: _isTablet ? 200.0 : 120.0),
                        Divider(height: 15, thickness: 2,),
                        Favorites(height: _isTablet ? 100.0 : 60.0),
                        Divider(height: 15, thickness: 2,),
                        Orders(height: _isTablet ? 100.0 : 60.0),
                        Divider(height: 15, thickness: 2,),
                        ChatProfileManager(height: _isTablet ? 100.0 : 60.0),
                        Divider(height: 15, thickness: 2,),
                        StreamProvider<List<MyTransaction>>.value(
                            value: Utils.databaseService.allTransactionsInfo,
                            child: NotificationProfileManager(height: _isTablet ? 100.0 : 60.0,)
                        ),
                        Divider(height: 15, thickness: 2,),
                        PaymentInfo(height: _isTablet ? 100.0 : 60.0),
                        Divider(height: 15, thickness: 2,),
                        ShippingAddress(height: _isTablet ? 100.0 : 60.0)
                      ],
                    ),
                  )
              ),
            ),
          ],
        ) :
        Row(
          children: <Widget>[
            Container(
              width: _isTablet ? MediaQuery.of(context).size.width/5 : MediaQuery.of(context).size.width/4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              //do a sliver appbar with visualize profile??
                              VisualizeProfile(height: _isTablet ? 200.0 : 120.0),
                              // dettagli pagamento
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: _isTablet ? MediaQuery.of(context).size.width/2 : 3*MediaQuery.of(context).size.width/4 - 105,
              height: MediaQuery.of(context).size.height,
              alignment: AlignmentDirectional.center,
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Favorites(height: _isTablet ? 100.0 : 60.0),
                      Divider(height: 15, thickness: 2,),
                      Orders(height: _isTablet ? 100.0 : 60.0),
                      Divider(height: 15, thickness: 2,),
                      ChatProfileManager(height: _isTablet ? 100.0 : 60.0),
                      Divider(height: 15, thickness: 2,),
                      StreamProvider<List<MyTransaction>>.value(
                          value: Utils.databaseService.allTransactionsInfo,
                          child: NotificationProfileManager(height: _isTablet ? 100.0 : 60.0,),
                      ),
                      Divider(height: 15, thickness: 2,),
                      PaymentInfo(height: _isTablet ? 100.0 : 60.0),
                      Divider(height: 15, thickness: 2,),
                      ShippingAddress(height: _isTablet ? 100.0 : 60.0),
                      // dettagli pagamento
                    ],
                  )
              ),
            )
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
