import 'package:malaz/core/constants/app_constants.dart';

import '../user/user_model.dart';

class ChatMessageModel {
  final int id;
  final int conversationId;
  final int senderId;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserModel? sender;

  String get senderImageUrl => AppConstants.userProfileImage(senderId);

  ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.body,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    return ChatMessageModel(
      id: safeInt(json['id']),
      senderId: safeInt(json['sender_id']),
      conversationId: safeInt(json['conversation_id']),
      body: json['body'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    );
  }

  ChatMessageModel copyWith({
    int? id,
    int? senderId,
    String? body,
    DateTime? createdAt,
    int? conversationId,
    DateTime? readAt,
    DateTime? updatedAt,
    UserModel? sender,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
      readAt: readAt ?? this.readAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sender: sender ?? this.sender,
    );
  }

  bool get isEdited {
    if (updatedAt == null) return false;
    return updatedAt!.isAfter(createdAt.add(const Duration(seconds: 1)));
  }
}