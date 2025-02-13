import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/html.dart';

class WebSocketClient {
  late WebSocketChannel _channel;
  final String serverUrl;
  Function(String)? onMessageReceived;

  WebSocketClient(this.serverUrl, {this.onMessageReceived});

  void connect() {
    if (kIsWeb) {
      _channel = HtmlWebSocketChannel.connect(serverUrl);
    } else {
      _channel = IOWebSocketChannel.connect(Uri.parse(serverUrl));
    }

    _channel.stream.listen(
          (message) {
        print('Received raw: $message'); // Debugging

        try {
          final decodedMessage = jsonDecode(message);

          if (decodedMessage is Map<String, dynamic>) {
            if (decodedMessage.containsKey('message')) {
              var extractedMessage = decodedMessage['message'];

              // Ensure the extracted message is a string
              if (extractedMessage is! String) {
                extractedMessage = extractedMessage.toString(); // Convert to string if needed
              }

              print('Extracted Message: $extractedMessage'); // Debugging

              if (onMessageReceived != null) {
                onMessageReceived!(extractedMessage);
              }
            } else {
              print('Warning: Key "message" not found in received data');
            }
          } else {
            print('Warning: Received data is not a valid JSON object');
          }
        } catch (e) {
          print('Error decoding message: $e');
        }
      },
      onError: (error) {
        print('Error: $error');
      },
      onDone: () {
        print('Connection closed');
      },
    );

  }

  void sendMessage(String message) {
    if (_channel.closeCode == null) {
      _channel.sink.add(jsonEncode({'message': message}));
    } else {
      print('Connection is closed');
    }
  }

  void disconnect() {
    _channel.sink.close();
  }
}
