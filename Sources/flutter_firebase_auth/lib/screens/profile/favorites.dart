import 'package:flutter/material.dart';

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
              dynamic result = await Navigator.pushNamed(
                  context, FavoritesPage.routeName);
              setState(() {
                if (result != null)
                  //TODO
                  print('//TODO');
              });
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
                              color : Colors.black,
                              child: Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.red,
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
                                color: Colors.white70
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

class FavoritesPage extends StatefulWidget {
  static const routeName = '/favourites';
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('//TODO'));
  }
}

