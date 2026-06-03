import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';

class MessagingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const uuid = Uuid();

  // Send message
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    try {
      final messageId = uuid.v4();
      final timestamp = DateTime.now();

      // Create message
      final message = MessageModel(
        messageId: messageId,
        conversationId: conversationId,
        senderId: senderId,
        senderName: senderName,
        text: text,
        timestamp: timestamp,
      );

      // Save to Firestore
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
        'lastMessage': text,
        'lastMessageTime': timestamp.toIso8601String(),
        'lastSenderId': senderId,
        'updatedAt': timestamp.toIso8601String(),
      });
    } catch (e) {
      throw 'Erreur lors de l\'envoi: $e';
    }
  }

  // Get messages for conversation (Real-time)
  Stream<List<MessageModel>> getMessages(String conversationId) {
    try {
      return _firestore
          .collection('messages')
          .doc(conversationId)
          .collection('chats')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw 'Erreur lors de la récupération: $e';
    }
  }

  // Get all conversations
  Stream<List<ConversationModel>> getConversations(String userId) {
    try {
      return _firestore
          .collection('conversations')
          .where('participants', arrayContains: userId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ConversationModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw 'Erreur lors de la récupération: $e';
    }
  }

  // Create or get conversation
  Future<String> createOrGetConversation(
    String userId1,
    String userId2,
  ) async {
    try {
      // Sort IDs to create consistent conversation ID
      final ids = [userId1, userId2]..sort();
      final conversationId = '${ids[0]}_${ids[1]}';

      // Check if conversation exists
      final doc = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .get();

      if (!doc.exists) {
        // Create new conversation
        await _firestore
            .collection('conversations')
            .doc(conversationId)
            .set({
          'conversationId': conversationId,
          'participants': [userId1, userId2],
          'lastMessage': '',
          'lastMessageTime': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'lastSenderId': '',
        });
      }

      return conversationId;
    } catch (e) {
      throw 'Erreur lors de la création: $e';
    }
  }

  // Mark message as read
  Future<void> markMessageAsRead(
    String conversationId,
    String messageId,
  ) async {
    try {
      await _firestore
          .collection('messages')
          .doc(conversationId)
          .collection('chats')
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      throw 'Erreur: $e';
    }
  }

  // Delete message
  Future<void> deleteMessage(
    String conversationId,
    String messageId,
  ) async {
    try {
      await _firestore
          .collection('messages')
          .doc(conversationId)
          .collection('chats')
          .doc(messageId)
          .delete();
    } catch (e) {
      throw 'Erreur lors de la suppression: $e';
    }
  }
}
