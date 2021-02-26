class InsertedBook {

  final String title;
  final String author;
  final String genre;

  // purpose should be forSale or toExchange
  final String purpose;

  InsertedBook({ this.title, this.author, this.genre, this.purpose });


  Map<String, String> toMap(){
    var myMap = new Map<String, String>();
    myMap['title'] = title;
    myMap['author'] = author;
    myMap['genre'] = genre;
    myMap['purpose'] = purpose;
    return myMap;
  }

}