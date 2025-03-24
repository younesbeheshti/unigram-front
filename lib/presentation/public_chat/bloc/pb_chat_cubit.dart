import 'package:chat_app/data/ws/client.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/presentation/public_chat/bloc/pb_chat_state.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PBChatCubit extends Cubit<PBChatState> {
  final WebSocketClient _client;
  final int senderId;

  PBChatCubit({required this.senderId})
      : _client = sl<WebSocketClient>(),
        super(PBChatInitial());

  void chatHistory() async {
    emit(PBChatInitial());

    try {
      List<MessageRequest> history = await sl<UserRepository>().getChatMessages(0);

      emit(PBChatLoaded(history));

      _client.onMessageReceived = (message) {
        _addMessage(message);
      };
      _client.connect();
    } catch (e) {
      emit(PBChatError("Failed to load chat history."));
    }
  }

  void _addMessage(MessageRequest message) {
    if (state is PBChatLoaded) {
      final messages = List<MessageRequest>.from((state as PBChatLoaded).messages);
      messages.add(message);
      emit(PBChatLoaded(messages));
    } else {
      emit(PBChatLoaded([message]));
    }
  }

  // void sendMessage(String content) {
  //   if (content.trim().isNotEmpty) {
  //     final message = MessageRequest(
  //       chatId: 0,
  //       senderId: senderId,
  //       content: content.trim(),
  //     );
  //
  //     _client.sendMessage(message);
  //     _addMessage(message);
  //   }
  // }


}
