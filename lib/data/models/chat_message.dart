class ChatMessage {
  String? from;
  String? to;
  DateTime? createdAt;
  bool hasRead;
  String senderKey;
  String message;
  String recieverKey;
  String messageType;

  ChatMessage({
    this.from = '',
    this.to = '',
    this.createdAt,
    this.hasRead = false,
    required this.senderKey,
    required this.message,
    required this.recieverKey,
    required this.messageType,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      from: json['from'] as String?,
      to: json['to'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      hasRead: json['hasRead'] as bool? ?? false,
      senderKey: json['senderKey'] as String,
      message: json['message'] as String,
      recieverKey: json['recieverKey'] as String,
      messageType: json['messageType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'hasRead': hasRead,
      'senderKey': senderKey,
      'message': message,
      'recieverKey': recieverKey,
      'messageType': messageType,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? from,
    String? to,
    DateTime? createdAt,
    bool? hasRead,
    List<String>? receiverList,
    bool? onlineStatus,
    String? senderKey,
    String? message,
    String? recieverKey,
    String? messageType,
  }) {
    return ChatMessage(
      from: from ?? this.from,
      to: to ?? this.to,
      createdAt: createdAt ?? this.createdAt,
      hasRead: hasRead ?? this.hasRead,
      senderKey: senderKey ?? this.senderKey,
      message: message ?? this.message,
      recieverKey: recieverKey ?? this.recieverKey,
      messageType: messageType ?? this.messageType,
    );
  }
}