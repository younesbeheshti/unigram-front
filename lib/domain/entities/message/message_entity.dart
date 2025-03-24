class MessageRequest {
  final int chatId;
  final int senderId;
  final int receiverId;
  final String content;
  final String? pubChannel;

  MessageRequest({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.pubChannel,
  });

  factory MessageRequest.fromJson(Map<String, dynamic> json) {
    return MessageRequest(
      chatId: json['chatid'],
      senderId: json['senderid'],
      receiverId: json['receiverid'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatid': chatId,
      'senderid': senderId,
      'receiverid': receiverId,
      'content': content,
    };
  }
}
