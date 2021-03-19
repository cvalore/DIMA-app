class PerGenreBook {

  String id;
  String title;   //redundant but useful for search
  String author;
  String thumbnail;

  PerGenreBook({this.id, this.title, this.author, this.thumbnail});

  /// returns mapping of the class excluding the bookGeneralInfo attribute
  Map<String, dynamic> toMap() {
    var perGenreBook = new Map<String, dynamic>();
    perGenreBook['id'] = id;
    perGenreBook['title'] = title;
    perGenreBook['author'] = author;
    perGenreBook['thumbnail'] = thumbnail;
    return perGenreBook;
  }
}