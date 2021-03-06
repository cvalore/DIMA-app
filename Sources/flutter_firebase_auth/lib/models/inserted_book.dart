class InsertedBook {

  final String title;
  final String author;
  final String genre;
  final String purpose;
  final String fictOrNot;

  InsertedBook({ this.title, this.author, this.genre, this.purpose, this.fictOrNot});


  Map<String, String> toMap(){
    var myMap = new Map<String, String>();
    myMap['title'] = title;
    myMap['author'] = author;
    myMap['genre'] = genre;
    myMap['purpose'] = purpose;
    myMap['fictOrNot'] = fictOrNot;
    return myMap;
  }

}