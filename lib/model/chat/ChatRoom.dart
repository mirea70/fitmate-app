class ChatRoom {
  final String roomId;
  final String roomName;
  final String roomType;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final List<int> memberAccountIds;
  final int unreadCount;

  ChatRoom({
    required this.roomId,
    required this.roomName,
    required this.roomType,
    this.lastMessage,
    this.lastMessageAt,
    required this.memberAccountIds,
    this.unreadCount = 0,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
    roomId: json['roomId'],
    roomName: json['roomName'] ?? '',
    roomType: json['roomType'] ?? 'GROUP',
    lastMessage: json['lastMessage'],
    lastMessageAt: json['lastMessageTime'] != null
        ? DateTime.parse(json['lastMessageTime'])
        : null,
    memberAccountIds: json['memberAccountIds'] != null
        ? List<int>.from(json['memberAccountIds'])
        : [],
    unreadCount: json['unreadCount'] ?? 0,
  );
}
