import 'package:chat_app/core/configs/constants/message_type.dart';
import 'package:chat_app/data/sources/storage/secure_storage_service.dart';
import 'package:chat_app/data/ws/client.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PublicChatPage extends StatefulWidget {
  const PublicChatPage({super.key});

  @override
  State<PublicChatPage> createState() => _PublicChatPageState();
}

class _PublicChatPageState extends State<PublicChatPage> {
  final WebSocketClient _client = sl<WebSocketClient>();
  final TextEditingController _messageController = TextEditingController();
  final List<MessageRequest> _messages = [];
  late int userId;
  late String username;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    userId = int.parse(await sl<SecureStorageService>().read(key: "userId"));
    username = await sl<SecureStorageService>().read(key: "username");

    _client.onMessageReceived = (MessageRequest message) {
      if (message.chatId == 0) {
        setState(() {
          _messages.add(message);
        });
      }
    };

    _client.connect();

    final joinMessage = MessageRequest(
      messageType: MessageType.JOIN,
      senderName: username,
      senderId: userId,
    );
    _client.sendMessage(joinMessage);
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final message = MessageRequest(
      messageType: MessageType.SEND_MESSAGE,
      senderName: username,
      senderId: userId,
      content: messageText,
    );

    _client.sendMessage(message);
    setState(() {
      _messages.add(message);
    });
    _messageController.clear();
  }

  void _leaveChat() {
    final leaveMessage = MessageRequest(
      messageType: MessageType.LEAVE,
      senderId: userId,
      senderName: username,
    );
    _client.sendMessage(leaveMessage);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: _leaveChat, icon: const Icon(Icons.arrow_back)),
        title: const Text("Public Chat"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text("No messages yet..."))
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.senderId == userId;

                if (message.messageType == MessageType.SERVER_MESSAGE) {
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message.content!,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  );
                }

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUser ? username : message.senderName ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 12,
                            color: isUser ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          message.content ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1000),
                    ],
                    onSubmitted: (_) => _sendMessage(),
                    keyboardType: TextInputType.multiline,
                    focusNode: FocusNode()
                      ..onKeyEvent = (node, event) {
                        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                          if (HardwareKeyboard.instance.isShiftPressed) {
                            return KeyEventResult.ignored;
                          } else {
                            _sendMessage();
                            return KeyEventResult.handled;
                          }
                        }
                        return KeyEventResult.ignored;
                      },
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
