import 'dart:convert';
import 'dart:js_interop';
import 'package:chat_app/core/configs/constants/app_url.dart';
import 'package:chat_app/data/sources/storage/secure_storage_service.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/html.dart';

class WebSocketClient {
  late WebSocketChannel _channel;
  bool isConnected = false;

  Function(MessageRequest)? onMessageReceived; // Callback set later
  Function()? onDisconnected;

  WebSocketClient(); // Constructor is now empty

  void connect() async {
    try {
      final token = await sl<SecureStorageService>().read(key: "token");

      final uri = Uri.parse("${AppUrls.WS_SOCKET}?token=$token");

      if (kIsWeb) {
        _channel = HtmlWebSocketChannel.connect(uri.toString());
      } else {
        _channel = IOWebSocketChannel.connect(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
      }

      isConnected = true;
      print('Connected to WebSocket');

      _channel.stream.listen(
        (message) {
          print('Received raw: ${message}');

          //TODO : message type has to be a MessageRequest
          try {
            final decodedMessage = jsonDecode(message);

            if (decodedMessage is Map<String, dynamic> &&
                decodedMessage.containsKey('message')) {
              var extractedMessage = decodedMessage['message'];

              if (extractedMessage is! String) {
                extractedMessage = extractedMessage.toString();
              }

              print('Extracted Message: $extractedMessage');

              if (onMessageReceived != null) {
                onMessageReceived!(
                    MessageRequest.fromJson(decodedMessage['message']));
              }
            } else {
              print('Warning: Invalid message format');
            }
          } catch (e) {
            print('Error decoding message: $e');
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          reconnect();
        },
        onDone: () {
          print('WebSocket connection closed');
          isConnected = false;
          onDisconnected?.call();
          reconnect();
        },
      );
    } catch (e) {
      print('Error connecting to WebSocket: $e');
    }
  }

  void sendMessage(MessageRequest message) {
    if (isConnected) {
      _channel.sink.add(jsonEncode({"message": message.toJson()}));

      print("message: ${message.toJson()}");
    } else {
      print('Cannot send message, WebSocket is disconnected');
    }
  }

  void disconnect() {
    print('Disconnecting from WebSocket...');
    isConnected = false;
    _channel.sink.close();
  }

  void reconnect() {
    if (!isConnected) {
      print('Attempting to reconnect...');
      Future.delayed(Duration(seconds: 3), () {
        connect();
      });
    }
  }
}
