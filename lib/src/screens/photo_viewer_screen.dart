import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/helper/firebase_storage.dart';
import 'package:questionnaire/src/models/user.dart';
import 'package:share/share.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/services.dart';

class PhotoViewerScreen extends StatefulWidget {
  final String url;
  final UserType userType;

  const PhotoViewerScreen({Key key, this.url, this.userType}) : super(key: key);

  @override
  _PhotoViewerScreenState createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  var isAppBarVisible = true;
  String url;

  @override
  void initState() {
    super.initState();

    url = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);
    return StreamBuilder<User>(
      stream: bloc.streamFor(widget.userType),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return buildScreen(bloc);
      },
    );
  }

  Widget buildScreen(UserBloc bloc) {
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

    final body = GestureDetector(
      child: photoView,
      onTap: () {
        setState(() {
          isAppBarVisible = !isAppBarVisible;
        });
      },
    );

    var children = <Widget>[body];

    if (isAppBarVisible) {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      final iconButtons = actions
          .map((action) => buildIconButton(action, context, scaffoldKey, bloc))
          .toList();
      children.add(buildAppBar(context, iconButtons, appBarColor));
    } else {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      key: scaffoldKey,
      body: Stack(
        children: children,
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
      GlobalKey<ScaffoldState> scaffoldKey, UserBloc bloc) {
    switch (action) {
      case _Action.library:
        return IconButton(
          icon: Icon(Icons.photo_library),
          onPressed: () {
            pickPhoto(bloc, ImageSource.gallery);
          },
        );
      case _Action.camera:
        return IconButton(
          icon: Icon(Icons.photo_camera),
          onPressed: () {
            pickPhoto(bloc, ImageSource.camera);
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
                    success ? 'Image downloaded successfully.' : 'Failed.'),
              ),
            );
          },
        );
      case _Action.delete:
        return IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDeleteDialog(bloc);
          },
        );
      default:
        throw Exception('_Action enum exhausted.');
    }
  }

  void showDeleteDialog(UserBloc bloc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you really want to delete image?'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                bloc.deletePhoto(widget.userType);
                setState(() {
                  url = null;
                });
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
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

  Future pickPhoto(UserBloc bloc, ImageSource source) async {
    final photo = await ImagePicker.pickImage(
      source: source,
    );
    if (photo == null) return;
    bloc.pendingPhoto(widget.userType);
    final uid = bloc.lastUser(widget.userType).uid;
    final photoUrl = await uploadFile(photo, uid);
    final user = bloc.lastUser(widget.userType);
    user.photoUrl = photoUrl;
    bloc.updateUser(widget.userType, user);
    setState(() {
      url = photoUrl;
    });
  }
}

enum _Action { library, camera, share, download, delete }
