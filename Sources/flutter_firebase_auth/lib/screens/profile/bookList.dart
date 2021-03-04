import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/inserted_book.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/addBookParameters.dart';
import 'package:provider/provider.dart';


class BookList extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);
    final DatabaseService _db = DatabaseService(user: user);

    var books = [];
    books = Provider.of<List<InsertedBook>>(context);
    if (books == null){
      print('here'); //TODO: PERCHE' NON SI VEDE?? prima c'era il widget Loading
      //Scoperto che si vede per un istante e poi non piu, perche?
      return Column(
        children: <Widget>[
          Text('No books yet, the books you add will appear here'),
          Icon(Icons.menu_book_rounded),
        ],
      );
    } else {
      return ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key('${books[index].title}'), //TODO: SERVE UN ID UNIVOCO!!
            background: Container(color: Colors.red[600]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _db.removeBook(index);

              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Book removed: ' + '${books[index].title}',)),
              );
            },
            child: ListTile(
              title: Text('${books[index].title}'),
              subtitle: Text('by ${books[index].author}'),
              trailing: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                ),
                child: Icon(Icons.remove_circle_outline, color: Colors.red,),
                onPressed: () {
                  _db.removeBook(index);
                },
              ),
              onTap: () async {
                InsertedBook book = await _db.getBook(index);
                AddBookParameters args = AddBookParameters(true,
                  bookIndex: index,
                  editTitle: book.title,
                  editAuthor: book.author,
                  editGenre: book.genre,
                  editPurpose: book.purpose,
                  //editFictOrNot: book['fiction']
                );
                Navigator.pushNamed(context, '/addBook', arguments: args);
              },
            ),
          );
        },
      );
      for (var book in books) {
        print("$book + bam");
      }
    }
    //var datum = books.data();
    //print(books.data()['book']);
    //print('$datum altro');
    return Text('sticazzzzz');
  }
}

    /*
    List books = [];
    books.add(InsertedBook(title: 'Oceano Mare', author: 'Alessandro Baricco'));
    books.add(InsertedBook(title: 'Emmaus', author: 'Alessandro Baricco'));
    books.add(InsertedBook(title: 'Un uomo', author: 'Oriana Fallaci'));

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
          title: Text('Ciao'),
    ),
          body: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
              return ListTile(
                  title: Text('title: ${books[index].title}'),
                  subtitle: Text('author: ${books[index].author}'),
                  );
            }),
    ),
    );
  }

     */


