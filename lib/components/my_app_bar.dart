import 'package:flutter/material.dart';

import '../constants.dart';

class MyAppBar {
  AppBar build(context, {String heading}) {
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
    );
  }
}
