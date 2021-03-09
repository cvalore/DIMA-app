import 'package:flutter/material.dart';



class DescriptionBox extends StatefulWidget {

  double height;

  DescriptionBox({Key key, @required this.height}) : super(key: key);

  @override
  _DescriptionBoxState createState() => _DescriptionBoxState();
}

class _DescriptionBoxState extends State<DescriptionBox> {

  String description = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: ListTile(
        title: Text(
          "Description",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () async {
          dynamic result = await Navigator.pushNamed(context, Description.routeName, arguments: description);
          setState(() {
            if(result != null)
              description = result;
          });
        },
      ),
    );
  }
}

class Description extends StatefulWidget {
  static const routeName = '/description';
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {

  String description = '';

  @override
  Widget build(BuildContext context) {

    final String args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Book description"),
      ),
      floatingActionButton : FloatingActionButton(
        heroTag: "saveDescrButt",
        child: Icon(Icons.check_outlined),
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          print(description);
          Navigator.pop(context, description);
        },
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Card(
              color: Colors.white10,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: args,
                  maxLines: 8,
                  decoration: InputDecoration.collapsed(hintText: "Enter your description here"),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
              )
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),
        ],
      ),
    );
  }
}

