class BookGenres{

  final List<String> bookGenresFiction = ['___', 'Classic', 'Crime/detective', 'Epic',
  'Fable', 'Fairy tale', 'Fantasy', 'Folktale', 'Historical fiction',
  'Horror', 'Humor', 'Legend', 'Magical realism', 'Meta fiction', 'Mystery',
  'Mythology', 'Realistic fiction', 'Romance', 'Satire', 'Science fiction',
  'Superhero fiction', 'Suspence/Thriller', 'Tragicomedy', 'Travel', 'Western'];

  final List<String> bookGenresNonFiction = ['___', 'Biography', 'Essay', 'Journalism', 'Memoir',
  'Narrative/Personal narrative', 'Reference', 'Self improvement', 'Speech', 'Scientific Article',
  'Textbook'];


  final List<String> allBookGenres = ['Classic', 'Crime/detective', 'Epic',
    'Fable', 'Fairy tale', 'Fantasy', 'Folktale', 'Historical fiction',
    'Horror', 'Humor', 'Legend', 'Magical realism', 'Meta fiction', 'Mystery',
    'Mythology', 'Realistic fiction', 'Romance', 'Satire', 'Science fiction',
    'Superhero fiction', 'Suspence/Thriller', 'Tragicomedy', 'Travel', 'Western',
    'Biography', 'Essay', 'Journalism', 'Memoir', 'Narrative/Personal narrative',
    'Reference', 'Self improvement', 'Speech', 'Scientific Article', 'Textbook'];


  Map<String, List<String>> getGenres(){
    var allGenres = new Map<String, List<String>>();
    allGenres['Fiction'] = bookGenresFiction;
    allGenres['Not Fiction'] = bookGenresNonFiction;
    return allGenres;
  }

}