import 'package:chat_app/data/sources/storage/secure_storage_service.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/data/ws/client.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {
  String? title;
  final int receiverId;

  ChatPage({super.key, this.title, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late WebSocketClient _client;
  late String userId;
  final TextEditingController _messageController = TextEditingController();
  final List<MessageRequest> _messages = [];

  @override
  void initState() {
    super.initState();
    init();
    _client = sl<WebSocketClient>();
    _client.onMessageReceived = (MessageRequest message) {
      setState(() {
        _messages.add(message);
      });
    };
    _client.connect();
  }

  void init() async {
    userId = await sl<SecureStorageService>().read(key: "userId");
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
        senderId: int.parse(userId),
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
                      bool isUser = _messages[index].senderId == int.parse(userId);
                      print("userid -> $userId");
                      print("senderid -> ${_messages[index].senderId}");
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
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
                    maxLines: null, // Allows dynamic line wrapping
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1000),
                    ],
                    onChanged: (text) {
                      List<String> lines = text.split('\n');
                      String formattedText = lines.map((line) {
                        return (line.length > 40) ? line.substring(0, 40) : line;
                      }).join('\n');

                      if (formattedText != text) {
                        _messageController.value = TextEditingValue(
                          text: formattedText,
                          selection: TextSelection.collapsed(offset: formattedText.length),
                        );
                      }
                    },
                    onSubmitted: (text) {
                      if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
                        return;
                      }
                      _sendMessage();
                    },
                    textInputAction: kIsWeb || (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS)
                        ? TextInputAction.none
                        : TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    onEditingComplete: () {},
                    focusNode: FocusNode()..onKeyEvent = (node, event) {
                      if (event is KeyDownEvent) {
                        if (event.logicalKey == LogicalKeyboardKey.enter) {
                          if (HardwareKeyboard.instance.isShiftPressed) {
                            return KeyEventResult.ignored;
                          } else {
                            _sendMessage();
                            return KeyEventResult.handled;
                          }
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
