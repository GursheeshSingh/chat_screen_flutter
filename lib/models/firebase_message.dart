import 'dart:typed_data';

import 'message.dart';
import 'message_status.dart';

class FirebaseMessage implements Message {
  Map<String, dynamic> data = Map();

  FirebaseMessage(this.className);
  String className;

  MessageStatus messageStatus;
  Uint8List videoThumbnail;

  String get fromId => data["from"];

  String get contentType => data["contentType"];

  String get contentText => data["contentText"];

  Object get contentFile => data["contentFile"];

  String get roomId => data["roomId"];

  String get fromName => data["fromName"];

  String get fromProfilePicture => data["fromProfilePicture"];

  Object get createdAt => data["createdAt"];

  set fromId(String fromId) => data.putIfAbsent("from", () => fromId);

  set fromName(String fromName) => data.putIfAbsent("fromName", () => fromName);

  set fromProfilePicture(String fromProfilePicture) =>
      data.putIfAbsent("fromProfilePicture", () => fromProfilePicture);

  set contentType(String contentType) =>
      data.putIfAbsent("contentType", () => contentType);

  set contentText(String contentText) =>
      data.putIfAbsent("contentText", () => contentText);

  set contentFile(Object contentFile) =>
      data.putIfAbsent("contentFile", () => contentFile);

  set roomId(String roomId) => data.putIfAbsent("roomId", () => roomId);

  set createdAt(Object createdAt) =>
      data.putIfAbsent("createdAt", () => createdAt);
}
