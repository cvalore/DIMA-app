import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/myTransaction.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/databaseServiceMock.dart';
import 'package:flutter_firebase_auth/services/datebaseImpl.dart';
import 'package:flutter_firebase_auth/services/storage.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';


abstract class DatabaseService {

  factory DatabaseService({CustomUser user}) {
    if(Utils.mockedDb) {
      return DatabaseServiceMock();
    }
    else {
      return user == null ?  DatabaseServiceImpl() : DatabaseServiceImpl(user: user);
    }
  }

  //region Init

  /*
  StorageService storageService = StorageService();

  final CollectionReference bookCollection = FirebaseFirestore.instance
      .collection('books');
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');
  final CollectionReference booksPerGenreCollection = FirebaseFirestore.instance
      .collection('booksPerGenre');
  final CollectionReference forumDiscussionCollection = FirebaseFirestore.instance
      .collection('forumDiscussion');
  final CollectionReference transactionsCollection = FirebaseFirestore.instance
      .collection('transactions');
  final CollectionReference chatsCollection = FirebaseFirestore.instance
      .collection('chats');
  */
  //endregion

  //region Getters

  StorageService storageService();

  CollectionReference usersCollection();

  //endregion

  //region Authentication

  Future<void> initializeUser();

  Future checkUsernameAlreadyUsed(String username);

  Future<bool> updateUserInfo(String imageProfilePath, bool oldImageRemoved, String fullName,
      String birthday, String bio, String city);

  //endregion

  //region Streams

  Stream<BookPerGenreMap> get perGenreBooks;

  Stream<BookPerGenreUserMap> get userBooksPerGenre;

  Stream<CustomUser> get userInfo;

  void setForumDiscussion(ForumDiscussion discussion);

  void setChat(Chat chat);

  Stream<ForumDiscussion> get discussionInfo;

  Stream<Chat> get chatInfo;

  Stream<List<MyTransaction>> get transactionsInfo;

  Stream<List<MyTransaction>> get allTransactionsInfo;

  ForumDiscussion _forumDiscussionFromSnapshot(DocumentSnapshot documentSnapshot);

  Chat _chatFromSnapshot(DocumentSnapshot documentSnapshot);

  List<MyTransaction> _transactionFromSnapshot(DocumentSnapshot documentSnapshot);

  List<MyTransaction> _allTransactionFromSnapshot(DocumentSnapshot documentSnapshot);

  //endregion

  //region Books

  Future addUserBook(InsertedBook book);


  Future updateBook(InsertedBook book, int index, bool hadImages,
      bool wasExchangeable);

  BookPerGenreUserMap _bookPerGenreUserListFromSnapshot(
      DocumentSnapshot documentSnapshot);

  BookPerGenreMap _bookPerGenreListFromSnapshot(QuerySnapshot querySnapshot);

  CustomUser _userInfoFromSnapshot(DocumentSnapshot documentSnapshot);

  Future<BookPerGenreUserMap> getUserBooksPerGenreSnapshot();

  Future<CustomUser> getUserSnapshot();

  Future<CustomUser> getUserById(String uid);

  Future removeBook(int index, InsertedBook book);

  Future<InsertedBook> getBook(int index);

  Future<dynamic> getGeneralBookInfo(String bookId);

  Future<dynamic> getBookSoldBy(String bookId);

  Future<dynamic> viewBookByIdAndInsertionNumber(String bookId, int bookInsertionNumber, String userUid);

  Future<dynamic> getMyFavoriteBooks();

  Future<dynamic> getMyOrders();

  Future<List<dynamic>> getMyExchangeableBooks();

  Future<dynamic> getBookForSearch(String bookId);

  //endregion

  //region Profile/User

  Future<bool> canIReview(String toReviewUid);

  Future<Timestamp> getLastNotificationDate();

  Future<void> setNowAsLastNotificationDate();

  Future<Timestamp> getLastChatsDate();

  Future<void> setNowAsLastChatsDate();

  Future<void> followUser(CustomUser followed);

  Future<void> unFollowUser(CustomUser followed);

  Future<void> addLike(int bookInsertionNumber, String thumbnail, String userWhoLikes);

  Future<void> removeLike(int bookInsertionNumber, String userWhoDoesNotLike);

  Future<void> addReview(ReceivedReview review);

  Future<Map<String, Map<String, dynamic>>> getReviewsInfoByUid(List<String> usersUid);

  removeReviews(List<ReviewWrittenByMe> reviewsToDelete);

  Future<dynamic> getAllUsers();

  Future<dynamic> saveShippingAddressInfo(Map<String, dynamic> info);

  Future<dynamic> savePaymentCardInfo(Map<String, dynamic> info);

  Future getPurchaseInfo();

  Future getPaymentInfo();

  Future getShippingAddressInfo();

  Future removePaymentInfo(Map<String, dynamic> paymentCardToRemove);

  Future removeShippingAddress(Map<String, dynamic> shippingAddressToRemove);

  //endregion

  //region Forum

  Future<dynamic> getForumDiscussions();

  Future<dynamic> removeDiscussion(String title);

  Future<dynamic> createNewDiscussion(String category, String title);

  Future<List<Message>> addMessageToForum(String message, ForumDiscussion discussion, CustomUser userFromDb);

  //endregion

  //region Purchase

  Future purchaseAndProposeExchange(String sellingUser, chosenShippingMode, shippingAddress, payCash, List<InsertedBook> booksToPurchase, Map<InsertedBook, Map<String, dynamic>> booksToExchange, Map<int, String> thumbnails);

  Future acceptExchange(String transactionId, String seller, Map<String, dynamic> sellerBook,
      String buyer, Map<String, dynamic> buyerBook
      );

  Future declineExchange(String transactionId, String seller, Map<String, dynamic> sellerBook,
      String buyer, Map<String, dynamic> buyerBook
      );

  Future<dynamic> getTransactionFromKey(String transactionKey);

  //endregion

  //region Chat

  Future<dynamic> getMyChats();

  Future<dynamic> createNewChat(String userUid1, String userUid2, String userUid1Username, String userUid2Username);

  Future<List<Message>> addMessageToChat(String message, Chat chat, CustomUser userFromDb);

  //endregion

}