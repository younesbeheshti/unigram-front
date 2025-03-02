import 'package:chat_app/data/sources/storage/secure_storage_service.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/data/ws/client.dart';
import 'package:chat_app/service_locator.dart';


class ChatPage extends StatefulWidget {
  String? title;
  final int receiverId;
  ChatPage({super.key,this.title, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late WebSocketClient _client;
  late int userId;
  final TextEditingController _messageController = TextEditingController();
  final List<MessageRequest> _messages = [];

  @override
  void initState() async {
    super.initState();
    userId = await sl<SecureStorageService>().read(key: "userId");
    _client = sl<WebSocketClient>();
    _client.onMessageReceived = (MessageRequest message) {
      setState(() {
        _messages.add(message);
      });
    };
    _client.connect();
  }

  @override
  void dispose() {
    _client.disconnect();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final message = MessageRequest(
        chatId: widget.receiverId,
        senderId: userId,
        receiverId: widget.receiverId,
        content: _messageController.text.trim(),
      );
      _client.sendMessage(message);
      setState(() {
        _messages.add(message);
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "ChatPage"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text("No messages yet"))
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUser = _messages[index].senderId == 101; // Adjust sender ID dynamically
                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _messages[index].content,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
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
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
