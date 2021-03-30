import 'package:flutter/material.dart';



class Subscribe extends StatefulWidget {
  static const routeName = '/subscribe';

  @override
  SubscribeState createState() => SubscribeState();
}

class SubscribeState extends State<Subscribe> {

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  String username = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Subscribe"),
        //backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      //backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: username,
                      cursorColor: Colors.black,
                      //decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        contentPadding: EdgeInsets.only(top: 25.0),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 17.0,),
                      validator: (value) =>
                      value.isEmpty ? 'Enter a valid username' : null,
                      onChanged: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0.0),
                    child: Container(
                      width: width * 0.5,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.white10;
                                }
                                else {
                                  return Colors.white24;
                                }
                              }),
                        ),
                        child: Text('Sign Up', style: TextStyle(color: Colors.white),),
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            Navigator.pop(context, username);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
