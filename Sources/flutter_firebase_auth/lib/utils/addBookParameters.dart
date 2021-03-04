class AddBookParameters {
  final int bookIndex;
  final bool isEditing;

  final String editTitle;
  final String editAuthor;
  final String editPurpose;
  final String editFictOrNot;
  final String editGenre;

  AddBookParameters(this.isEditing,{
    this.bookIndex,
    this.editTitle,
    this.editAuthor,
    this.editPurpose,
    this.editFictOrNot,
    this.editGenre,
  });
}