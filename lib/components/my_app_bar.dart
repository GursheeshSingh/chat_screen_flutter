import 'package:flutter/material.dart';

import '../constants.dart';

class MyAppBar {
  AppBar build(context,
      {String? heading, bool? showShareButton, Function? onShareClicked}) {
    return AppBar(
      //backgroundColor: Colors.transparent,
      elevation: 0,
   //   iconTheme: IconThemeData(color: kCoolBlack),
      title: heading != null
          ? Text(
              heading,
           //   style: TextStyle(color: kCoolBlack),
            )
          : SizedBox.shrink(),
      actions: <Widget>[
        if(showShareButton ?? false)
        Container(
          margin: EdgeInsets.only(right: 16),
          child: GestureDetector(
            child: Icon(
              Icons.share,
              size: 25,
           //   color: kCoolLightGreenBlue,
            ),
            onTap: onShareClicked as void Function()?,
          ),
        )
      ],
    );
  }
}
