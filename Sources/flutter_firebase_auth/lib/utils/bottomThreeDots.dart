import 'package:flutter/material.dart';

class BottomThreeDots extends StatelessWidget {

  final darkerIndex;
  final size;
  final double height;

  const BottomThreeDots({Key key, this.size = 10.0, this.darkerIndex = 2, this.height = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final index = darkerIndex < 0 ? 0 : (darkerIndex > 2 ? 2 : darkerIndex);

    return Container(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.circle, color: index == 0 ? Colors.blueGrey[600] : Colors.blueGrey[100], size: size,),
          Icon(Icons.circle, color: Colors.transparent, size: 3.0,),
          Icon(Icons.circle, color: index == 1 ? Colors.blueGrey[600] : Colors.blueGrey[100], size: size,),
          Icon(Icons.circle, color: Colors.transparent, size: 3.0,),
          Icon(Icons.circle, color: index == 2 ? Colors.blueGrey[600] : Colors.blueGrey[100], size: size),
        ],
      ),
    );
  }
}
