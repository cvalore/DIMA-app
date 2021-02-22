class User {
  final String uid;
  final bool isAnonymous;

  User({this.uid, this.isAnonymous});

  @override
  String toString() {
    return
      "User: " +
      this.uid +
      " (isAnonymous? " +
      this.isAnonymous.toString() + ")";
  }
}