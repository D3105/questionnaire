import 'package:flutter/material.dart';

abstract class BaseModalScreenState extends State {
  Future<void> onSavePressed();
  Widget buildBody();
  String get title;
  bool get isSaveEnabled;
  var saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: buildIconButton(context, _Action.close),
        actions: <Widget>[
          buildIconButton(context, _Action.save),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildIconButton(BuildContext context, _Action action) {
    switch (action) {
      case _Action.close:
        return IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      case _Action.save:
        return saving
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                  height: 25,
                  width: 25,
                  margin: EdgeInsets.only(right: 8),
                ),
              )
            : IconButton(
                icon: Icon(Icons.save),
                onPressed: isSaveEnabled
                    ? () async {
                        setState(() {
                          saving = true;
                        });
                        await onSavePressed();
                        Navigator.pop(context);
                      }
                    : null,
              );
      default:
        throw Exception('_Action enum exausted.');
    }
  }
}

enum _Action { close, save }
