import 'dart:convert';

import 'package:fitmate_app/config/AppConfig.dart';
import 'package:fitmate_app/config/Const.dart';
import 'package:fitmate_app/config/SecureStorage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

final stompServiceProvider = Provider<StompService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return StompService(ref, storage);
});

class StompService {
  final Ref ref;
  final dynamic storage;
  StompClient? _client;
  bool _isConnected = false;

  StompService(this.ref, this.storage);

  bool get isConnected => _isConnected;

  Future<void> connect({
    required Function() onConnected,
    required Function(String) onError,
  }) async {
    if (_isConnected && _client != null) {
      onConnected();
      return;
    }

    final token = await storage.read(key: accessTokenKey);
    if (token == null) {
      onError('인증 토큰이 없습니다.');
      return;
    }

    final wsUrl = AppConfig().baseUrl + '/stomp';

    _client = StompClient(
      config: StompConfig.sockJS(
        url: wsUrl,
        stompConnectHeaders: {
          'Authorization': token,
        },
        webSocketConnectHeaders: {
          'Authorization': token,
        },
        onConnect: (StompFrame frame) {
          _isConnected = true;
          onConnected();
        },
        onWebSocketError: (error) {
          _isConnected = false;
          onError('WebSocket 연결 실패: $error');
        },
        onStompError: (StompFrame frame) {
          _isConnected = false;
          onError('STOMP 에러: ${frame.body}');
        },
        onDisconnect: (StompFrame frame) {
          _isConnected = false;
        },
        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    _client!.activate();
  }

  StompUnsubscribe? subscribe({
    required String roomId,
    required Function(Map<String, dynamic>) onMessage,
  }) {
    if (_client == null || !_isConnected) return null;

    return _client!.subscribe(
      destination: '/sub/$roomId',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          onMessage(data);
        }
      },
    );
  }

  void sendMessage({
    required String roomId,
    required String message,
  }) {
    if (_client == null || !_isConnected) return;

    _client!.send(
      destination: '/pub/$roomId',
      body: jsonEncode({'message': message}),
    );
  }

  void disconnect() {
    _client?.deactivate();
    _isConnected = false;
    _client = null;
  }
}
