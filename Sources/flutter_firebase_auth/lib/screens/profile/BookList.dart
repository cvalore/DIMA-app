import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/inserted_book.dart';

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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
}



