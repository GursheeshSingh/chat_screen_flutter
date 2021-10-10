import 'package:bubble/bubble.dart';
import 'package:chatscreen/models/message.dart';
import 'package:flutter/material.dart';

const kWhatsappGreen = Color.fromRGBO(255, 255, 199, 1.0);

class WhatsAppTextMessageBubble extends StatelessWidget {
  final Message? message;
  final bool? isFromSignedInUser;

  WhatsAppTextMessageBubble({
    this.message,
    this.isFromSignedInUser,
  });

  @override
  Widget build(BuildContext context) {
    try {
      var size = MediaQuery.of(context).size;

      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width * 3 / 4),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Bubble(
            alignment: isFromSignedInUser!
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(message!.contentText!),
            color: isFromSignedInUser! ? kWhatsappGreen : Colors.white,
            nip: isFromSignedInUser! ? BubbleNip.rightTop : BubbleNip.leftTop,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
    return SizedBox.shrink();
  }
}
