import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/models/user.dart';

class ProfilePhoto extends StatelessWidget {
  final User user;

  const ProfilePhoto({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user.photoUrl != null) {
      return CachedNetworkImage(
        height: 100,
        width: 100,
        imageUrl: user.photoUrl,
        errorWidget: (context, url, e) => Icon(Icons.error),
        placeholder: (context, url) => CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.yellow),
            ),
        imageBuilder: (context, imageProvider) {
          return CircleAvatar(
            backgroundImage: imageProvider,
          );
        },
      );
    }
    final abbreviation =
        user.name.split(' ').map((word) => word[0].toUpperCase()).join();
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.primaries[user.color],
      child: Text(
        abbreviation,
        style: TextStyle(
          fontSize: 31,
        ),
      ),
    );
  }
}
