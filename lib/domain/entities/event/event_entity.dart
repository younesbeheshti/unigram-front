import 'package:chat_app/domain/entities/message/message_entity.dart';

class Event {
  final MessageRequest message;

  Event({required this.message});

  /// Convert JSON to Event object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      message: MessageRequest.fromJson(json['message']),
    );
  }

  /// Convert Event object to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message.toJson(),
    };
  }
}