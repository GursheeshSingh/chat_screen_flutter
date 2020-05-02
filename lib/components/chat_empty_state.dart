import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatEmptyState extends StatelessWidget {
  final int length;

  ChatEmptyState({this.length = 15});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: ListView.builder(
          itemCount: length,
          reverse: true,
          itemBuilder: (_, index) => Row(
            mainAxisAlignment: index % 2 == 0
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: index % 5 == 0
                      ? Container(
                          height: 150,
                          width: 275,
                          color: Colors.white,
                        )
                      : Container(
                          width: 200,
                          height: 40,
                          color: Colors.white,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
