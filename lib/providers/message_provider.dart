import 'dart:io';

import 'package:chatscreen/models/message.dart';

abstract class MessageProvider {
  static const int LIMIT = 20;
  static const int SKIP = 20;

  Future<Message> sendMessage(Message message);

  Future<List<Message>> fetchInitialMessages();

  Future<List<Message>> fetchOldMessages();

  Future<bool> setUpLiveClient(String currentUserId, Function onNewMessage);

  String? getFileUrl(Object? contentFile);

  Future<Object?> getFileObject(File? file);

  Message createMessage();
}
