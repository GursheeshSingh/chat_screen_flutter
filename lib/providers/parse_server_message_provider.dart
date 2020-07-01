import 'dart:io';

import 'package:chatscreen/models/content_type.dart';
import 'package:chatscreen/models/message.dart';
import 'package:chatscreen/models/parse_message.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'message_provider.dart';

class ParseServerMessageProvider implements MessageProvider {
  DateTime newestMessageCreatedAt;
  DateTime oldestMessageCreatedAt;

  final String className;
  final String roomId;

  ParseServerMessageProvider(this.className, this.roomId);

  @override
  Future<Message> sendMessage(Message message) async {
    await Future.delayed(Duration(seconds: 3));
    try {
      ParseMessage parseMessage = message;
      var response = await parseMessage.save();

      if (response.success) {
        Message newMessage = response.result as Message;
        return newMessage;
      }
      throw "Failed to send message";
    } catch (e) {
      throw "Failed to send message";
    }
  }

  @override
  Future<List<Message>> fetchInitialMessages() async {
    try {
      List<Message> messages = List();

      var queryBuilder = QueryBuilder<ParseMessage>(ParseMessage(className))
        ..whereEqualTo("roomId", roomId)
        ..orderByDescending("_created_at")
        ..setLimit(MessageProvider.LIMIT);

      var response = await queryBuilder.query();

      if (response.success) {
        if (response.results == null || response.results.length == 0) {
          return messages;
        }

        for (ParseMessage message in response.results) {
          messages.add(message);
          print('In Initial messages');
          print(response.results);
        }

        newestMessageCreatedAt = messages[0].createdAt;
        oldestMessageCreatedAt = messages[messages.length - 1].createdAt;

        return messages;
      } else {
        throw response.error.message;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Message>> fetchOldMessages() async {
    try {
      List<Message> messages = List();

      var queryBuilder = QueryBuilder<ParseMessage>(ParseMessage(className))
        ..whereEqualTo("roomId", roomId)
        ..orderByDescending("_created_at")
        ..whereLessThan("createdAt", oldestMessageCreatedAt)
        ..setLimit(MessageProvider.LIMIT);

      var response = await queryBuilder.query();

      if (response.success) {
        if (response.results == null) {
          return messages;
        }

        for (Message message in response.results) {
          messages.add(message);
        }

        if (messages.length != 0) {
          oldestMessageCreatedAt = messages[messages.length - 1].createdAt;
        }

        return messages;
      } else {
        throw response.error.message;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> setUpLiveClient(
      String currentUserId, Function onNewMessage) async {
    final LiveQuery liveQuery = LiveQuery();

    //NOTE: Only messages from other users
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(className))
          ..whereEqualTo("roomId", roomId)
          ..whereNotEqualTo("from", currentUserId)
          ..orderByAscending("_created_at");
    if (newestMessageCreatedAt != null) {
      //Can be null is case no messages at first
      query.whereGreaterThan("createdAt", newestMessageCreatedAt);
    }

    print('Subscription starts');
    Subscription subscription = await liveQuery.client.subscribe(query);
    subscription.on(LiveQueryEvent.create, (value) {
      ParseObject messageObject = value as ParseObject;

      Message message = ParseMessage(className);
      message.fromId = messageObject.get<String>("from");
      message.fromName = messageObject.get<String>("fromName");
      message.contentType = messageObject.get<String>("contentType");
      if (message.contentType == ContentType.text.toString()) {
        message.contentText = messageObject.get<String>("contentText");
      } else {
        message.contentFile = messageObject.get<ParseFile>("contentFile");
      }
      message.roomId = roomId;

      newestMessageCreatedAt = messageObject.createdAt;

      onNewMessage([message]);
    });
    print('Subscription successful');
    return true;
  }

  @override
  String getFileUrl(Object contentFile) {
    ParseFile parseFile = contentFile as ParseFile;
    return parseFile?.url;
  }

  @override
  Future<Object> getFileObject(File uploadFile) async {
    ParseFile parseFile = ParseFile(uploadFile);
    return parseFile;
  }

  @override
  Message createMessage() {
    return ParseMessage(className)..roomId = roomId;
  }
}
