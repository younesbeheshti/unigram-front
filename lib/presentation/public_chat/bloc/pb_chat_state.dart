import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PBChatState extends Equatable{
  const PBChatState();
  @override
  List<Object> get props => [];
}

class PBChatInitial extends PBChatState {}

class PBChatLoaded extends PBChatState {
  final List<MessageRequest> messages;

  const PBChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class PBChatError extends PBChatState {
  final String error;
  const PBChatError(this.error);
}