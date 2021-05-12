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
//
  }

  @override
  Future<dynamic> createNewChat(String userUid1, String userUid2,
      String userUid1Username, String userUid2Username) {

  }

  @override
  Future<dynamic> getMyChats() {

  }

  @override
  Future<dynamic> getTransactionFromKey(String transactionKey) {

  }

  @override
  Future declineExchange(
      String transactionId,
      String seller,
      Map<String, dynamic> sellerBook,
      String buyer,
      Map<String, dynamic> buyerBook) {
//
  }

  @override
  Future acceptExchange(
      String transactionId,
      String seller,
      Map<String, dynamic> sellerBook,
      String buyer,
      Map<String, dynamic> buyerBook) {
//
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
//
  }

  @override
  Future<List<Message>> addMessageToForum(
      String message, ForumDiscussion discussion, CustomUser userFromDb) {
//
  }

  @override
  Future<dynamic> createNewDiscussion(String category, String title) {

  }

  @override
  Future<dynamic> removeDiscussion(String title) {

  }

  @override
  Future<dynamic> getForumDiscussions() {

  }

  @override
  Future removeShippingAddress(Map<String, dynamic> shippingAddressToRemove) {

  }

  @override
  Future removePaymentInfo(Map<String, dynamic> paymentCardToRemove) {

  }

  @override
  Future getShippingAddressInfo() {

  }

  @override
  Future getPaymentInfo() {

  }

  @override
  Future getPurchaseInfo() {

  }

  @override
  Future<dynamic> savePaymentCardInfo(Map<String, dynamic> info) {

  }

  @override
  Future<dynamic> saveShippingAddressInfo(Map<String, dynamic> info) {

  }

  @override
  Future<dynamic> getAllUsers() {

  }

  @override
  removeReviews(List<ReviewWrittenByMe> reviewsToDelete) {

  }

  @override
  Future<Map<String, Map<String, dynamic>>> getReviewsInfoByUid(
      List<String> usersUid) {

  }

  @override
  Future<Function> addReview(ReceivedReview review) {

  }

  @override
  Future<Function> removeLike(
      int bookInsertionNumber, String userWhoDoesNotLike) {
//
  }

  @override
  Future<Function> addLike(
      int bookInsertionNumber, String thumbnail, String userWhoLikes) {
//
  }

  @override
  Future<Function> unFollowUser(CustomUser followed) {

  }

  @override
  Future<Function> followUser(CustomUser followed) {

  }

  @override
  Future<Function> setNowAsLastChatsDate() {

  }

  @override
  Future<Timestamp> getLastChatsDate() {

  }

  @override
  Future<Function> setNowAsLastNotificationDate() {

  }

  @override
  Future<Timestamp> getLastNotificationDate() {

  }

  @override
  Future<bool> canIReview(String toReviewUid) {

  }

  @override
  Future<dynamic> getBookForSearch(String bookId) {

  }

  @override
  Future<List<dynamic>> getMyExchangeableBooks() {

  }

  @override
  Future<dynamic> getMyOrders() {

  }

  @override
  Future<dynamic> getMyFavoriteBooks() {

  }

  @override
  Future<dynamic> viewBookByIdAndInsertionNumber(
      String bookId, int bookInsertionNumber, String userUid) {
//
  }

  @override
  Future<dynamic> getBookSoldBy(String bookId) {

  }

  @override
  Future<dynamic> getGeneralBookInfo(String bookId) {

  }

  @override
  Future<InsertedBook> getBook(int index) {

  }

  @override
  Future removeBook(int index, InsertedBook book) {

  }

  @override
  Future<CustomUser> getUserById(String uid) {

  }

  @override
  Future<CustomUser> getUserSnapshot() {

  }

  @override
  Future<BookPerGenreUserMap> getUserBooksPerGenreSnapshot() {

  }

  @override
  Future updateBook(
      InsertedBook book, int index, bool hadImages, bool wasExchangeable) {
//
  }

  @override
  Future addUserBook(InsertedBook book) {

  }

  @override
  Stream<List<MyTransaction>> get allTransactionsInfo {

  }

  @override
  Stream<List<MyTransaction>> get transactionsInfo {

  }

  @override
  Stream<Chat> get chatInfo {

  }

  @override
  Stream<ForumDiscussion> get discussionInfo {

  }

  @override
  void setChat(Chat chat) {

  }

  @override
  void setForumDiscussion(ForumDiscussion discussion) {

  }

  @override
  Stream<CustomUser> get userInfo {

  }

  @override
  Stream<BookPerGenreUserMap> get userBooksPerGenre {

  }

  @override
  Stream<BookPerGenreMap> get perGenreBooks {

  }

  @override
  Future<bool> updateUserInfo(String imageProfilePath, bool oldImageRemoved,
      String fullName, String birthday, String bio, String city) {

  }

  @override
  Future checkUsernameAlreadyUsed(String username) {

  }

  @override
  Future<Function> initializeUser() {

  }

  @override
  CollectionReference usersCollection() {

  }
}