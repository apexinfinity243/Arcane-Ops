class ConversationModel {
  final String conversationId;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final DateTime updatedAt;
  final String lastSenderId;

  ConversationModel({
    required this.conversationId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.updatedAt,
    required this.lastSenderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSenderId': lastSenderId,
    };
  }

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json['conversationId'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      lastSenderId: json['lastSenderId'] ?? '',
    );
  }
}
