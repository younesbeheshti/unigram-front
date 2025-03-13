import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/presentation/chat/bloc/chat_cubit.dart';
import 'package:chat_app/service_locator.dart';
import 'package:chat_app/data/sources/storage/secure_storage_service.dart';

import '../bloc/chat_state.dart';

class ChatPage extends StatefulWidget {
  final String? title;
  final int receiverId;
  final int chatId;

  ChatPage(
      {super.key, this.title, required this.chatId, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late int senderId;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    senderId = int.parse(await sl<SecureStorageService>().read(key: "userId"));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return senderId == 0
        ? const Center(child: CircularProgressIndicator()) // Wait for senderId
        : BlocProvider(
            create: (context) {
              final cubit = ChatCubit(
                chatId: widget.chatId,
                receiverId: widget.receiverId,
                senderId: senderId,
              );
              cubit.loadChatHistory(); // Fetch messages when chat opens
              return cubit;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.title ?? "ChatPage"),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<ChatCubit, ChatState>(
                      builder: (context, state) {
                        if (state is ChatLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is ChatError) {
                          return Center(child: Text(state.error));
                        }
                        if (state is ChatLoaded) {
                          return state.messages.isEmpty
                              ? const Center(child: Text("No messages yet"))
                              : ListView.builder(
                                  reverse: false, // Messages appear in order
                                  itemCount: state.messages.length,
                                  itemBuilder: (context, index) {
                                    final message = state.messages[index];
                                    bool isUser = message.senderId == senderId;
                                    return Align(
                                      alignment: isUser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isUser
                                              ? Colors.blue
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          message.content,
                                          style: TextStyle(
                                            color: isUser
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                        }
                        return const Center(child: Text("No messages"));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context
                                .read<ChatCubit>()
                                .sendMessage(_messageController.text);
                            _messageController.clear();
                          },
                          icon: const Icon(Icons.send, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
