import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatscreen/models/message.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class TextMessageBubble extends StatelessWidget {
  final Message message;
  final bool isFromSignedInUser;
  final bool showCurrentUserProfilePicture;
  final bool showOtherUserProfilePicture;

  TextMessageBubble({
    this.message,
    this.isFromSignedInUser,
    @required this.showCurrentUserProfilePicture,
    @required this.showOtherUserProfilePicture,
  });

  @override
  Widget build(BuildContext context) {
    try {
      var size = MediaQuery.of(context).size;

      var avatar = CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(message.fromProfilePicture),
        radius: 12.5,
        backgroundColor: Colors.transparent,
      );

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
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width * 3 / 4),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: isFromSignedInUser
                      ? Radius.circular(30)
                      : Radius.circular(0),
                  topRight: isFromSignedInUser == false
                      ? Radius.circular(30)
                      : Radius.circular(0),
                ),
                color: isFromSignedInUser ? kCoolLightGreenBlue : Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    message.contentText,
                    maxLines: null,
                    style: TextStyle(
                      color: isFromSignedInUser ? Colors.white : kCoolBlack,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

//      return Row(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          SizedBox(width: 4),
//          isFromSignedInUser == false ? avatar : SizedBox.shrink(),
//,
//          isFromSignedInUser == false ? SizedBox.shrink() : avatar,
//          SizedBox(width: 4),
//        ],
//      );
    } catch (e) {
      print(e);
    }
    return SizedBox.shrink();
  }
}
