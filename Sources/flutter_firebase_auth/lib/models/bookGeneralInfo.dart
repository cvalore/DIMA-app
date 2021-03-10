class BookGeneralInfo {

  final String title;
  final String author;
  final String thumbnail;   //TODO check thumbnail
  final String summary;
  final String isbn13;
  final int pageCount;
  final List<String> categories;
  final int rating;
  final String language;

  BookGeneralInfo(this.title, this.author, this.thumbnail, this.isbn13, this.language, {this.summary, this.pageCount, this.categories, this.rating});


  //TODO check if it is ok
  Map<String, dynamic> toMap() {
    var bookMap = new Map<String, dynamic>();
    bookMap['title'] = title;
    bookMap['author'] = author;
    bookMap['thumbnail'] = thumbnail;
    bookMap['isbn'] = isbn13;
    bookMap['language'] = language;
    if (summary != null) bookMap['summary'] = summary;
    if (pageCount != null) bookMap['pageCount'] = pageCount;
    if (categories != null) bookMap['categories'] = categories;
    if (rating != null) bookMap['ratingsCount'] = rating;
    return bookMap;
  }
}