import 'package:flutter/material.dart';

class ChatProfileFake extends StatelessWidget {

  final double height;

  const ChatProfileFake({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
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
                            Icons.message_outlined,
                          ),
                        )
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Chats",
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
        )
    );
  }
}
