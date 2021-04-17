import 'package:flutter/material.dart';

class DiscussionTabBody extends StatelessWidget {

  final dynamic discussions;

  const DiscussionTabBody({Key key, this.discussions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return discussions.length == 0 ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No discussions yet",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 15
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.5),
              child: Icon(Icons.info_outline)
            ),
          ],
        ) :
        Center(child: Text("TODO"),);
  }
}
