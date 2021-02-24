class BookGenres{

  List <String> bookGenresFiction = ['None', 'Classic', 'Crime/detective', 'Epic',
  'Fable', 'Fairy tale', 'Fantasy', 'Folktale', 'Historical fiction',
  'Horror', 'Humor', 'Legend', 'Magical realism', 'Meta fiction', 'Mystery',
  'Mythology', 'Realistic fiction', 'Romance', 'Satire', 'Science fiction',
  'Superhero fiction', 'Suspence/Thriller', 'Tragicomedy', 'Travel', 'Western'];

  List <String> bookGenresNonFiction = ['None', 'Biography', 'Essay', 'Journalism', 'Memoir',
  'Narrative/Personal narrative', 'Refrence', 'Self improvement', 'Speech', 'Scientific Article',
  'Textbook'];

  List <String> getFictionGenres(){
    return bookGenresFiction;
  }

  List <String> getNonFictionGenres(){
    return bookGenresNonFiction;
  }

}