library chatscreen;

import 'dart:io';

import 'package:chatscreen/components/messagebubble/bubble_wrapper.dart';
import 'package:chatscreen/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'components/add_attachment_sheet.dart';
import 'components/chat_empty_state.dart';
import 'components/messagebubble/image_message_bubble.dart';
import 'components/messagebubble/text_message_bubble.dart';
import 'components/messagebubble/video_message_bubble.dart';
import 'components/my_app_bar.dart';
import 'constants.dart';
import 'models/content_type.dart';
import 'models/message.dart';
import 'models/message_status.dart';

///If [showCurrentUserProfilePicture] is true, [currentUserProfilePicture] cannot be null
///If [showCurrentUserName] is true, [currentUserName] cannot be null
class ChatScreen extends StatefulWidget {
  final MessageProvider messageProvider;
  final String currentUserId;
  final String currentUserName;
  final String currentUserProfilePicture;

  final bool showCurrentUserName;
  final bool showCurrentUserProfilePicture;
  final bool showOtherUserName;
  final bool showOtherUserProfilePicture;

  static const double NAME_SIZE = 10;

  ChatScreen({
    @required this.messageProvider,
    @required this.currentUserId,
    this.currentUserName,
    this.currentUserProfilePicture,
    this.showCurrentUserName = false,
    this.showCurrentUserProfilePicture = false,
    this.showOtherUserName = false,
    this.showOtherUserProfilePicture = false,
  }) {
    if (showCurrentUserName) {
      assert(currentUserName != null);
    }
    if (showCurrentUserProfilePicture) {
      assert(currentUserProfilePicture != null);
    }
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages;
  TextEditingController _textEditingController = TextEditingController();
  String messageText;
  final RefreshController _controller =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    loadInitialMessages();
  }

