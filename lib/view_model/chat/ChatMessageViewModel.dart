import 'dart:async';

import 'package:fitmate_app/config/StompService.dart';
import 'package:fitmate_app/model/chat/ChatMessage.dart';
import 'package:fitmate_app/repository/chat/ChatRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

final chatMessagesProvider = AsyncNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>(
    () => ChatMessagesNotifier());

final currentRoomIdProvider = NotifierProvider<CurrentRoomIdNotifier, String>(
    () => CurrentRoomIdNotifier());

class CurrentRoomIdNotifier extends Notifier<String> {
  @override
  String build() => '';

  void set(String roomId) {
    state = roomId;
  }
}

class ChatMessagesNotifier extends AsyncNotifier<List<ChatMessage>> {
  StompUnsubscribe? _unsubscribe;

  @override
  Future<List<ChatMessage>> build() async {
    final roomId = ref.watch(currentRoomIdProvider);
    if (roomId.isEmpty) return [];

    ref.onDispose(() {
      _unsubscribe?.call();
    });

    final stompService = ref.read(stompServiceProvider);
    final messages = await ref.read(chatRepositoryProvider).getMessages(roomId);
    _subscribeToRoom(roomId);
    stompService.enterRoom(roomId: roomId);
    return messages;
  }

  void _subscribeToRoom(String roomId) {
    final stompService = ref.read(stompServiceProvider);
    _unsubscribe = stompService.subscribe(
      roomId: roomId,
      onMessage: (data) {
        final message = ChatMessage.fromJson(data);
        final current = state.value ?? [];
        state = AsyncValue.data([...current, message]);
      },
    );
  }

  void sendMessage(String message) {
    final roomId = ref.read(currentRoomIdProvider);
    final stompService = ref.read(stompServiceProvider);
    stompService.sendMessage(roomId: roomId, message: message);
  }
}
