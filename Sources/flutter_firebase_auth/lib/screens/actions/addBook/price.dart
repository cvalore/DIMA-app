import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

class Price extends StatefulWidget {

  InsertedBook insertedBook;
  double height;
  bool justView;

  Price({Key key, @required this.insertedBook, @required this.height, @required this.justView}) : super(key: key);

  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: GestureDetector(
        onTap: () async {
          if(!widget.justView) {
            dynamic result = await Navigator.pushNamed(
                context, PriceBox.routeName, arguments: widget.insertedBook.price);
            setState(() {
              if (result != null)
                widget.insertedBook.setPrice(result);
            });
          }
        },
        child: Row(
          children: [
            Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Price",
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    widget.insertedBook.price != null ?
                    Expanded(
                        flex: 3,
                        child: Text(widget.insertedBook.price.toString() + ' €',
                            textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white),)) :
                    Container(),
                  ],
                )
            ),
            Expanded(
              flex: 1,
              child: Icon(Icons.arrow_forward_ios, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class PriceBox extends StatefulWidget {
  static const routeName = '/priceBox';

  @override
  _PriceBoxState createState() => _PriceBoxState();
}

class _PriceBoxState extends State<PriceBox> {

  String price;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final String args = ModalRoute.of(context).settings.arguments != null ?
    ModalRoute.of(context).settings.arguments.toString() : '';

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Price"),
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white24,
        onPressed: () {
          if (_formKey.currentState.validate()){
            //print("price as string is $price");
            if(!price.contains('.'))
              price = price + '.0';
            var priceAsDouble = double.parse(price);
            //print(priceAsDouble);
            Navigator.pop(context, double.parse(price));
          }
        },
        label: Text("Done", style: TextStyle(color: Colors.white),)
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  initialValue: args == '' ? null : args.toString(),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 16, color: Colors.white),
                    labelText: "Enter price",
                    hintText: '0.00',
                    suffixText: "€",
                    hintStyle: TextStyle(color: Colors.white,),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0),),
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.white)
                    ),
                    filled: true,
                    fillColor: Colors.white24,
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) =>
                    (value.isEmpty ||
                    value.startsWith('0') ||
                    value.contains(',') ||
                    (value.contains('.') && (value.substring(value.indexOf('.')).length > 3))) ?
                      'Enter a valid price' : null,
                  onChanged: (value) {
                    if(value != '') {
                      setState(() {
                        price = value;
                        //print(price);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

