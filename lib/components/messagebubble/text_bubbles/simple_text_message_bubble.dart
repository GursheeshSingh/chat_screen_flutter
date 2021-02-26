import 'package:chatscreen/models/message.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class SimpleTextMessageBubble extends StatelessWidget {
  final Message? message;
  final bool? isFromSignedInUser;

  SimpleTextMessageBubble({
    this.message,
    this.isFromSignedInUser,
  });

  @override
  Widget build(BuildContext context) {
    try {
      var size = MediaQuery.of(context).size;

      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width * 3 / 4),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft:
                  isFromSignedInUser! ? Radius.circular(30) : Radius.circular(0),
              topRight: isFromSignedInUser == false
                  ? Radius.circular(30)
                  : Radius.circular(0),
            ),
            color: isFromSignedInUser! ? Theme.of(context).primaryColor : Theme.of(context).primaryColorLight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                message!.contentText!,
                maxLines: null,
                style: TextStyle(
                  color: isFromSignedInUser! ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
    return SizedBox.shrink();
  }
}
