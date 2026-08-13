import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  // Initialize FCM
  static Future<void> initializeNotifications() async {
    try {
      // Request permission
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carryForward: true,
        critical: false,
        provisional: false,
        sound: true,
      );

      // Get FCM token
      final fCMToken = await _firebaseMessaging.getToken();
      print('FCM Token: $fCMToken');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Message received in foreground!');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
      });

      // Handle background message
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      print('Error initializing FCM: $e');
    }
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling background message: ${message.messageId}');
  }

  // Send notification
  static Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final notificationId = uuid.v4();
      final notification = NotificationModel(
        notificationId: notificationId,
        userId: userId,
        title: title,
        body: body,
        type: type,
        timestamp: DateTime.now(),
        metadata: metadata,
      );

      // Save to Firestore
      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .doc(notificationId)
          .set(notification.toJson());
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // Get notifications
  static Stream<List<NotificationModel>> getNotifications(String userId) {
    try {
      return _firestore
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => NotificationModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw 'Error getting notifications: $e';
    }
  }

  // Mark notification as read
  static Future<void> markNotificationAsRead(
    String userId,
    String notificationId,
  ) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Delete notification
  static Future<void> deleteNotification(
    String userId,
    String notificationId,
  ) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .doc(notificationId)
          .delete();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // Get FCM token
  static Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }
}
