class MessageRequest {
  final int? chatId;
  final int senderId;
  final String? senderName;
  final int? receiverId;
  final String content;
  final String? pubChannel;

  MessageRequest({
    this.chatId,
    required this.senderId,
    this.senderName,
    this.receiverId,
    required this.content,
    this.pubChannel,
  });

  factory MessageRequest.fromJson(Map<String, dynamic> json) {
    return MessageRequest(
      chatId: json['chatid'] ?? 0,
      senderName: json['sender_name'] ?? "",
      senderId: json['senderid'],
      receiverId: json['receiverid'] ?? 0,
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatid': chatId ?? 0,
      'sender_name': senderName ?? "",
      'senderid': senderId,
      'receiverid': receiverId ?? 0,
      'content': content,
    };
  }
}
