
import 'package:chatscreen/models/gallery_item.dart';
import 'package:chatscreen/models/message.dart';
import 'package:chatscreen/models/message_status.dart';
import 'package:chatscreen/providers/message_provider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../gallery_photo_wrapper.dart';

class ImageMessageBubble extends StatelessWidget {
  final Message? message;
  final bool? isFromSignedInUser;
  final MessageProvider? messageProvider;

  ImageMessageBubble({
    this.message,
    this.isFromSignedInUser,
    this.messageProvider,
  });

  @override
  Widget build(BuildContext context) {
    final fileUrl = messageProvider!.getFileUrl(message!.contentFile);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GestureDetector(
          onTap: () => _onPhotoClicked(context, fileUrl),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 150),
            child: message!.messageStatus != null &&
                    message!.messageStatus != MessageStatus.SUCCESS &&
                    fileUrl == null
                ? Container(
                    color: Colors.grey.shade200,
                    height: 150,
                    width: 250,
                  )
                : FancyShimmerImage(
                    imageUrl: fileUrl!,
                    height: 150,
                    width: 250,
                    boxFit: BoxFit.cover,
                    errorWidget: _buildErrorWidget(),
                  ),
          ),
        ),
      ),
    );
  }

  _buildPlaceholder() {
    return Stack(
      children: <Widget>[
        Container(
          //   color: kDarkGray,
          height: 200,
          width: 200,
        ),
        Positioned.fill(
          child: Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                /*valueColor: AlwaysStoppedAnimation(kCoolLightGreenBlue),*/
                strokeWidth: 4.0,
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildErrorWidget() {
    return Stack(
      children: <Widget>[
        Container(
          //   color: kDarkGray,
          height: 150,
          width: 200,
        ),
        Positioned.fill(
          child: Center(
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.error,
                // color: kErrorRed,
              ),
            ),
          ),
        )
      ],
    );
  }

  _onPhotoClicked(context, String? imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: [GalleryItem(id: Uuid().v4(), resource: imageUrl)],
          backgroundDecoration: const BoxDecoration(
              // color: Colors.black,
              ),
          initialIndex: 0,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
