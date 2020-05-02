import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatscreen/models/gallery_item.dart';
import 'package:chatscreen/models/message.dart';
import 'package:chatscreen/models/message_status.dart';
import 'package:chatscreen/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../gallery_photo_wrapper.dart';

class ImageMessageBubble extends StatelessWidget {
  final Message message;
  final bool isFromSignedInUser;
  final MessageProvider messageProvider;

  ImageMessageBubble({
    this.message,
    this.isFromSignedInUser,
    this.messageProvider,
  });

  @override
  Widget build(BuildContext context) {
    final fileUrl = messageProvider.getFileUrl(message.contentFile);
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onTap: () => _onPhotoClicked(context, fileUrl),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 150),
                child: message.messageStatus != null &&
                        message.messageStatus != MessageStatus.SUCCESS &&
                        fileUrl == null
                    ? Container(
                        color: kDarkGray,
                        height: 150,
                        width: 200,
                      )
                    : CachedNetworkImage(
                        imageUrl: fileUrl,
                        placeholder: (context, url) => _buildPlaceholder(),
                        errorWidget: (context, url, error) =>
                            _buildErrorWidget(),
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildPlaceholder() {
    return Stack(
      children: <Widget>[
        Container(
          color: kDarkGray,
          height: 200,
          width: 200,
        ),
        Positioned.fill(
          child: Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(kCoolLightGreenBlue),
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
          color: kDarkGray,
          height: 150,
          width: 200,
        ),
        Positioned.fill(
          child: Center(
              child: InkWell(
            onTap: () {},
            child: Icon(
              MaterialIcons.error,
              color: kErrorRed,
            ),
          )),
        )
      ],
    );
  }

  _onPhotoClicked(context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: [GalleryItem(id: Uuid().v4(), resource: imageUrl)],
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: 0,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
