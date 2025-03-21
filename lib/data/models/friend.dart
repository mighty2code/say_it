import 'dart:convert';

class Friend {
  String? id;
  String? name;
  String? username;
  String? email;
  String? conversationId;
  String? friendRequestStatus;
  int unreadCount;

  Friend({
    this.id,
    this.name,
    this.username,
    this.email,
    this.conversationId,
    this.friendRequestStatus,
    this.unreadCount = 0
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      friendRequestStatus: json['request_status']?.toString() ?? '',
      unreadCount: json['unread_count'] ?? 0,
    );
  }

  factory Friend.fromRawJson(String rawJson) => Friend.fromJson(jsonDecode(rawJson));

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'conversation_id': conversationId,
      'request_status': friendRequestStatus,
      'unread_count': unreadCount,
    };
  }
}