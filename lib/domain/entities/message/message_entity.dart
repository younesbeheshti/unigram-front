class MessageRequest {
  final String? messageType;
  final int? chatId;
  final int? senderId;
  final String? senderName;
  final int? receiverId;
  final String? content;
  final String? pubChannel;

  MessageRequest({
    this.messageType,
    this.chatId,
    this.senderId,
    this.senderName,
    this.receiverId,
    this.content,
    this.pubChannel,
  });

  factory MessageRequest.fromJson(Map<String, dynamic> json) {
    return MessageRequest(
      messageType: json['type'] ?? "",
      chatId: json['message']?['chatid'] ?? 0,
      senderName: json['message']?['sender_name'] ?? "System",
      senderId: json['message']?['senderid'],
      receiverId: json['message']?['receiverid'] ?? 0,
      content: json['message']?['content'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'type': messageType ?? "",
      'message': {
        'chatid': chatId ?? 0,
        'sender_name': senderName ?? "",
        'senderid': senderId,
        'receiverid': receiverId ?? 0,
        'content': content,
      }
    };
  }
}
