import 'dart:typed_data';

import 'package:chatscreen/models/message_status.dart';

abstract class Message {
  Message();

  Uint8List videoThumbnail;
  MessageStatus messageStatus;

  String get fromId;

  String get contentType;

  String get contentText;

  String get roomId;

  String get fromName;

  String get fromProfilePicture;

  Object get contentFile;

  Object get createdAt;

  set fromId(String fromId);

  set fromName(String fromName);

  set fromProfilePicture(String fromProfilePicture);

  set contentType(String contentType);

  set contentText(String contentText);

  set contentFile(Object contentFile);

  set roomId(String roomId);

  set createdAt(Object createdAt);
}
