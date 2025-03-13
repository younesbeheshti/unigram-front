import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:chat_app/data/ws/client.dart';
import 'package:chat_app/service_locator.dart';
import 'package:equatable/equatable.dart';

// Chat States
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageRequest> messages;
  const ChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String error;
  const ChatError(this.error);
}

