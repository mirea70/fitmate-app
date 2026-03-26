class NoticeResponse {
  final int id;
  final int matingId;
  final String content;

  NoticeResponse({
    required this.id,
    required this.matingId,
    required this.content,
  });

  factory NoticeResponse.fromJson(Map<String, dynamic> json) => NoticeResponse(
    id: json['id'],
    matingId: json['matingId'],
    content: json['content'],
  );
}
