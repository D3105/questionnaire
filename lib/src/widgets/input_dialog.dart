import 'package:flutter/material.dart';

Future<String> showInputDialog(BuildContext context, String title,
    [String initialValue = '']) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      var isInputValid = true;
      final controller = TextEditingController.fromValue(
        TextEditingValue(
          text: initialValue,
          selection: TextSelection.collapsed(
            offset: initialValue.length,
          ),
        ),
      );

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                errorText: isInputValid ? null : 'Field must not be empty.',
              ),
              onChanged: (input) {
                setState(() {
                  isInputValid = input.isNotEmpty;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(initialValue.isEmpty ? 'ADD' : 'SAVE'),
                onPressed: isInputValid && controller.text.isNotEmpty
                    ? () {
                        Navigator.pop(context, controller.text);
                      }
                    : null,
              ),
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    },
  );
}
