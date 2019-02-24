import 'package:flutter/material.dart';

abstract class BaseModalScreenState extends State {
  void onSavePressed();
  Widget buildBody();
  String get title;
  bool get isSaveEnabled;

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

  IconButton buildIconButton(BuildContext context, _Action action) {
    switch (action) {
      case _Action.close:
        return IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      case _Action.save:
        return IconButton(
          icon: Icon(Icons.save),
          onPressed: isSaveEnabled ? onSavePressed : null,
        );
      default:
        throw Exception('_Action enum exausted.');
    }
  }
}

enum _Action { close, save }
