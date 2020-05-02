import 'dart:io';

import 'package:chatscreen/models/content_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import 'custom_dialog.dart';

class AddAttachmentModalSheet extends StatefulWidget {
  final Size screenSize;
  final Function onFileSelected;

  AddAttachmentModalSheet(this.screenSize, this.onFileSelected);

  @override
  _AddAttachmentModalSheetState createState() =>
      _AddAttachmentModalSheetState();
}

class _AddAttachmentModalSheetState extends State<AddAttachmentModalSheet> {
  _buildHeading(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.title,
    );
  }

  _buildCloseButton(context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        MaterialIcons.close,
        color: kDarkGray,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
//      height: widget.screenSize.height * 0.3,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildHeading('Upload'),
                _buildCloseButton(context)
              ],
            ),
            _buildOption(FontAwesome.camera, 'Camera',
                () => _onPickFromCameraClicked(context)),
            _buildOption(MaterialIcons.photo_library, 'Photo library',
                () => _onAddPhotoClicked(context)),
            _buildOption(Entypo.folder_video, 'Video library',
                () => _onAddVideoClicked(context)),
          ],
        ),
      ),
    );
  }

  _buildOption(IconData optionIcon, String optionName, Function onItemClicked) {
    return GestureDetector(
      onTap: onItemClicked,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: <Widget>[
            Icon(optionIcon),
            SizedBox(width: 8),
            Text(
              optionName,
              style: Theme.of(context).textTheme.display1,
            )
          ],
        ),
      ),
    );
  }

  Future<bool> checkPermission(Permission permission, String subHeading) async {
    PermissionStatus permissionStatus = await permission.status;

    print(permissionStatus);

    if (permissionStatus == PermissionStatus.restricted) {
      _showOpenAppSettingsDialog(context, subHeading);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return false;
      }
    }

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _showOpenAppSettingsDialog(context, subHeading);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return false;
      }
    }

    if (permissionStatus == PermissionStatus.undetermined) {
      permissionStatus = await permission.request();

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return false;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context, subHeading);
      } else {
        permissionStatus = await permission.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return false;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      return true;
    }

    return false;
  }

  _onAddPhotoClicked(context) async {
    Permission imagePermission;

    if (Platform.isIOS) {
      imagePermission = Permission.photos;
    } else {
      imagePermission = Permission.storage;
    }

    bool isPermissionGranted = await checkPermission(
        imagePermission, "Photos permission is needed to select photos");

    if (isPermissionGranted == false) {
      //TODO: Add something went wrong, check permission message
      return;
    }

    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      widget.onFileSelected(image, ContentType.image);
    }
    Navigator.pop(context);
  }

  _onAddVideoClicked(context) async {
    Permission imagePermission;

    if (Platform.isIOS) {
      imagePermission = Permission.photos;
    } else {
      imagePermission = Permission.storage;
    }

    bool isPermissionGranted = await checkPermission(
        imagePermission, "Video permission is needed to select videos");

    if (isPermissionGranted == false) {
      //TODO: Add something went wrong, check permission message
      return;
    }

    File video = await ImagePicker.pickVideo(
      source: ImageSource.gallery,
    );

    if (video != null) {
      widget.onFileSelected(video, ContentType.video);
    }
    Navigator.pop(context);
  }

  _onPickFromCameraClicked(context) async {
    Permission cameraPermission = Permission.camera;

    bool isPermissionGranted = await checkPermission(
        cameraPermission, "Cameara permission is needed to click photos");

    print('Is camera permission granted: ' + isPermissionGranted.toString());

    if (isPermissionGranted == false) {
      //TODO: Add something went wrong, check permission message
      return;
    }

    File video = await ImagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (video != null) {
      print('Video seleceted');
    }
  }

  _showOpenAppSettingsDialog(context, String subHeading) {
    return CustomDialog.show(
      context,
      'Permission needed',
      subHeading,
      'Open settings',
      openAppSettings,
    );
  }
}
