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
  Function()? _onConnectedCallback;
  Function(String)? _onErrorCallback;

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

    _onConnectedCallback = onConnected;
    _onErrorCallback = onError;

    final token = await storage.read(key: accessTokenKey);
    if (token == null) {
      onError('인증 토큰이 없습니다.');
      return;
    }

    _activate(token);
  }

  void _activate(String token) {
    _client?.deactivate();

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
          _onConnectedCallback?.call();
        },
        onWebSocketError: (error) {
          _isConnected = false;
          _reconnectWithFreshToken();
        },
        onStompError: (StompFrame frame) {
          _isConnected = false;
          _reconnectWithFreshToken();
        },
        onDisconnect: (StompFrame frame) {
          _isConnected = false;
        },
        reconnectDelay: Duration.zero,
      ),
    );

    _client!.activate();
  }

  Future<void> _reconnectWithFreshToken() async {
    await Future.delayed(const Duration(seconds: 5));
    final token = await storage.read(key: accessTokenKey);
    if (token == null) {
      _onErrorCallback?.call('인증 토큰이 없습니다.');
      return;
    }
    _activate(token);
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

  void enterRoom({required String roomId, String message = ''}) {
    if (_client == null || !_isConnected) return;

    _client!.send(
      destination: '/pub/$roomId/enter',
      body: jsonEncode({'message': message}),
    );
  }

  void sendMessage({
    required String roomId,
    required String message,
  }) {
    if (_client == null || !_isConnected) return;

    _client!.send(
      destination: '/pub/$roomId/chat',
      body: jsonEncode({'message': message}),
    );
  }

  void disconnect() {
    _client?.deactivate();
    _isConnected = false;
    _client = null;
    _onConnectedCallback = null;
    _onErrorCallback = null;
  }
}
