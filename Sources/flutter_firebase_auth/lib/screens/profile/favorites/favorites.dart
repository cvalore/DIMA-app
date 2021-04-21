import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/favorites/favoritesMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {

  double height;

  Favorites({Key key, @required this.height}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {

    return Container(
        height: widget.height,
        child: GestureDetector(
          onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FutureBuilder(
                  future: Utils.databaseService.getMyFavoriteBooks(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting)
                      return Loading();
                    else
                      return FavoritesMainPage(likedBooks: snapshot.data);
                  }
              );
            }));
          },
          child: Row(
            children: [
              Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              child: Icon(
                                Icons.favorite_border_outlined,
                              ),
                          )
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("My favorites",
                            style: TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              )
            ],
          ),
        )
    );
  }
}
