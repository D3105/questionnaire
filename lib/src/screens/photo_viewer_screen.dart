import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:questionnaire/src/blocs/providers/questionnaire_provider.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/helper/cache.dart';
import 'package:questionnaire/src/helper/firebase.dart';
import 'package:questionnaire/src/models/entity.dart';
import 'package:share/share.dart';
import 'package:image_downloader/image_downloader.dart';

class PhotoViewerScreen extends StatefulWidget {
  final String url;
  final UserType userType;
  final PhotoType photoType;

  const PhotoViewerScreen({Key key, this.url, this.userType, this.photoType})
      : super(key: key);

  @override
  _PhotoViewerScreenState createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  var isAppBarVisible = true;
  String url;

  UserBloc userBloc;
  QuestionnaireBloc questionnaireBloc;

  @override
  void initState() {
    super.initState();

    url = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photoType == PhotoType.userAvatar) {
      userBloc = UserProvider.of(context);
    } else {
      questionnaireBloc = QuestionnaireProvider.of(context);
    }

    return StreamBuilder<Entity>(
      stream: userBloc?.streamFor(widget.userType) ??
          questionnaireBloc.questionnaire,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return buildScreen();
      },
    );
  }

  Widget buildScreen() {
    Color backgroundColor;
    Color appBarColor;
    Widget photoView;
    List<_Action> actions;

    if (url != null) {
      switch (widget.userType) {
        case UserType.primary:
          actions = _Action.values;
          break;
        case UserType.current:
          actions = [_Action.share, _Action.download];
          break;
      }
      backgroundColor = Colors.black;
      appBarColor = Colors.black;
      photoView = PhotoView(
        loadingChild: Center(child:CircularProgressIndicator()),
        imageProvider: CachedNetworkImageProvider(url),
      );
    } else {
      switch (widget.userType) {
        case UserType.primary:
          actions = [_Action.library, _Action.camera];
          break;
        case UserType.current:
          actions = [];
          break;
      }
      backgroundColor = Colors.white;
      appBarColor = Colors.blue;
      photoView = Center(
        child: Text(
          'No image yet.',
        ),
      );
    }

    final scaffoldKey = GlobalKey<ScaffoldState>();
    final appBarKey = GlobalKey();

    final body = GestureDetector(
      child: photoView,
      onTap: () {
        appBarKey.currentState.setState(() {
          isAppBarVisible = !isAppBarVisible;
        });
      },
    );

    final appBar = StatefulBuilder(
      key: appBarKey,
      builder: (context, setState) {
        if (isAppBarVisible) {
          final iconButtons = actions
              .map((action) => buildIconButton(action, context, scaffoldKey))
              .toList();
          return buildAppBar(context, iconButtons, appBarColor);
        }

        return Container(height: 0, width: 0);
      },
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          body,
          appBar,
        ],
      ),
    );
  }

  Widget buildAppBar(
      BuildContext context, List<IconButton> actions, Color appBarColor) {
    return Positioned(
      child: AppBar(
        backgroundColor: appBarColor,
        actions: actions,
      ),
      top: 0,
      left: 0,
      right: 0,
    );
  }

  IconButton buildIconButton(_Action action, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey) {
    switch (action) {
      case _Action.library:
        return IconButton(
          icon: Icon(Icons.photo_library),
          onPressed: () {
            pickPhoto(ImageSource.gallery);
          },
        );
      case _Action.camera:
        return IconButton(
          icon: Icon(Icons.photo_camera),
          onPressed: () {
            pickPhoto(ImageSource.camera);
          },
        );
      case _Action.share:
        return IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            Share.share(url);
          },
        );
      case _Action.download:
        return IconButton(
          icon: Icon(Icons.file_download),
          onPressed: () async {
            final success = await ImageDownloader.downloadImage(url);
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(
                    (success != null) ? 'Image downloaded successfully.' : 'Failed.'),
              ),
            );
          },
        );
      case _Action.delete:
        return IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDeleteDialog();
          },
        );
      default:
        throw Exception('_Action enum exhausted.');
    }
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you really want to delete image?'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                clearPhotoCache();

                userBloc?.deletePhoto(widget.userType) ??
                    questionnaireBloc.deletePhoto();
                setState(() {
                  url = null;
                });
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                'CANCEL',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future pickPhoto(ImageSource source) async {
    final photo = await ImagePicker.pickImage(source: source);
    if (photo == null) return;

    String photoUrl;
    if (widget.photoType == PhotoType.userAvatar) {
      userBloc.pendingPhoto(widget.userType);
      final user = userBloc.lastUser(widget.userType);
      photoUrl = await uploadFile(photo, user.uid);
      user.photoUrl = photoUrl;
      userBloc.updateUser(widget.userType, user);
    } else {
      questionnaireBloc.pendingPhoto();
      final questionnaire = questionnaireBloc.last;
      photoUrl = await uploadFile(photo, questionnaire.uid);
      questionnaire.photoUrl = photoUrl;
      questionnaireBloc.update(questionnaire);
    }

    setState(() {
      url = photoUrl;
    });
  }
}

enum _Action { library, camera, share, download, delete }

enum PhotoType { userAvatar, questionnairePicture }
