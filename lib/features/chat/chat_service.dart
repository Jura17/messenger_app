// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:messenger_app/features/chat/data/models/message.dart';
// import 'package:rxdart/rxdart.dart';

// class ChatService extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Stream<List<Map<String, dynamic>>> getUsersStream() {
//     // go through all users and return the user object
//     return _firestore.collection('users').snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final user = doc.data();
//         return user;
//       }).toList();
//     });
//   }

//   Stream<List<Map<String, dynamic>>> getPermittedUsers() {
//     final currentUser = _auth.currentUser;

//     // Stream of blocked user IDs
//     final blockedUsersStream = _firestore
//         .collection('users')
//         .doc(currentUser!.uid)
//         .collection('blockedUsers')
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

//     // Combine blocked users with all users
//     return blockedUsersStream.asyncExpand((blockedUserIds) {
//       return _firestore.collection('users').snapshots().asyncExpand((allUsersSnapshot) {
//         // For each permitted user, listen to their unread messages
//         final streams = allUsersSnapshot.docs
//             .where((doc) => doc.data()['email'] != currentUser.email && !blockedUserIds.contains(doc.id))
//             .map((doc) {
//           final userData = doc.data();
//           final chatRoomId = [currentUser.uid, doc.id]..sort();

//           // live unread count per user
//           final unreadStream = _firestore
//               .collection('chatrooms')
//               .doc(chatRoomId.join('_'))
//               .collection('messages')
//               .where('receiverID', isEqualTo: currentUser.uid)
//               .where('isRead', isEqualTo: false)
//               .snapshots()
//               .map((unreadSnap) {
//             return {
//               ...userData,
//               'unreadCount': unreadSnap.docs.length,
//             };
//           });

//           return unreadStream;
//         }).toList();

//         // Merge all unread streams into one combined list
//         return Rx.combineLatestList(streams);
//       });
//     });
//   }

//   Future<void> sendMessage(String receiverID, message) async {
//     final String currentUserID = _auth.currentUser!.uid;
//     final String currentUserEmail = _auth.currentUser!.email!;
//     final Timestamp timestamp = Timestamp.now();

//     // create a new message
//     Message newMessage = Message(
//       senderId: currentUserID,
//       senderEmail: currentUserEmail,
//       receiverId: receiverID,
//       message: message,
//       timestamp: timestamp,
//     );

//     // construct chat room ID for the two users (sorted to ensure uniqueness)
//     List<String> userIDs = [currentUserID, receiverID];
//     // sort the IDs to ensure the chatroom ID is the same for any 2 people
//     userIDs.sort();
//     final String chatroomID = userIDs.join('_');

//     // add new message to database
//     await _firestore.collection('chatrooms').doc(chatroomID).collection('messages').add(newMessage.toMap());
//   }

//   Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
//     // construct a chatroom ID for the two users

//     List<String> userIDs = [userID, otherUserID];
//     userIDs.sort();
//     final String chatroomID = userIDs.join('_');

//     return _firestore
//         .collection('chatrooms')
//         .doc(chatroomID)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots();
//   }

//   Future<void> markMessagesAsRead(String receiverId) async {
//     final currentUserId = _auth.currentUser!.uid;

//     List<String> ids = [currentUserId, receiverId];
//     ids.sort();
//     String chatRoomId = ids.join('_');

//     final unreadMessagesQuery = _firestore
//         .collection('chatrooms')
//         .doc(chatRoomId)
//         .collection('messages')
//         .where('receiverID', isEqualTo: currentUserId)
//         .where('isRead', isEqualTo: false);

//     final unreadMessagesSnapshot = await unreadMessagesQuery.get();

//     for (var message in unreadMessagesSnapshot.docs) {
//       await message.reference.update({'isRead': true});
//     }
//   }

//   Future<void> reportMessage(String messageId, String userId) async {
//     final currentUser = _auth.currentUser;
//     final report = {
//       'reportedBy': currentUser!.uid,
//       'messageId': messageId,
//       'messageOwnerId': userId,
//       'timestamp': FieldValue.serverTimestamp()
//     };

//     await _firestore.collection('reports').add(report);
//   }

//   Future<void> blockUser(String userId) async {
//     final currentUser = _auth.currentUser;
//     await _firestore.collection('users').doc(currentUser!.uid).collection('blockedUsers').doc(userId).set({});
//     // notifyListeners();
//   }

//   Future<void> unblockUser(String blockedUserId) async {
//     final currentUser = _auth.currentUser;
//     await _firestore.collection('users').doc(currentUser!.uid).collection('blockedUsers').doc(blockedUserId).delete();
//   }

//   Stream<List<Map<String, dynamic>>> getBlockedUsers(String userId) {
//     // TODO: Just retrieve and use currentUser ID here like in the other functions?
//     return _firestore.collection('users').doc(userId).collection('blockedUsers').snapshots().asyncMap((snapshot) async {
//       // get IDs of blocked users
//       final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
//       // use IDs to retrieve all blocked users
//       final userDocs = await Future.wait(blockedUserIds.map((id) => _firestore.collection('users').doc(id).get()));
//       // return all blocked users as a list
//       return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//     });
//   }
// }
