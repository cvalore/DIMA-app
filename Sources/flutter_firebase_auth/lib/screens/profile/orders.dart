import 'package:flutter/material.dart';

class Orders extends StatefulWidget {

  final double height;

  Orders({Key key, @required this.height}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        child: GestureDetector(
          onTap: () async {
            dynamic result = await Navigator.pushNamed(
                context, OrdersPage.routeName);
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
                              Icons.shopping_cart_outlined,
                              color: Colors.white70,
                            ),
                          )
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("My orders",
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

class OrdersPage extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('//TODO'));
  }
}

