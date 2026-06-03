import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  // Upload image to storage
  static Future<String> uploadImage(
    String conversationId,
    String userId,
    String filePath,
  ) async {
    try {
      final fileName = uuid.v4();
      final ref = _storage.ref().child('messages/$conversationId/$fileName');

      await ref.putFile(File(filePath));
      final url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      throw 'Erreur lors de l\'upload: $e';
    }
  }

  // Send image message
  static Future<void> sendImageMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String imageUrl,
  }) async {
    try {
      final messageId = uuid.v4();
      final timestamp = DateTime.now();

      final message = MessageModel(
        messageId: messageId,
        conversationId: conversationId,
        senderId: senderId,
        senderName: senderName,
        text: '[Image]',
        timestamp: timestamp,
        imageUrl: imageUrl,
      );

      await _firestore
          .collection('messages')
          .doc(conversationId)
          .collection('chats')
          .doc(messageId)
          .set(message.toJson());

      // Update conversation
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .update({
        'lastMessage': '[Image]',
        'lastMessageTime': timestamp.toIso8601String(),
        'lastSenderId': senderId,
        'updatedAt': timestamp.toIso8601String(),
      });
    } catch (e) {
      throw 'Erreur lors de l\'envoi d\'image: $e';
    }
  }

  // Delete image
  static Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw 'Erreur lors de la suppression: $e';
    }
  }

  // Upload user avatar
  static Future<String> uploadUserAvatar(
    String userId,
    String filePath,
  ) async {
    try {
      final ref = _storage.ref().child('avatars/$userId');
      await ref.putFile(File(filePath));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw 'Erreur lors de l\'upload: $e';
    }
  }
}

import 'dart:io';
