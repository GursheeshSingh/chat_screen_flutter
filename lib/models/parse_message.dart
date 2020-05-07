import 'dart:typed_data';

import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'message.dart';
import 'message_status.dart';

class ParseMessage extends ParseObject implements ParseCloneable, Message {
  ParseMessage.clone(String className) : this(className);

  /// Looks strangely hacky but due to Flutter not using reflection, we have to
  /// mimic a clone
  @override
  clone(Map map) => ParseMessage.clone(className)..fromJson(map);

  ParseMessage(this.className) : super(className);

  String className;

  MessageStatus messageStatus;
  Uint8List videoThumbnail;

  String get fromId => get<String>("from");

  String get contentType => get<String>("contentType");

  String get contentText => get<String>("contentText");

  Object get contentFile => get<Object>("contentFile");

  String get roomId => get<String>("roomId");

  String get fromName => get<String>("fromName");

  String get fromProfilePicture => get<String>("fromProfilePicture");

  set fromId(String fromId) => set<String>("from", fromId);

  set fromName(String fromName) => set<String>("fromName", fromName);

  set fromProfilePicture(String fromProfilePicture) =>
      set<String>("fromProfilePicture", fromProfilePicture);

  set contentType(String contentType) =>
      set<String>("contentType", contentType);

  set contentText(String contentText) =>
      set<String>("contentText", contentText);

  set contentFile(Object contentFile) =>
      set<Object>("contentFile", contentFile);

  set roomId(String roomId) => set<String>("roomId", roomId);

  set createdAt(Object createdAt) => set<Object>("createdAt", createdAt);
}
