import 'package:chatscreen/models/message.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class TextMessageBubble extends StatelessWidget {
  final Message message;
  final bool isFromSignedInUser;

  TextMessageBubble({this.message, this.isFromSignedInUser});

  @override
  Widget build(BuildContext context) {
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
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft:
                  isFromSignedInUser ? Radius.circular(30) : Radius.circular(0),
              topRight: isFromSignedInUser == false
                  ? Radius.circular(30)
                  : Radius.circular(0),
            ),
            color: isFromSignedInUser ? kCoolLightGreenBlue : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                message.contentText,
                style: TextStyle(
                  color: isFromSignedInUser ? Colors.white : kCoolBlack,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
