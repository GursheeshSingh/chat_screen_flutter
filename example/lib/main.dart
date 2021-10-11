import 'package:flutter/material.dart';
import 'package:chatscreen/chatscreen.dart';
import 'package:chatscreen/providers/parse_server_message_provider.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'constants.dart';

void main() async {
  runApp(const MyApp());
  Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey,
      debug: true,
      liveQueryUrl: keyParseLiveQuery,
      //masterKey: keyMaster,
      autoSendSessionId: true,
      coreStore: await CoreStoreSharedPrefsImp.getInstance());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestChatView(),
    );
  }
}

class TestChatView extends StatelessWidget {
  const TestChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  messageProvider: ParseServerMessageProvider(
                    "PublicRoom",
                    'publicRoomId',
                  ),
                  currentUserId: 'UserId',
                  currentUserName: 'UserName',
                  // showCurrentUserName: true,
                  //  showOtherUserName: true,
                ),
              ),
            );
          },
          child: const Text('Open Chat'),
        ),
      ),
    );
  }
}
