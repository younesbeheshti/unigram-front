import 'package:chat_app/data/sources/storage/secure_storage_service.dart';
import 'package:chat_app/data/ws/client.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PublicChatPage extends StatefulWidget {
  PublicChatPage({super.key});

  @override
  State<PublicChatPage> createState() => _PublicChatPageState();
}

class _PublicChatPageState extends State<PublicChatPage> {
  WebSocketClient _client = sl<WebSocketClient>();
  final TextEditingController _messageController = TextEditingController();
  List<MessageRequest> _messages = [];
  late int userId;
  late String username;

  @override
  void initState() {
    init();
    super.initState();
    _client.onMessageReceived = (MessageRequest message) {
      if (message.chatId == 0) {
        setState(() {
          _messages.add(message);
        });
      }
    };
    _client.connect();
  }

  void init() async {
    userId = int.parse(await sl<SecureStorageService>().read(key: "userId"));
    username = await sl<SecureStorageService>().read(key: "username");
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final message = MessageRequest(
        chatId: 0,
        senderName: username,
        senderId: userId,
        receiverId: 0,
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
        title: Text("Public Chat"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text("No message yet..."),
                  )
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      bool isUser = _messages[index].senderId == userId;
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue : Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isUser
                                    ? username
                                    : _messages[index].senderName!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isUser
                                      ? Colors.grey[300]
                                      : Colors.grey[800],
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                _messages[index].content,
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
                    // Allows dynamic line wrapping
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
                        return (line.length > 40)
                            ? line.substring(0, 40)
                            : line;
                      }).join('\n');

                      if (formattedText != text) {
                        _messageController.value = TextEditingValue(
                          text: formattedText,
                          selection: TextSelection.collapsed(
                              offset: formattedText.length),
                        );
                      }
                    },
                    onSubmitted: (text) {
                      if (!kIsWeb &&
                          (defaultTargetPlatform == TargetPlatform.android ||
                              defaultTargetPlatform == TargetPlatform.iOS)) {
                        return;
                      }
                      _sendMessage();
                    },
                    textInputAction: kIsWeb ||
                            (defaultTargetPlatform == TargetPlatform.windows ||
                                defaultTargetPlatform == TargetPlatform.linux ||
                                defaultTargetPlatform == TargetPlatform.macOS)
                        ? TextInputAction.none
                        : TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    onEditingComplete: () {},
                    focusNode: FocusNode()
                      ..onKeyEvent = (node, event) {
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
