import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

import 'chatProfileBody.dart';

class ChatProfile extends StatelessWidget {
  
  final double height;

  const ChatProfile({Key key, this.height}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        child: GestureDetector(
          onTap: () async {

            Timestamp lastChatsDate = await Utils.databaseService.getLastChatsDate();
            await Utils.databaseService.setNowAsLastChatsDate();

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FutureBuilder(
                  future: Utils.databaseService.getMyChats(),
                  builder: (BuildContext context,
                      AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Loading();
                    else
                      return Scaffold(
                          resizeToAvoidBottomInset: false,
                          //backgroundColor: Colors.black,
                          appBar: AppBar(
                            //backgroundColor: Colors.black,
                            elevation: 0.0,
                            title: Text('My chats', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              letterSpacing: 1.0,
                            ),),
                          ),
                          body: ChatProfileBody(chatsMap: snapshot.data, lastChatsDate: lastChatsDate,)
                      );
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
          ),
        )
    );
  }
}
