import 'dart:math';

import 'package:flutter/material.dart';
import 'package:questionnaire/src/screens/base/base_modal_screen_state.dart';
import 'package:questionnaire/src/widgets/input_dialog.dart';
import '../mixins/authentication_fields.dart';

class QuestionnaireEditScreen extends StatefulWidget {
  @override
  _QuestionnaireEditScreenState createState() =>
      _QuestionnaireEditScreenState();
}

class _QuestionnaireEditScreenState extends BaseModalScreenState
    with AuthenticationFields {
  var questionPanelsData = <_PanelData>[];
  var resultPanelsData = <_PanelData>[];

  var isNameValid = true;
  var isAboutValid = true;

  final nameController = TextEditingController();
  final aboutController = TextEditingController();

  @override
  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildNameTextField(
              nameController,
              isNameValid,
              (isValid) {
                isNameValid = isValid;
              },
            ),
            buildAboutTextField(
              aboutController,
              isAboutValid,
              (isValid) {
                isAboutValid = isValid;
              },
            ),
            buildPanelListTitle(questionPanelsData, _PanelType.question),
            buildPanelList(questionPanelsData, _PanelType.question),
            buildPanelListTitle(resultPanelsData, _PanelType.result),
            buildPanelList(resultPanelsData, _PanelType.result),
          ],
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Widget buildPanelListTitle(List<_PanelData> panelsData, _PanelType type) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 21),
      child: Stack(
        overflow: Overflow.visible,
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Positioned(
            child: RaisedButton.icon(
              color: Colors.blue,
              textColor: Colors.white,
              icon: Icon(Icons.add),
              label: Text('Add'),
              onPressed: () async {
                final input =
                    await showInputDialog(context, 'Add ${type.name}');
                if (input == null) return;
                setState(() {
                  panelsData.forEach((panelData) => panelData.isExpanded =
                      false); //temporarily fixing bug #13780
                  panelsData.add(_PanelData(input, type));
                });
              },
            ),
            right: 0,
          ),
          Text(
            '${type.name}s',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget buildPanelBodyPlaceholder(String purpose) {
    return Text(
      purpose,
      style: TextStyle(color: Colors.grey),
    );
  }

  Widget buildPanelActionButton(_PanelAction action, _PanelData panelData,
      _PanelType type, List<_PanelData> panelsData) {
    String text;
    void Function() onPressed;
    Color color = Colors.blue;

    switch (action) {
      case _PanelAction.add:
        text = 'ADD';
        onPressed = () async {
          final alternative = await showInputDialog(context, 'Add Alternative');
          if (alternative == null) return;
          setState(() {
            panelData.alternatives.add(_Alternative(alternative));
          });
        };
        break;
      case _PanelAction.edit:
        text = 'EDIT';
        onPressed = () async {
          final title = await showInputDialog(
              context, 'Edit ${type.name}', panelData.title);
          if (title == null) return;
          setState(() {
            panelData.title = title;
          });
        };
        break;
      case _PanelAction.delete:
        text = 'DELETE';
        color = Colors.red;
        onPressed = () {
          setState(() {
            panelsData.remove(panelData);
          });
        };
        break;
    }

    return FlatButton(
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
      onPressed: onPressed,
    );
  }

  List<Widget> buildWrapQuestionChildren(_PanelData panelData) {
    return panelData.alternatives.map(
      (alternative) {
        return Chip(
          label: Text(alternative.name),
          backgroundColor: alternative.color,
          onDeleted: () {
            setState(() {
              panelData.alternatives.remove(alternative);
            });
          },
        );
      },
    ).toList();
  }

  List<Widget> buildWrapResultChildren(
      _PanelData questionPanelData, _PanelData resultPanelData) {
    return questionPanelData.alternatives.map((alternative) {
      return InputChip(
        selected: alternative.selectedIn.contains(resultPanelData),
        label: Text(alternative.name),
        selectedColor: alternative.color,
        onSelected: (isSelected) {
          setState(() {
            if (isSelected) {
              alternative.selectedIn.add(resultPanelData);
            } else {
              alternative.selectedIn.remove(resultPanelData);
            }
          });
        },
      );
    }).toList();
  }

  List<Widget> buildWrapsResultList(_PanelData panelData) {
    return questionPanelsData
        .map(
          (questionPanelData) {
            return [
              SizedBox(height: 8),
              Text(questionPanelData.title),
              SizedBox(height: 8),
              questionPanelData.alternatives.isNotEmpty
                  ? buildWrappedChips(
                      questionPanelData, _PanelType.result, panelData)
                  : buildPanelBodyPlaceholder('Alternatives will appear here.'),
              SizedBox(height: 8),
              Divider(height: 0),
            ];
          },
        )
        .expand((list) => list)
        .toList();
  }

  //pass resultPanelData if panel type == result
  Widget buildWrappedChips(_PanelData questionPanelData, _PanelType type,
      [_PanelData resultPanelData]) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: -8,
        children: type == _PanelType.question
            ? buildWrapQuestionChildren(questionPanelData)
            : buildWrapResultChildren(questionPanelData, resultPanelData),
      ),
    );
  }

  Widget buildButtonBar(_PanelData panelData, List<_PanelAction> actions,
      _PanelType type, List<_PanelData> panelsData) {
    final children = actions.map(
      (action) {
        return buildPanelActionButton(action, panelData, type, panelsData);
      },
    ).toList();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      ),
      margin: EdgeInsets.only(right: 8),
    );
  }

  Widget buildPanelBody(_PanelData panelData) {
    switch (panelData.type) {
      case _PanelType.question:
        return Column(
          children: <Widget>[
            panelData.alternatives.isEmpty
                ? buildPanelBodyPlaceholder('Alternatives will appear here.')
                : buildWrappedChips(panelData, _PanelType.question),
            SizedBox(height: 8),
            Divider(height: 0),
            buildButtonBar(
                panelData,
                [_PanelAction.delete, _PanelAction.edit, _PanelAction.add],
                _PanelType.question,
                questionPanelsData),
          ],
        );
      case _PanelType.result:
        var children = buildWrapsResultList(panelData);
        if (questionPanelsData.isEmpty) {
          children += [
            buildPanelBodyPlaceholder('Firstly add some questions.'),
            SizedBox(height: 8),
            Divider(height: 0),
          ];
        }
        children.add(
          buildButtonBar(panelData, [_PanelAction.delete, _PanelAction.edit],
              _PanelType.result, resultPanelsData),
        );
        return Column(children: children);
      default:
        throw Exception('_PanelType enum exhausted.');
    }
  }

  ExpansionPanel buildPanel(_PanelData panelData) {
    return ExpansionPanel(
      body: buildPanelBody(panelData),
      headerBuilder: (context, isExpanded) {
        String subtitle;
        if (panelData.type == _PanelType.question) {
          subtitle = '${panelData.alternatives.length} alternatives';
        } else {
          final selectedAlternatives = questionPanelsData.map(
            (questionPanelData) {
              return questionPanelData.alternatives.where(
                (alternative) {
                  return alternative.selectedIn.contains(panelData);
                },
              ).length;
            },
          ).fold(
            0,
            (sum, length) {
              return sum + length;
            },
          );
          subtitle = '$selectedAlternatives selected';
        }
        return buildPanelHeader(panelData.title, subtitle, isExpanded);
      },
      isExpanded: panelData.isExpanded,
    );
  }

  Widget buildPanelList(List<_PanelData> panelsData, _PanelType type) {
    if (panelsData.isEmpty) {
      return Text(
        '${type.name}s will appear here.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      );
    }

    var panels = List<ExpansionPanel>();
    for (final panelData in panelsData) {
      panels.add(buildPanel(panelData));
    }

    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          panelsData[index].isExpanded = !isExpanded;
        });
      },
      children: panels,
    );
  }

  Widget buildPanelHeader(String title, String subtitle, bool isExpanded) {
    return ListTile(
      title: Text(title),
      subtitle: isExpanded
          ? null
          : Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
    );
  }

  @override
  bool get isSaveEnabled =>
      isNameValid &&
      isAboutValid &&
      nameController.text.isNotEmpty &&
      questionPanelsData.isNotEmpty &&
      questionPanelsData.every(
        (panelData) {
          return panelData.alternatives.isNotEmpty;
        },
      ) &&
      resultPanelsData.isNotEmpty &&
      questionPanelsData.every(
        (panelData) {
          return panelData.alternatives.every(
            (alternative) {
              return alternative.selectedIn.isNotEmpty;
            },
          );
        },
      );

  @override
  void onSavePressed() {
    Navigator.pop(context);
  }

  @override
  String get title => 'Add Questionnaire';
}

class _PanelData {
  _PanelType type;
  String title;
  var isExpanded = false;
  List<_Alternative> alternatives;

  _PanelData(this.title, this.type) {
    if (type == _PanelType.question) {
      alternatives = <_Alternative>[];
    }
  }
}

class _Alternative {
  String name;
  Color color;
  var selectedIn = Set<_PanelData>();

  _Alternative(this.name) {
    final random = Random().nextInt(Colors.primaries.length);
    color = Colors.primaries[random][200];
  }
}

enum _PanelAction { add, edit, delete }

class _PanelType {
  static const question = _PanelType._('Question');
  static const result = _PanelType._('Result');

  final String name;

  const _PanelType._(this.name);
}
