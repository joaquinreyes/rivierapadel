import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../globals/constants.dart';
import '../../models/chat_socket_chat_message_model.dart';
import '../../models/chat_socket_join_model.dart';
import '../api_manager.dart';
import '../user_manager.dart';
import 'chat_socket_state.dart';

final chatSocketProvider =
    StateNotifierProvider<ChatSocketNotifier, ChatSocketState>(
  (ref) => ChatSocketNotifier(ref),
);

class ChatSocketNotifier extends StateNotifier<ChatSocketState> {
  late io.Socket _socket;
  Ref ref;

  void _chatMessageListener(data) {
    myPrint("----------------- Socket Chat Message --------------------");
    myPrint(data);
    myPrint("-------------------------------------");

    final response = ChatSocketChatMessageModel.fromJson(data);

    Message? message = response.message;
    if (message != null) {
      state = state
          .copyWith(chats: [...state.chats, message], admin: null, users: null);
    }
  }

  void _onJoin(data) {
    myPrint("----------------- Socket Join --------------------");
    myPrint(data);
    myPrint("-------------------------------------");
    final response = ChatSocketJoinModel.fromJson(data);
    state = state.copyWith(
        users: response.users, admin: response.admin, chats: response.chats);
  }

  ChatSocketNotifier(this.ref) : super(ChatSocketState.initial());

  void connect({required int matchId}) {
    final token = ref.read(userManagerProvider).user?.accessToken!;
    final l = "$kChatBaseURL/$kClubID/apps/chat/$matchId";
    log('Connecting to: $l');
    log('Header to: Authorization : $token,AccessType : app');
    _socket = io.io(
      l,
      io.OptionBuilder()
          .setTransports([kIsWeb ? 'polling' : 'websocket'])
          .enableForceNew()
          .enableReconnection()
          .setExtraHeaders({'Authorization': '$token', 'AccessType': 'app'})
          .build(),
    );

    _socket.onConnect((_) {
      log('----------------- Connected To Chat ---------------------');
    });

    _socket.on('chatMessage', _chatMessageListener);

    _socket.on('join', _onJoin);

    _socket.onConnectError((error) {
      log('Connection Error: $error');
    });

    _socket.onDisconnect((_) {
      myPrint('Disconnected');
    });

    _socket.connect();
  }

  void clearChatJoinData() {
    state = state.copyWith(chats: [], users: [], admin: []);
  }

  void offSocket() {
    _socket.disconnect();
    _socket.off("chatMessage");
    _socket.off("join");
  }

  bool sendMessage(String message) {
    try {
      _socket.emit("chatMessage", {"message": message});
    } catch (e) {
      return false;
    }
    return true;
  }
}
