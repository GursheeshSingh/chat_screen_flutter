import 'package:chatscreen/components/video_player_widget.dart';
import 'package:chatscreen/models/message.dart';
import 'package:chatscreen/models/message_status.dart';
import 'package:chatscreen/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../constants.dart';

class VideoMessageBubble extends StatelessWidget {
  final Message message;
  final bool isFromSignedInUser;
  final MessageProvider messageProvider;

  VideoMessageBubble({
    this.message,
    this.isFromSignedInUser,
    this.messageProvider,
  });

  @override
  Widget build(BuildContext context) {
    final String videoUrl = messageProvider.getFileUrl(message.contentFile);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: isFromSignedInUser == false && message.fromName != null,
          child: Container(
            margin: EdgeInsets.only(left: 16),
            child: Text(
              message.fromName,
              style: TextStyle(color: kDarkGray, fontSize: kMessageNameSize),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onTap: () => showVideoPlayer(context, videoUrl),
              child: Stack(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 150),
                    child: message.videoThumbnail != null
                        ? Image.memory(message.videoThumbnail)
                        : Container(
                            height: 150,
                            width: 250,
                            color: kDarkGray,
                          ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Icon(
                        AntDesign.play,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showVideoPlayer(parentContext, String videoUrl) async {
    if (message.messageStatus != null &&
        message.messageStatus != MessageStatus.SUCCESS) {
      return;
    }
    await showModalBottomSheet(
      context: parentContext,
      builder: (BuildContext bc) {
        return VideoPlayerWidget(videoUrl);
      },
      isScrollControlled: true,
    );
  }
}
