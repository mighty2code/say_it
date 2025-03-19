class ChatMessage {
  String? id;
  String? from;
  String? to;
  int createdAt;
  bool hasRead;
  List<String>? receiverList;
  bool? onlineStatus;
  String senderKey;
  String message;
  String recieverKey;
  String messageType;

  ChatMessage({
    this.id,
    this.from = '',
    this.to = '',
    int? createdAt,
    this.hasRead = false,
    this.receiverList,
    this.onlineStatus,
    required this.senderKey,
    required this.message,
    required this.recieverKey,
    required this.messageType,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String?,
      from: json['from'] as String?,
      to: json['to'] as String?,
      createdAt: json['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      hasRead: json['hasRead'] as bool? ?? false,
      receiverList: (json['receiverList'] as List<dynamic>?)?.cast<String>(),
      onlineStatus: json['onlineStatus'] as bool?,
      senderKey: json['senderKey'] as String,
      message: json['message'] as String,
      recieverKey: json['recieverKey'] as String,
      messageType: json['messageType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'createdAt': createdAt,
      'hasRead': hasRead,
      'receiverList': receiverList,
      'onlineStatus': onlineStatus,
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
    int? createdAt,
    bool? hasRead,
    List<String>? receiverList,
    bool? onlineStatus,
    String? senderKey,
    String? message,
    String? recieverKey,
    String? messageType,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      createdAt: createdAt ?? this.createdAt,
      hasRead: hasRead ?? this.hasRead,
      receiverList: receiverList ?? this.receiverList,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      senderKey: senderKey ?? this.senderKey,
      message: message ?? this.message,
      recieverKey: recieverKey ?? this.recieverKey,
      messageType: messageType ?? this.messageType,
    );
  }
}