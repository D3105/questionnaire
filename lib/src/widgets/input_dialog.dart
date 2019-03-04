import 'package:flutter/material.dart';

Future<String> showInputDialog(
    BuildContext context, String title, List<String> existingValues,
    [String initialValue = '']) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      var isInputNotEmpty = true;
      var isInputUnique = true;
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
          String error;
          if (!isInputNotEmpty) {
            error = 'Field must not be empty.';
          } else if (!isInputUnique) {
            error = 'Item must be unique.';
          }

          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                errorText: error,
              ),
              onChanged: (input) {
                setState(() {
                  isInputNotEmpty = input.isNotEmpty;
                  isInputUnique = !existingValues.contains(input);
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(initialValue.isEmpty ? 'ADD' : 'SAVE'),
                onPressed: isInputNotEmpty &&
                        isInputUnique &&
                        controller.text.isNotEmpty
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
