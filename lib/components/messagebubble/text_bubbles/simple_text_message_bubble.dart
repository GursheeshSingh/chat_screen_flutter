import 'package:chatscreen/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

class SimpleTextMessageBubble extends StatefulWidget {
  final Message? message;
  final bool? isFromSignedInUser;

  SimpleTextMessageBubble({
    this.message,
    this.isFromSignedInUser,
  });

  @override
  State<SimpleTextMessageBubble> createState() =>
      _SimpleTextMessageBubbleState();
}

class _SimpleTextMessageBubbleState extends State<SimpleTextMessageBubble> {
  Map<String, PreviewData> datas = {};

  @override
  Widget build(BuildContext context) {
    return LinkPreview(
      padding: EdgeInsets.only(top: 6),
      enableAnimation: true,
      onPreviewDataFetched: (data) {
        setState(() {
          datas = {
            ...datas,
            widget.message!.contentText!: data,
          };
        });
      },
      previewData: datas[widget.message!.contentText!],
      text: widget.message!.contentText!,
      width: MediaQuery.of(context).size.width,
    );
  }
}
