class ChatMessage {
  final String? messageId;
  final String roomId;
  final int senderId;
  final String? senderNickName;
  final int? senderProfileImageId;
  final String message;
  final String messageType;
  final DateTime createdAt;

  ChatMessage({
    this.messageId,
    required this.roomId,
    required this.senderId,
    this.senderNickName,
    this.senderProfileImageId,
    required this.message,
    this.messageType = 'CHAT',
    required this.createdAt,
  });

  bool get isSystem => messageType == 'ENTER' || messageType == 'LEAVE';

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    messageId: json['messageId'],
    roomId: json['roomId'] ?? '',
    senderId: json['senderId'],
    senderNickName: json['senderNickName'],
    senderProfileImageId: json['senderProfileImageId'],
    message: json['message'],
    messageType: json['messageType'] ?? 'CHAT',
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
  );
}
