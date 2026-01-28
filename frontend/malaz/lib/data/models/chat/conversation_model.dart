
import '../user/user_model.dart';

class ConversationModel {
  final int id;
  final int userOneId;
  final int userTwoId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int unreadCount;
  final UserModel? userOne;
  final UserModel? userTwo;

  ConversationModel({
    required this.id,
    required this.userOneId,
    required this.userTwoId,
    required this.createdAt,
    required this.updatedAt,
    required this.unreadCount,
    this.userOne,
    this.userTwo,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    return ConversationModel(
      id: safeInt(json['id']),
      userOneId: safeInt(json['user_one_id']),
      userTwoId: safeInt(json['user_two_id']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      unreadCount: safeInt(json['unread_count']),
      userOne: json['user_one'] != null
          ? UserModel.fromJson(json['user_one'] as Map<String, dynamic>)
          : null,
      userTwo: json['user_two'] != null
          ? UserModel.fromJson(json['user_two'] as Map<String, dynamic>)
          : null,
    );
  }

  ConversationModel copyWith({
    int? id,
    int? userOneId,
    int? userTwoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? unreadCount,
    UserModel? userOne,
    UserModel? userTwo,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      userOneId: userOneId ?? this.userOneId,
      userTwoId: userTwoId ?? this.userTwoId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
      userOne: userOne ?? this.userOne,
      userTwo: userTwo ?? this.userTwo,
    );
  }
}