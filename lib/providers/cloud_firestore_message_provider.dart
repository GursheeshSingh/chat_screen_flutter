import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/firebase_message.dart';
import '../models/message.dart';
import 'message_provider.dart';

class CloudFirestoreMessageProvider implements MessageProvider {
  final String className;
  final String roomId;

  final FirebaseApp app;
  late FirebaseFirestore firestore;
  late FirebaseStorage storage;

  DateTime? newestMessageCreatedAt;
  DateTime? oldestMessageCreatedAt;

  DocumentSnapshot? lastMessageSnapshot;

  CloudFirestoreMessageProvider(this.className, this.roomId, this.app) {
    firestore = FirebaseFirestore.instanceFor(app: app);
    storage = FirebaseStorage.instance;
  }

  @override
  Message createMessage() {
    return FirebaseMessage(className)..roomId = roomId;
  }

  @override
  Future<List<Message>> fetchInitialMessages() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection(className)
          .where("roomId", isEqualTo: roomId)
          .orderBy("createdAt", descending: true)
          .limit(MessageProvider.LIMIT)
          .get();
      List<DocumentSnapshot> documents = snapshot.docs;
      List<Message> messages = [];

      if (documents.length == 0) {
        return messages;
      }

      for (int i = 0; i < documents.length; i++) {
        DocumentSnapshot snapshot = documents[i];

        FirebaseMessage firestoreMessage = FirebaseMessage(className);
        firestoreMessage.data = snapshot.data()!;
        messages.add(firestoreMessage);
      }

      lastMessageSnapshot = documents[0];
      newestMessageCreatedAt = (messages[0].createdAt as Timestamp).toDate();
      oldestMessageCreatedAt =
          (messages[messages.length - 1].createdAt as Timestamp).toDate();

      return messages;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Message>> fetchOldMessages() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection(className)
          .where("roomId", isEqualTo: roomId)
          .orderBy("createdAt", descending: true)
          .where("createdAt", isLessThan: oldestMessageCreatedAt)
          .limit(MessageProvider.LIMIT)
          .get();

      List<DocumentSnapshot> documents = snapshot.docs;
      List<Message> messages = [];

      if (documents.length == 0) {
        return messages;
      }

      for (int i = 0; i < documents.length; i++) {
        DocumentSnapshot snapshot = documents[i];

        FirebaseMessage firestoreMessage = FirebaseMessage(className);
        firestoreMessage.data = snapshot.data() ?? {};
        messages.add(firestoreMessage);
      }

      oldestMessageCreatedAt =
          (messages[messages.length - 1].createdAt as Timestamp).toDate();

      return messages;
    } catch (e) {
      throw e;
    }
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
      FirebaseMessage firestoreMessage = message as FirebaseMessage;
      firestoreMessage.createdAt = FieldValue.serverTimestamp();

      await firestore.collection(className).doc().set(firestoreMessage.data);

      return firestoreMessage;
    } catch (e) {
      print(e);
    }
    throw "Failed to send message";
  }

  @override
  Future<bool> setUpLiveClient(
      String currentUserId, Function onNewMessage) async {
    Query query = firestore
        .collection(className)
        .where("roomId", isEqualTo: roomId)
        .orderBy("createdAt", descending: true);

    if (lastMessageSnapshot != null) {
      query = query.endBeforeDocument(lastMessageSnapshot!);
    }

    Stream<QuerySnapshot> snapshots = query.snapshots();
    snapshots.forEach((snapshot) {
      List<DocumentChange> documentChanges = snapshot.docChanges;

      List<Message> recentMessages = [];

      for (int i = 0; i < documentChanges.length; i++) {
        if (documentChanges[i].type == DocumentChangeType.added) {
          FirebaseMessage firestoreMessage = FirebaseMessage(className);

          firestoreMessage.data = documentChanges[i].doc.data() ?? {};

          if (firestoreMessage.fromId != currentUserId) {
            recentMessages.add(firestoreMessage);
          }

          lastMessageSnapshot = documentChanges[i].doc;
        }
      }
      onNewMessage(recentMessages);
    });
    return true;
  }
}
