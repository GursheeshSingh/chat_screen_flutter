import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../constants.dart';

class MyAppBar {
  AppBar build(context,
      {String heading, bool showShareButton, Function onShareClicked}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: kCoolBlack),
      title: heading != null
          ? Text(
              heading,
              style: TextStyle(color: kCoolBlack),
            )
          : SizedBox.shrink(),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 16),
          child: GestureDetector(
            child: Icon(
              Feather.share,
              size: 25,
              color: kCoolLightGreenBlue,
            ),
            onTap: onShareClicked,
          ),
        )
      ],
    );
  }
}
