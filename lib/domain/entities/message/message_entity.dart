import 'dart:typed_data';
import 'dart:convert';

class MessageRequest {
  final String? messageType;
  final int? chatId;
  final int? senderId;
  final String? senderName;
  final int? receiverId;
  final String? content;
  final Uint8List? fileData;
  final String? fileName;
  final String? fileType;

  MessageRequest({
    this.messageType,
    this.chatId,
    this.senderId,
    this.senderName,
    this.receiverId,
    this.content,
    this.fileData,
    this.fileName,
    this.fileType,
  });

  factory MessageRequest.fromJson(Map<String, dynamic> json) {
    return MessageRequest(
      messageType: json['type'] ?? "",
      chatId: json['message']?['chatid'] ?? 0,
      senderName: json['message']?['sender_name'] ?? "System",
      senderId: json['message']?['senderid'],
      receiverId: json['message']?['receiverid'] ?? 0,
      content: json['message']?['content'],
      fileData: json['message']?['fileData'] != null
          ? base64Decode(json['message']['fileData'])
          : null,
      fileName: json['message']?['fileName'],
      fileType: json['message']?['fileType'],
    );
  }

  factory MessageRequest.fromJsonChat(Map<String, dynamic> json) {
    return MessageRequest(
      chatId: json['chatid'] ?? 0,
      senderName: json['sender_name'] ?? "System",
      senderId: json['senderid'],
      receiverId: json['receiverid'] ?? 0,
      content: json['content'],
      fileData:
          json['fileData'] != null ? base64Decode(json['fileData']) : null,
      fileName: json['fileName'],
      fileType: json['fileType'],
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
        'fileData': fileData != null ? base64Encode(fileData!) : null,
        'fileName': fileName,
        'fileType': fileType,
      }
    };
  }
}
