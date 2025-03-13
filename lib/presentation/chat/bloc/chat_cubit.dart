
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/ws/client.dart';
import '../../../domain/entities/message/message_entity.dart';
import '../../../service_locator.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final WebSocketClient _client;
  final int chatId;
  final int receiverId;
  final int senderId;

  ChatCubit({required this.chatId, required this.receiverId, required this.senderId})
      : _client = sl<WebSocketClient>(),
        super(ChatInitial());

  void loadChatHistory() async {
    emit(ChatLoading());

    try {
      List<MessageRequest> history = await sl<UserRepository>().getChatMessages(chatId);

      emit(ChatLoaded(history));

      _client.onMessageReceived = (message) {
        _addMessage(message);
      };
      _client.connect();
    } catch (e) {
      emit(ChatError("Failed to load chat history."));
    }
  }

  void _addMessage(MessageRequest message) {
    if (state is ChatLoaded) {
      final messages = List<MessageRequest>.from((state as ChatLoaded).messages);
      messages.add(message);
      emit(ChatLoaded(messages));
    } else {
      emit(ChatLoaded([message]));
    }
  }

  void sendMessage(String content) {
    if (content.trim().isNotEmpty) {
      final message = MessageRequest(
        chatId: receiverId,
        senderId: senderId,
        receiverId: receiverId,
        content: content.trim(),
      );

      _client.sendMessage(message);
      _addMessage(message);
    }
  }
}
