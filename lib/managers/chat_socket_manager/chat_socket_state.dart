import '../../models/chat_socket_chat_message_model.dart';
import '../../models/chat_socket_join_model.dart';

class ChatSocketState {
  List<Message> chats;
  List<Admin> admin;
  List<Users> users;

  ChatSocketState(
      {required this.chats, required this.admin, required this.users});

  factory ChatSocketState.initial() {
    return ChatSocketState(chats: [], admin: [], users: []);
  }

  ChatSocketState copyWith(
      {List<Message>? chats, List<Admin>? admin, List<Users>? users}) {
    return ChatSocketState(
        chats: chats ?? this.chats,
        admin: admin ?? this.admin,
        users: users ?? this.users);
  }
}
