class AddBookParameters {
  final int bookIndex;
  final bool isEditing;

  String editPurpose;
  String editGenre;

  AddBookParameters(this.isEditing,{
    this.bookIndex,
    this.editPurpose,
    this.editGenre,
  });
}