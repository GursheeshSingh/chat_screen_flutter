import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/firebase_message.dart';
import '../models/message.dart';
import 'message_provider.dart';

class FirebaseDatabaseMessageProvider implements MessageProvider {
  final String className;
  final String roomId;

  final FirebaseApp app;
  late FirebaseDatabase database;
  late FirebaseStorage storage;

  DateTime? newestMessageCreatedAt;
  DateTime? oldestMessageCreatedAt;

  FirebaseDatabaseMessageProvider(this.className, this.roomId, this.app) {
    storage = FirebaseStorage.instance;
    database = FirebaseDatabase(app: app);
  }

  @override
  Message createMessage() {
    return FirebaseMessage(className)..roomId = roomId;
  }

  @override
  Future<List<Message>> fetchInitialMessages() async {
    try {
      DatabaseReference roomReference =
          database.reference().child(className).child(roomId);

      //ISSUE: OrderByChild not working
      //Track issue #753 on FlutterFire
      Query query = roomReference
          .orderByChild('createdAt')
          .limitToFirst(MessageProvider.LIMIT);

      DataSnapshot snapshot = await query.once();

      Map<String, dynamic> map = Map<String, dynamic>.from(snapshot.value);

      List<Message> messages = [];
      List<dynamic> list = map.values.toList();

      if (list == null || list.length == 0) {
        return messages;
      }

      for (var item in list) {
        FirebaseMessage firebaseMessage = FirebaseMessage(className);
        firebaseMessage.data = Map<String, dynamic>.from(item);
        messages.add(firebaseMessage);
      }

      newestMessageCreatedAt =
          new DateTime.fromMicrosecondsSinceEpoch(messages[0].createdAt as int);
      oldestMessageCreatedAt = new DateTime.fromMicrosecondsSinceEpoch(
          messages[messages.length - 1].createdAt as int);

      return messages;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Message>> fetchOldMessages() async {
    return [];
//    try {
//      QuerySnapshot snapshot = await firestore
//          .collection(className)
//          .where("roomId", isEqualTo: roomId)
//          .orderBy("createdAt", descending: true)
//          .where("createdAt", isLessThan: oldestMessageCreatedAt)
//          .limit(MessageProvider.LIMIT)
//          .getDocuments();
//
//      List<DocumentSnapshot> documents = snapshot.documents;
//      List<Message> messages = [];
//
//      if (documents == null || documents.length == 0) {
//        return messages;
//      }
//
//      for (int i = 0; i < documents.length; i++) {
//        DocumentSnapshot snapshot = documents[i];
//
//        CloudFirestoreMessage firestoreMessage =
//            CloudFirestoreMessage(className);
//        firestoreMessage.data = snapshot.data;
//        messages.add(firestoreMessage);
//      }
//
//      oldestMessageCreatedAt =
//          (messages[messages.length - 1].createdAt as Timestamp).toDate();
//
//      return messages;
//    } catch (e) {
//      throw e;
//    }
  }

  @override
  Future<Object?> getFileObject(File? file) async {
    final StorageReference imagesRef = storage.ref().child('$className/$roomId');
    String fileName = Uuid().v4();

    final StorageReference uploadFileRef = imagesRef.child(fileName);

    StorageUploadTask storageUploadTask = uploadFileRef.putFile(file!);
    UploadTaskSnapshot snapshot = await storageUploadTask.future;

    return snapshot.downloadUrl;
  }

  @override
  String? getFileUrl(Object? contentFile) {
    return contentFile as String?;
  }

  @override
  Future<Message> sendMessage(Message message) async {
    try {
      FirebaseMessage firebaseMessage = message as FirebaseMessage;
      firebaseMessage.createdAt = ServerValue.timestamp;

      await database
          .reference()
          .child(className)
          .child(roomId)
          .push()
          .set(firebaseMessage.data);

      return firebaseMessage;
    } catch (e) {}
    throw "Failed to send message";
  }

  @override
  Future<bool> setUpLiveClient(
      String currentUserId, Function onNewMessage) async {
    DatabaseReference roomReference =
        database.reference().child(className).child(roomId);

    //ISSUE: OrderByChild not working
    //Track issue #753 on FlutterFire
    Query query = roomReference.orderByChild('createdAt');

    if (newestMessageCreatedAt != null) {
      query = query.startAt(newestMessageCreatedAt!.millisecondsSinceEpoch,
          key: "createdAt");
    }

    Stream<Event> events = query.onChildAdded;

    events.forEach((event) {
      Map<String, dynamic> map =
          Map<String, dynamic>.from(event.snapshot.value);
      FirebaseMessage firebaseMessage = FirebaseMessage(className);
      firebaseMessage.data = map;
      print(firebaseMessage.data.toString());
      if (firebaseMessage.fromId != currentUserId) {
        onNewMessage([firebaseMessage]);
      }
    });

    return true;
  }
}
