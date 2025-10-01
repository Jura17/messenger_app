import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _messageStreamController = BehaviorSubject<RemoteMessage>();

  Future<void> requestPersmission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("User granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint("User granted provisional permission");
    } else {
      debugPrint("User declined or has not accepted permission");
    }
  }

  void setupInteractions() {
    FirebaseMessaging.onMessage.listen((event) {
      debugPrint("Got a message whilst in the foreground");
      debugPrint("Message data: ${event.data}");

      _messageStreamController.sink.add(event);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint("Message clicked");
    });
  }

  void dispose() {
    _messageStreamController.close();
  }

  // what kind of physical device are we sending the notification to?
  void setupTokenListeners() {
    FirebaseMessaging.instance.getToken().then((token) {
      saveTokenToDatabase(token);
    });
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  void saveTokenToDatabase(String? token) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    // if the current user is logged in and there is a device token save it to the db
    if (userId != null && token != null) {
      FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }

  // in case user logs out we don't want to keep sending notifications to that device
  Future<void> clearTokenOnLogout(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });
      debugPrint("Token cleared!");
    } catch (e) {
      debugPrint("Failed to clear token: $e");
    }
  }
}
