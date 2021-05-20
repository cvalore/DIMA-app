import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/utils/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';


class Exchanges extends StatefulWidget {

  List<dynamic> exchanges;
  String type;

  Exchanges({Key key, this.exchanges, this.type});

  @override
  _ExchangesState createState() => _ExchangesState();
}

class _ExchangesState extends State<Exchanges> {

  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return loading == true ? Loading() : Scaffold(
        body: widget.exchanges != null && widget.exchanges.length != 0 ?
        ListView.builder(
        itemCount: widget.exchanges.length,
        itemBuilder: (context, index) {
      return InkWell(
        onTap: () {
          Utils.pushExchangedBookPage(context, widget.exchanges[index], widget.type);
        },
        child: Card(
          elevation: 0.0,
          child: LimitedBox(
            maxHeight: 190,
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
                        child: widget.exchanges[index]['receivedBook']['imagesUrl'] != null && widget.exchanges[index]['receivedBook']['imagesUrl'].length > 0 ?
                        Image.network(widget.exchanges[index]['receivedBook']['imagesUrl'][0]) : widget.exchanges[index]['receivedBook']['thumbnail'] != null ?
                        Image.network(widget.exchanges[index]['receivedBook']['thumbnail'])
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
                                  "${widget.exchanges[index]['time'].toDate().year}-${widget.exchanges[index]['time'].toDate().month}-${widget.exchanges[index]['time'].toDate().day}",
                                  //Utils.computeHowLongAgoFromTimestamp(print(widget.purchases[index]['time'].runtimeType)),
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
                            widget.exchanges[index]['receivedBook']['title'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Text('by\t\t '),
                            Flexible(
                              child: Text(
                                widget.exchanges[index]['receivedBook']['author'].substring(1, widget.exchanges[index]['receivedBook']['author'].length - 1),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text('exchanged for my '),
                        SizedBox(height: 4),
                        Flexible(
                          child: Text(widget.exchanges[index]['offeredBook']['title'],
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
                                widget.exchanges[index]['offeredBook']['author'].substring(1, widget.exchanges[index]['offeredBook']['author'].length - 1),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
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
    ) :
      Center(
        child: widget.type == 'Accepted' ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('All your accepted exchanges will appear here!'), Icon(Icons.compare_arrows_outlined)]
        ) : widget.type == 'Pending' ?
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('All your pending exchanges will appear here!'), Icon(Icons.pending_outlined)]
        ) :  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('All your rejected exchanges will appear here!'), Icon(Icons.cancel_outlined)]
        ),
      ),
    );
  }
}