  int maxNumberOfLines = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().build(context),
      backgroundColor: kLightGray,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: messages == null
                  ? ChatEmptyState()
                  : SmartRefresher(
                      enablePullUp: true,
                      enablePullDown: false,
                      controller: _controller,
                      onLoading: _onLoading,
                      child: ListView(
                        reverse: true,
                        children: List.generate(messages.length, (index) {
                          bool isFromSignedInUser = false;
                          Message message = messages[index];
                          if (message.fromId == widget.currentUserId) {
                            isFromSignedInUser = true;
                          }
                          return Row(
                            mainAxisAlignment: isFromSignedInUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: <Widget>[
                              BubbleWrapper(
                                isFromSignedInUser: isFromSignedInUser,
                                message: message,
                                currentUserName: widget.currentUserName,
                                showCurrentUserName: widget.showCurrentUserName,
                                showCurrentUserProfilePicture:
                                    widget.showCurrentUserProfilePicture,
                                showOtherUserName: widget.showOtherUserName,
                                showOtherUserProfilePicture:
                                    widget.showOtherUserProfilePicture,
                                child: message.contentType ==
                                        ContentType.text.toString()
                                    ? TextMessageBubble(
                                        message: message,
                                        isFromSignedInUser: isFromSignedInUser,
                                      )
                                    : message.contentType ==
                                            ContentType.image.toString()
                                        ? ImageMessageBubble(
                                            message: message,
                                            isFromSignedInUser:
                                                isFromSignedInUser,
                                            messageProvider:
                                                widget.messageProvider,
                                          )
                                        : VideoMessageBubble(
                                            message: message,
                                            isFromSignedInUser:
                                                isFromSignedInUser,
                                            messageProvider:
                                                widget.messageProvider,
                                          ),
                              ),
                              Visibility(
                                visible: message.messageStatus != null &&
                                    message.messageStatus ==
                                        MessageStatus.UPLOADING,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          kCoolLightGreenBlue),
                                      strokeWidth: 4.0,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: message.messageStatus != null &&
                                    message.messageStatus ==
                                        MessageStatus.FAILED,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      MaterialIcons.error,
                                      color: kErrorRed,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: maxNumberOfLines,
                      controller: _textEditingController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      style: TextStyle(
                        fontFamily: kFontFamily,
                        color: kCoolBlack,
                        fontSize: 18,
                      ),
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  InkWell(
                    onTap: () => _onAddAttachmentClicked(context),
                    child: Container(
                      margin: EdgeInsets.only(right: 16),
                      child: Icon(
                        MaterialIcons.add,
                        size: 40,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _onSendMessageClicked,
                    child: Container(
                      margin: EdgeInsets.only(right: 16),
                      child: CircleAvatar(
                        backgroundColor: kCoolLightGreenBlue,
                        radius: 20,
                        child: Center(
                          child: Icon(
                            MaterialIcons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  loadInitialMessages() async {
    List<Message> initialMessages =
        await widget.messageProvider.fetchInitialMessages();
    this.messages = initialMessages;
    if (initialMessages.length < MessageProvider.LIMIT) {
      _controller.loadNoData();
    }
    setState(() {});
    widget.messageProvider.setUpLiveClient(widget.currentUserId, onNewMessage);
    loadVideoThumbnails(initialMessages);
  }

  onNewMessage(List<Message> messages) {
    this.messages.insertAll(0, messages);
    setState(() {});
    loadVideoThumbnails(messages);
  }

  loadVideoThumbnails(List<Message> messages) {
    for (Message message in messages) {
      if (message.contentType == ContentType.video.toString()) {
        _loadVideoThumbnailFor(message);
      }
    }
  }

  Future<void> _loadVideoThumbnailFor(Message message) async {
    String videoUrl = widget.messageProvider.getFileUrl(message.contentFile);
    final bytes = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
    //TODO: Is is inefficient?
    setState(() {
      message.videoThumbnail = bytes;
    });
  }

  void _onLoading() async {
    try {
      List<Message> messages = await loadOldMessages();
      if (messages.length == 0 || messages.length < MessageProvider.LIMIT) {
        _controller.loadNoData();
      } else {
        _controller.loadComplete();
      }
    } catch (e) {
      print(e);
      _controller.loadFailed();
    }
  }

  Future<List<Message>> loadOldMessages() async {
    List<Message> oldMessages = await widget.messageProvider.fetchOldMessages();
    this.messages.addAll(oldMessages);
    setState(() {});
    loadVideoThumbnails(oldMessages);
    return oldMessages;
  }

  _onAddAttachmentClicked(context) async {
    Size size = MediaQuery.of(context).size;

    await showModalBottomSheet(
      context: context,
      builder: (context) => AddAttachmentModalSheet(size, _onFileSelected),
      isScrollControlled: true,
    );

    if (uploadFile != null) {
      Message message = widget.messageProvider.createMessage();

      setState(() {
        message.messageStatus = MessageStatus.UPLOADING;
        messages.insert(0, message);
      });

      try {
        message.fromId = widget.currentUserId;
        message.fromName = widget.currentUserName;
        message.fromProfilePicture = widget.currentUserProfilePicture;
        message.contentType = uploadFileType.toString();

        Object contentFile =
            await widget.messageProvider.getFileObject(uploadFile);
        message.contentFile = contentFile;

        uploadFile = null;

        await widget.messageProvider.sendMessage(message);

        setState(() {
          message.messageStatus = MessageStatus.SUCCESS;
        });

        if (uploadFileType.toString() == ContentType.video.toString()) {
          loadVideoThumbnails([message]);
        }
      } catch (e) {
        print('Failed to send message');
        setState(() {
          message.messageStatus = MessageStatus.FAILED;
        });
      }
    }
  }

  File uploadFile;
  ContentType uploadFileType;

  _onFileSelected(File file, ContentType uploadFileType) {
    uploadFile = file;
    this.uploadFileType = uploadFileType;
  }

  _onSendMessageClicked() async {
    String messageContent = _textEditingController.text;
    if (messageContent.isEmpty || messageContent.trim().isEmpty) {
      return;
    }

    _textEditingController.clear();
    maxNumberOfLines = 1;

    Message message = widget.messageProvider.createMessage();

    try {
      message.contentType = ContentType.text.toString();
      message.contentText = messageContent;
      message.fromId = widget.currentUserId;
      message.fromName = widget.currentUserName;
      message.fromProfilePicture = widget.currentUserProfilePicture;

      setState(() {
        message.messageStatus = MessageStatus.UPLOADING;
        messages.insert(0, message);
      });

      await widget.messageProvider.sendMessage(message);
      setState(() {
        message.messageStatus = MessageStatus.SUCCESS;
      });
    } catch (e) {
      print('Failed to send message');
      setState(() {
        message.messageStatus = MessageStatus.FAILED;
      });
    }
  }
}
