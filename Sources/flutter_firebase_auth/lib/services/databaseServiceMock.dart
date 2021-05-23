import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/myTransaction.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/services/storage.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class DatabaseServiceMock implements DatabaseService {


  @override
  StorageService storageService() {
    print("MOCK: storageService() method");
  }

  @override
  Future<List<Message>> addMessageToChat(
      String message, Chat chat, CustomUser userFromDb) {
    print("MOCK: addMessageToChat() method");
  }

  @override
  Future<dynamic> createNewChat(String userUid1, String userUid2,
      String userUid1Username, String userUid2Username) async {
    dynamic chatsMap = {
      "chatKey" : "",
      "userUid1" : "",
      "userUid2" : "",
      "userUid1Username" : "",
      "userUid2Username" : "",
      "messages" : [],
      "time" : Timestamp.fromDate(DateTime.now().add(Duration(minutes: 1))),
    };
    Duration delay = Duration(milliseconds: 100);
    Future<dynamic> result = Future<dynamic>.delayed(delay, () => chatsMap);
    await result;
    return result;
  }

  @override
  Future<dynamic> getMyChats() {
    print("MOCK: getMyChats() method");
  }

  @override
  Future<dynamic> getTransactionFromKey(String transactionKey) {
    print("MOCK: getTransactionFromKey() method");
  }

  @override
  Future declineExchange(
      String transactionId,
      String seller,
      Map<String, dynamic> sellerBook,
      String buyer,
      Map<String, dynamic> buyerBook) {
    print("MOCK: declineExchange() method");
  }

  @override
  Future acceptExchange(
      String transactionId,
      String seller,
      Map<String, dynamic> sellerBook,
      String buyer,
      Map<String, dynamic> buyerBook) {
    print("MOCK: acceptExchange() method");
  }

  @override
  Future purchaseAndProposeExchange(
      String sellingUser,
      chosenShippingMode,
      shippingAddress,
      payCash,
      List<InsertedBook> booksToPurchase,
      Map<InsertedBook, Map<String, dynamic>> booksToExchange,
      Map<int, String> thumbnails) {
    print("MOCK: purchaseAndProposeExchange() method");
    Utils.mockedInsertedBooksMap.clear();
    Utils.mockedInsertedBooks.clear();
  }

  @override
  Future<List<Message>> addMessageToForum(
      String message, ForumDiscussion discussion, CustomUser userFromDb) {
    print("MOCK: addMessageToForum() method");
  }

  @override
  Future<dynamic> createNewDiscussion(String category, String title) {
    print("MOCK: createNewDiscussion() method");
  }

  @override
  Future<dynamic> removeDiscussion(String title) {
    print("MOCK: removeDiscussion() method");
  }

  @override
  Future<dynamic> getForumDiscussions() {
    print("MOCK: getForumDiscussions() method");
  }

  @override
  Future removeShippingAddress(Map<String, dynamic> shippingAddressToRemove) {
    print("MOCK: removeShippingAddress() method");
  }

  @override
  Future removePaymentInfo(Map<String, dynamic> paymentCardToRemove) {
    print("MOCK: removePaymentInfo() method");
  }

  @override
  Future getShippingAddressInfo() {
    print("MOCK: getShippingAddressInfo() method");
  }

  @override
  Future getPaymentInfo() {
    print("MOCK: getPaymentInfo() method");
  }

  @override
  Future getPurchaseInfo() async {
    print("MOCK: getPurchaseInfo() method");
    Map<String, List<dynamic>> result = Map<String, List<dynamic>>();
    result['paymentCardInfo'] = [];
    result['shippingAddressInfo'] = [];
    return result;
  }

  @override
  Future<dynamic> savePaymentCardInfo(Map<String, dynamic> info) {
    print("MOCK: savePaymentCardInfo() method");
  }

  @override
  Future<dynamic> saveShippingAddressInfo(Map<String, dynamic> info) {
    print("MOCK: saveShippingAddressInfo() method");
  }

  @override
  Future<dynamic> getAllUsers() {
    print("MOCK: getAllUsers() method");
  }

  @override
  removeReviews(List<ReviewWrittenByMe> reviewsToDelete) {
    print("MOCK: removeReviews() method");
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getReviewsInfoByUid(
      List<String> usersUid) async {
    Duration delay = Duration(milliseconds: 0);
    Map<String, Map<String, dynamic>> result = {'reviewerUid': {'username': 'Carmelo', 'userProfileImageURL': ''}, 'reviewerUid2': {'username': 'Francesco', 'userProfileImageURL': ''}};
    Future<Map<String, Map<String, dynamic>>> res = Future<Map<String, Map<String, dynamic>>>.delayed(delay, () => result);
    await res;
    return res;
  }

  @override
  Future<Function> addReview(ReceivedReview review) {
    print("MOCK: addReview() method");
  }

  @override
  Future<Function> removeLike(
      int bookInsertionNumber, String userWhoDoesNotLike) {
    print("MOCK: removeLike() method");
  }

  @override
  Future<Function> addLike(
      int bookInsertionNumber, String thumbnail, String userWhoLikes) {
    print("MOCK: addLike() method");
  }

  @override
  Future<Function> unFollowUser(CustomUser followed) {
    print("MOCK: unFollowUser() method");
  }

  @override
  Future<Function> followUser(CustomUser followed) {
    print("MOCK: followUser() method");
  }

  @override
  Future<Function> setNowAsLastChatsDate() {
    print("MOCK: setNowAsLastChatsDate() method");
  }

  @override
  Future<Timestamp> getLastChatsDate() {
    print("MOCK: getLastChatsDate() method");
  }

  @override
  Future<Function> setNowAsLastNotificationDate() {
    print("MOCK: setNowAsLastNotificationDate() method");
  }

  @override
  Future<Timestamp> getLastNotificationDate() {
    print("MOCK: getLastNotificationDate() method");
  }

  @override
  Future<bool> canIReview(String toReviewUid) {
    print("MOCK: canIReview() method");
  }

  @override
  Future<dynamic> getBookForSearch(String bookId) async {
    print("MOCK: getBookForSearch() method");
    dynamic book = Utils.mockedInsertedBooksMap["Fantasy"]["books"][0];
    book = book[book.keys.elementAt(0).toString()];
    var toReturn = [];
    toReturn.add({
      "uid": "userUidData",
      "username": "userUsername",
      "userProfileImageURL": "",
      "email": "userEmail",
      "book": book,
      "info": "bookInfoData",
    });
    return toReturn;
  }

  @override
  Future<List<dynamic>> getMyExchangeableBooks() {
    print("MOCK: getMyExchangeableBooks() method");
  }

  @override
  Future<dynamic> getMyOrders() {
    print("MOCK: getMyOrders() method");
  }

  @override
  Future<dynamic> getMyFavoriteBooks() {
    print("MOCK: getMyFavoriteBooks() method");
  }

  @override
  Future<dynamic> viewBookByIdAndInsertionNumber(
      String bookId, int bookInsertionNumber, String userUid) {
    print("MOCK: viewBookByIdAndInsertionNumber() method");
  }

  @override
  Future<dynamic> getBookSoldBy(String bookId) async {
    print("MOCK: getBookSoldBy() method");
    if(Utils.mockedInsertedBooksMap.length == 0) {
      return;
    }
    dynamic book = Utils.mockedInsertedBooksMap["Fantasy"]["books"][0];
    book = book[book.keys.elementAt(0).toString()];
    book['imagesUrl'] = [];
    var toReturn = [];
    toReturn.add(
        {
          "uid": "userUid",
          "username": "userUsername",
          "userProfileImageURL": "",
          "email": "userEmail",
          "book": book,
          "thumbnail" : book["thumbnail"],
        }
    );
    return toReturn;
  }

  @override
  Future<dynamic> getGeneralBookInfo(String bookId) {
    print("MOCK: getGeneralBookInfo() method");
  }

  @override
  Future<InsertedBook> getBook(int index) {
    print("MOCK: getBook() method");
  }

  @override
  Future removeBook(int index, InsertedBook book) {
    print("MOCK: removeBook() method");
  }

  @override
  Future<CustomUser> getUserById(String uid) async {
    Duration delay = Duration(milliseconds: 100);
    final Future<CustomUser> user = Future<CustomUser>.delayed(delay, () => CustomUser('uid', username: 'Carmelo'));
    await user;
    return user;
  }

  @override
  Future<CustomUser> getUserSnapshot() {
    print("MOCK: getUserSnapshot() method");
  }

  @override
  Future<BookPerGenreUserMap> getUserBooksPerGenreSnapshot() async {
    print("MOCK: getUserBooksPerGenreSnapshot() method");
    return BookPerGenreUserMap({});
  }

  @override
  Future updateBook(
      InsertedBook book, int index, bool hadImages, bool wasExchangeable) {
    print("MOCK: updateBook() method");
  }

  @override
  Future addUserBook(InsertedBook book) {
    print("MOCK: addUserBook() method");
    Utils.mockedInsertedBooks.add(book);
    if(Utils.mockedInsertedBooksMap.containsKey(book.category)) {
      Utils.mockedInsertedBooksMap[book.category]['books'].add({book.id : book.toMap()});
    }
    else {
      Utils.mockedInsertedBooksMap.addAll({book.category : {"books" : [{book.id : book.toMap()}]}});
    }
  }

  @override
  Stream<List<MyTransaction>> get allTransactionsInfo {
    print("MOCK: allTransactionsInfo() stream");
  }

  @override
  Stream<List<MyTransaction>> get transactionsInfo {
    print("MOCK: transactionsInfo() stream");
  }

  @override
  Stream<Chat> get chatInfo {
    print("MOCK: chatInfo() stream");
  }

  @override
  Stream<ForumDiscussion> get discussionInfo {
    print("MOCK: discussionInfo() stream");
  }

  @override
  void setChat(Chat chat) {
    print("MOCK: setChat() method");
  }

  @override
  void setForumDiscussion(ForumDiscussion discussion) {
    print("MOCK: setForumDiscussion() method");
  }

  @override
  Stream<CustomUser> get userInfo {
    print("MOCK: userInfo() stream");
  }

  @override
  Stream<BookPerGenreUserMap> get userBooksPerGenre {
    print("MOCK: userBooksPerGenre() stream");
  }

  @override
  Stream<BookPerGenreMap> get perGenreBooks {
    print("MOCK: perGenreBooks() stream");
  }

  @override
  Future<bool> updateUserInfo(String imageProfilePath, bool oldImageRemoved,
      String fullName, String birthday, String bio, String city) {
    print("MOCK: updateUserInfo() method");
  }

  @override
  Future checkUsernameAlreadyUsed(String username) {
    print("MOCK: checkUsernameAlreadyUsed() method");
  }

  @override
  Future<Function> initializeUser() {
    print("MOCK: initializeUser() method");
  }

  @override
  CollectionReference usersCollection() {
    print("MOCK: usersCollection() method");
  }
}