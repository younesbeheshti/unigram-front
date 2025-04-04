import 'package:chat_app/core/configs/constants/message_type.dart';
import 'package:chat_app/data/sources/storage/secure_storage_service.dart';
import 'package:chat_app/data/ws/client.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:chat_app/presentation/public_chat/page/online_users.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupWebSocket();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _setupWebSocket() {
    _client.onMessageReceived = (MessageRequest message) {
      if (message.chatId == 0) {
        setState(() {
          _messages.add(message);
        });
      }
    };

    _client.onDisconnected = () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection lost. Attempting to reconnect...'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    };

    _client.connect();
  }

  Future<void> _loadUserInfo() async {
    try {
      userId = int.parse(await sl<SecureStorageService>().read(key: "userId"));
      username = await sl<SecureStorageService>().read(key: "username");

      final joinMessage = MessageRequest(
        messageType: MessageType.JOIN,
        senderName: username,
        senderId: userId,
      );
      _client.sendMessage(joinMessage);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user info: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final message = MessageRequest(
      messageType: MessageType.PUBLIC_MESSAGE,
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

  Future<void> _pickAndSendFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        Uint8List? fileBytes = file.bytes;
        String? fileName = file.name;
        String? fileType = file.extension;

        if (fileBytes != null && fileName != null) {
          final message = MessageRequest(
            messageType: MessageType.FILE_MESSAGE,
            senderName: username,
            senderId: userId,
            content: "Sent a file: $fileName",
            fileData: fileBytes,
            fileName: fileName,
            fileType: fileType,
          );

          _client.sendMessage(message);
          setState(() {
            _messages.add(message);
          });
        }
      }
    } catch (e) {
      print("Error picking file: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending file: $e')),
        );
      }
    }
  }

  Future<void> _downloadAndOpenFile(MessageRequest message) async {
    if (message.fileData == null || message.fileName == null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${message.fileName}';
      final file = File(filePath);

      await file.writeAsBytes(message.fileData!);

      if (!mounted) return;

      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening file: ${result.message}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: $e')),
      );
    }
  }

  Widget _buildMessageContent(MessageRequest message) {
    if (message.messageType == MessageType.FILE_MESSAGE &&
        message.fileData != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content ?? "",
            style: TextStyle(
              color: message.senderId == userId ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _downloadAndOpenFile(message),
            icon: const Icon(Icons.attach_file),
            label: Text(message.fileName ?? "File"),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  message.senderId == userId ? Colors.white : Colors.blue,
              foregroundColor:
                  message.senderId == userId ? Colors.blue : Colors.white,
            ),
          ),
        ],
      );
    }

    return Text(
      message.content ?? "",
      style: TextStyle(
        color: message.senderId == userId ? Colors.white : Colors.black,
      ),
    );
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
        leading: IconButton(
          onPressed: _leaveChat,
          icon: const Icon(Icons.arrow_back),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OnlineUsers(),
              ),
            );
          },
          child: const Text("Public Chat"),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _client.disconnect();
              _client.connect();
            },
            tooltip: 'Reconnect',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? const Center(child: Text("No messages yet..."))
                      : ListView.builder(
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            final isUser = message.senderId == userId;

                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      isUser ? Colors.blue : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isUser
                                          ? username
                                          : message.senderName ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isUser
                                            ? Colors.grey[300]
                                            : Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    _buildMessageContent(message),
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
                      IconButton(
                        onPressed: _pickAndSendFile,
                        icon: const Icon(Icons.attach_file),
                        color: Colors.blue,
                      ),
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
                              if (event is KeyDownEvent &&
                                  event.logicalKey ==
                                      LogicalKeyboardKey.enter) {
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
