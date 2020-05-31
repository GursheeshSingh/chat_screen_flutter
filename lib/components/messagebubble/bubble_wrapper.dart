import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatscreen/models/message.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class BubbleWrapper extends StatelessWidget {
  final Message message;
  final bool isFromSignedInUser;
  final String currentUserName;
  final bool showCurrentUserName;
  final bool showCurrentUserProfilePicture;
  final bool showOtherUserName;
  final bool showOtherUserProfilePicture;
  final Widget child;

  BubbleWrapper({
    @required this.child,
    @required this.message,
    @required this.isFromSignedInUser,
    this.currentUserName,
    this.showCurrentUserName,
    this.showCurrentUserProfilePicture,
    this.showOtherUserName,
    this.showOtherUserProfilePicture,
  });

  @override
  Widget build(BuildContext context) {
    var avatar = CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(message.fromProfilePicture),
      radius: 12.5,
      backgroundColor: Colors.transparent,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 4),
        isFromSignedInUser == false && showOtherUserProfilePicture
            ? avatar
            : SizedBox.shrink(),
        Column(
          crossAxisAlignment: isFromSignedInUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible: isFromSignedInUser == false &&
                  message.fromName != null &&
                  showOtherUserName,
              child: Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  message.fromName,
                  style:
                      TextStyle(color: kDarkGray, fontSize: kMessageNameSize),
                ),
              ),
            ),
            Visibility(
              visible: isFromSignedInUser &&
                  currentUserName != null &&
                  showCurrentUserName,
              child: Container(
                margin: EdgeInsets.only(right: 16),
                alignment: Alignment.centerRight,
                child: Text(
                  currentUserName,
                  style:
                      TextStyle(color: kDarkGray, fontSize: kMessageNameSize),
                ),
              ),
            ),
            child,
          ],
        ),
        isFromSignedInUser && showCurrentUserProfilePicture
            ? avatar
            : SizedBox.shrink(),
        SizedBox(width: 4),
      ],
    );
  }
}
