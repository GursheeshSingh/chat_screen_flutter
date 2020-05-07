# Chat Screen - Flutter

This project only supports group chats for now. Open to contributions.

Available for

* Parse Server
* Cloud firestore
* Firebase Realtime data - Partially completed, Issue in library provided by firebase - https://github.com/FirebaseExtended/flutterfire/issues/753

## Screenshots

![Demo 1](/screenshots/show1.gif)

**NOTE:** Video player doesn't work on IOS Simulators

## Set up for Parse Server

* Make sure you initialize Parse

```
await Parse().initialize(
        keyApplicationId,
        keyParseServerUrl
);
```
* Make sure LiveQuery server is initialized
```
var parseLiveQueryServer = ParseServer.createLiveQueryServer(httpServer);
```

* Each user has a name or username

* Profile picture - Feature in progress

### How to open Group chat screen

```
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ChatScreen(
      messageProvider: ParseServerMessageProvider(
        "className",
        roomId,
      ),
      currentUserId: parseUser.objectId,
      currentUserName: parseUser.get("name"),
      currentUserProfilePicture: parseUser.get("profilePicture"),
    ),
  ),
);
```
* Make sure you add the class names when you initialize ParseServer

```
var api = new ParseServer({

  // List of classes to support for query subscriptions
  liveQuery: {
    classNames: [
      "ForniteMessages",
      "PUBGMessages",
    ],
  },
});
```

## Set up for Cloud firestore

* Make sure you initialize FirebaseApp

```
final FirebaseApp firebaseApp = await FirebaseApp.configure(
  name: 'projectName',
  options: FirebaseOptions(
    googleAppID: Platform.isIOS
        ? 'appIdForIOS'
        : 'appIdForAndroid',
    gcmSenderID: 'gcmSenderID',
    apiKey: 'apiKey',
    projectID: 'projectId',
    storageBucket: 'storageBucketUrl',
  ),
)
```

* Make sure you add index for each class

![Example index](/screenshots/firebase_index.png)

* Each user has a name or username

* Profile picture - Feature in progress

## How to open group chat

    Navigator.push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          messageProvider: CloudFirestoreMessageProvider(
            "PUBGMessages",
            roomId,
            firebaseApp,
          ),

          currentUserId: userId,
          currentUserName: name,
          currentUserProfilePicture: profilePictureUrl,
        ),
      ),
    );


## A look at data under the hood

* In Parse Server

![Example index](/screenshots/parse_server_mongodb_snapshot.png)

* In cloud firestore

![Example index](/screenshots/cloud_firestore_snapshot.png)


