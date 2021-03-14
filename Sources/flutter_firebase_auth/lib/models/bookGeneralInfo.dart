class BookGeneralInfo {

  final String title;
  final String author;
  final String publisher;
  final String publishedDate;
  final String thumbnail;   //TODO check thumbnail
  final String description;
  final String isbn13;
  final String language;
  List<String> categories;
  double averageRating;
  int pageCount;
  int ratingsCount;

  BookGeneralInfo(this.title,
      this.author,
      this.publisher,
      this.publishedDate,
      this.isbn13,
      this.thumbnail,
      this.description,
      this.categories,
      this.language,
      this.pageCount,
      this.averageRating,
      this.ratingsCount);


  //TODO check if it is ok
  Map<String, dynamic> toMap() {
    var bookMap = new Map<String, dynamic>();
    bookMap['title'] = title;
    bookMap['author'] = author;
    bookMap['isbn'] = isbn13;
    bookMap['language'] = language;
    if (thumbnail != null) bookMap['thumbnail'] = thumbnail;
    if (description != null) bookMap['summary'] = description;
    if (pageCount != null) bookMap['pageCount'] = pageCount;
    if (categories != null) bookMap['categories'] = categories;     //TODO check if safe
    if (averageRating != null) bookMap['ratingsCount'] = averageRating;
    return bookMap;
  }
}