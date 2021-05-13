
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

import 'package:flutter_firebase_auth/utils/loading.dart';


class Purchases extends StatefulWidget {

  List<dynamic> purchases;

  Purchases({Key key, this.purchases});

  @override
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    /*bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;*/

    return loading == true ? Loading() : Scaffold(
      body: widget.purchases != null && widget.purchases.length != 0 ?
        ListView.builder(
            itemCount: widget.purchases.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  print(widget.purchases[index]);
                  Utils.pushBoughtItemPage(context, widget.purchases[index]);
                },
                child: Card(
                  elevation: 0.0,
                  //height: MediaQuery.of(context).size.height / 5,
                  child: LimitedBox(
                    maxHeight: 170,
                    //setMaxHeight(widget.reviews[index].review),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: ClipRRect(
                                borderRadius : BorderRadius.circular(8.0),
                                child: widget.purchases[index]['imagesUrl'] != null && widget.purchases[index]['imagesUrl'].length > 0 ?
                                Image.network(widget.purchases[index]['imagesUrl'][0]) : widget.purchases[index]['thumbnail'] != null ?
                                Image.network(widget.purchases[index]['thumbnail'])
                                    : Image.asset("assets/images/no_image_available.png"),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                                      child: Text(
                                        "${widget.purchases[index]['time'].toDate().year}-${widget.purchases[index]['time'].toDate().month}-${widget.purchases[index]['time'].toDate().day}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                        fontSize: 12,
                                        //color: Colors.grey[600],
                                        fontWeight: FontWeight.normal
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: Text(
                                    widget.purchases[index]['title'],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text('by\t\t '),
                                    Flexible(
                                      child: Text(
                                        widget.purchases[index]['author'].substring(1, widget.purchases[index]['author'].length - 1),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Text(
                                  widget.purchases[index]['price'].toString() + ' €',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 2),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
        ) : Container()
    );
  }
}
