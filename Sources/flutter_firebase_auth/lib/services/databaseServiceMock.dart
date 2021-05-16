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
      String userUid1Username, String userUid2Username) {
    print("MOCK: createNewChat() method");
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
  Future getPurchaseInfo() {
    print("MOCK: getPurchaseInfo() method");
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
      List<String> usersUid) {
    print("MOCK: getReviewsInfoByUid() method");
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
  Future<dynamic> getBookForSearch(String bookId) {
    print("MOCK: getBookForSearch() method");
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
  Future<dynamic> getBookSoldBy(String bookId) {
    print("MOCK: getBookSoldBy() method");
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
  Future<CustomUser> getUserById(String uid) {
    print("MOCK: getUserById() method");
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