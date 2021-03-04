class AddBookParameters {
  final int bookIndex;
  final bool isEditing;

  String editTitle;
  String editAuthor;
  String editPurpose;
  String editFictOrNot;
  String editGenre;

  AddBookParameters(this.isEditing,{
    this.bookIndex,
    this.editTitle,
    this.editAuthor,
    this.editPurpose,
    this.editFictOrNot,
    this.editGenre,
  });
}