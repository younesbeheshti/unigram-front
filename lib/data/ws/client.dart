import 'dart:convert';
import 'package:chat_app/core/configs/constants/app_url.dart';
import 'package:chat_app/core/configs/constants/message_type.dart';
import 'package:chat_app/data/sources/storage/secure_storage_service.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/html.dart';

class WebSocketClient {
  WebSocketChannel? _channel;
  bool isConnected = false;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;

  Function(MessageRequest)? onMessageReceived;
  Function()? onDisconnected;

  WebSocketClient();

  void connect() async {
    if (isConnected || _isConnecting) return;

    _isConnecting = true;

    try {
      final token = await sl<SecureStorageService>().read(key: "token");
      if (token == null || token.isEmpty) {
        print('No token available for WebSocket connection');
        _isConnecting = false;
        return;
      }

      final uri = Uri.parse("${AppUrls.WS_SOCKET}?token=$token");
      print('Connecting to WebSocket at: ${uri.toString()}');

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
      _isConnecting = false;
      _reconnectAttempts = 0;
      print('Connected to WebSocket');

      _channel!.stream.listen(
        (message) {
          print('Received raw: ${message}');

          try {
            // Handle both string and binary messages
            String decodedMsg;
            if (message is String) {
              decodedMsg = message;
            } else {
              decodedMsg = utf8.decode(message);
            }

            // Try to decode as base64 first
            try {
              final decodedBytes = base64Decode(decodedMsg);
              decodedMsg = utf8.decode(decodedBytes);
            } catch (e) {
              // Not base64 encoded, use as is
              print('Message is not base64 encoded, using as is');
            }

            final decodedMessage = jsonDecode(decodedMsg);
            print('Decoded message: $decodedMessage');

            if (decodedMessage is Map<String, dynamic> &&
                decodedMessage.containsKey('message')) {
              if (onMessageReceived != null) {
                // If this is a file message and contains fileData, ensure it's properly decoded
                if (decodedMessage['type'] == MessageType.FILE_MESSAGE &&
                    decodedMessage['message']['fileData'] != null) {
                  try {
                    final fileData =
                        base64Decode(decodedMessage['message']['fileData']);
                    decodedMessage['message']['fileData'] =
                        base64Encode(fileData);
                  } catch (e) {
                    print('Error decoding file data: $e');
                  }
                }

                onMessageReceived!(MessageRequest.fromJson(decodedMessage));
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
          _handleDisconnection();
        },
        onDone: () {
          print('WebSocket connection closed');
          _handleDisconnection();
        },
      );
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      _isConnecting = false;
      _handleDisconnection();
    }
  }

  void _handleDisconnection() {
    isConnected = false;
    _isConnecting = false;
    onDisconnected?.call();

    if (_reconnectAttempts < maxReconnectAttempts) {
      reconnect();
    } else {
      print('Max reconnection attempts reached. Please restart the app.');
    }
  }

  void sendMessage(MessageRequest message) {
    if (!isConnected || _channel == null) {
      print('Cannot send message, WebSocket is disconnected');
      return;
    }

    try {
      final jsonMessage = jsonEncode(message.toJson());
      print("Sending message: $jsonMessage");

      // Encode the JSON message to base64 before sending
      final base64Message = base64Encode(utf8.encode(jsonMessage));
      _channel!.sink.add(base64Message);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void disconnect() {
    print('Disconnecting from WebSocket...');
    isConnected = false;
    _isConnecting = false;
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
  }

  void reconnect() {
    if (!isConnected && !_isConnecting) {
      _reconnectAttempts++;
      print(
          'Attempting to reconnect (attempt $_reconnectAttempts of $maxReconnectAttempts)...');
      Future.delayed(Duration(seconds: 3), () {
        connect();
      });
    }
  }
}
