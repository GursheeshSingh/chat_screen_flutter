import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatscreen/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class BubbleWrapper extends StatelessWidget {
  final Message message;
  final bool isFromSignedInUser;
  final String? currentUserName;
  final bool? showCurrentUserName;
  final bool? showCurrentUserProfilePicture;
  final bool? showOtherUserName;
  final bool? showOtherUserProfilePicture;
  final Widget child;

  BubbleWrapper({
    required this.child,
    required this.message,
    required this.isFromSignedInUser,
    this.currentUserName,
    this.showCurrentUserName,
    this.showCurrentUserProfilePicture,
    this.showOtherUserName,
    this.showOtherUserProfilePicture,
  });

  @override
  Widget build(BuildContext context) {
    var avatar = CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(message.fromProfilePicture ??
          "https://user-images.githubusercontent.com/31348106/48191192-59446e80-e33c-11e8-9658-c79a9fac72b0.png"),
      radius: 12.5,
      backgroundColor: Colors.transparent,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: isFromSignedInUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: isFromSignedInUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                SizedBox(width: 4),
                isFromSignedInUser == false && showOtherUserProfilePicture!
                    ? avatar
                    : SizedBox.shrink(),
                Visibility(
                  visible: isFromSignedInUser == false &&
                      message.fromName != null &&
                      showOtherUserName!,
                  child: Container(
                    margin: EdgeInsets.only(left: 8,right: 16),
                    child: Text(
                      message.fromName!,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: kMessageNameSize),
                    ),
                  ),
                ),
                Visibility(
                  visible: isFromSignedInUser &&
                      currentUserName != null &&
                      showCurrentUserName!,
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    alignment: Alignment.centerRight,
                    child: Text(
                      currentUserName!,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: kMessageNameSize),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    message.createdAt != null
                        ? DateFormat("hh:mm aaa")
                        .format(message.createdAt
                    as DateTime)
                        : "--:-- --",
                    style: TextStyle(
                      /*color: kDarkGray,*/ fontSize: kMessageNameSize/1.2),
                  ),
                ),
              ],
            ),
            child,
          ],
        ),
        isFromSignedInUser && showCurrentUserProfilePicture!
            ? avatar
            : SizedBox.shrink(),
        SizedBox(width: 4),
      ],
    );
  }
}
