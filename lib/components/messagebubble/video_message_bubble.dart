import 'package:chatscreen/components/video_player_widget.dart';
import 'package:chatscreen/models/message.dart';
import 'package:chatscreen/models/message_status.dart';
import 'package:chatscreen/providers/message_provider.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class VideoMessageBubble extends StatelessWidget {
  final Message? message;
  final bool? isFromSignedInUser;
  final MessageProvider? messageProvider;

  VideoMessageBubble({
    this.message,
    this.isFromSignedInUser,
    this.messageProvider,
  });

  @override
  Widget build(BuildContext context) {
    final String? videoUrl = messageProvider!.getFileUrl(message!.contentFile);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GestureDetector(
          onTap: () => showVideoPlayer(context, videoUrl),
          child: Stack(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 150),
                child: message!.videoThumbnail != null
                    ? Image.memory(
                        message!.videoThumbnail!,
                        height: 150,
                        width: 250,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        height: 150,
                        width: 250,
                        // color: kDarkGray,
                      ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: FloatingActionButton(
                    onPressed: () => showVideoPlayer(context, videoUrl),
                    child: Icon(
                      Icons.play_arrow,
                      size: 50,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showVideoPlayer(parentContext, String? videoUrl) async {
    if (message!.messageStatus != null &&
        message!.messageStatus != MessageStatus.SUCCESS) {
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
