import 'dart:async';

import 'package:flutter/material.dart';

import 'globals.dart' as globals;

class SkillSelectorCustomRadioWidget extends StatefulWidget {
  final StreamController streamController;

  SkillSelectorCustomRadioWidget({Key key, this.streamController})
      : super(key: key);

  @override
  createState() => _SkillSelectorCustomRadioWidgetState();
}

class _SkillSelectorCustomRadioWidgetState
    extends State<SkillSelectorCustomRadioWidget> {
  List<RadioModel> sampleData = new List<RadioModel>();

  @override
  void initState() {
    super.initState();

    prepareSampleData();

    this.widget.streamController
      ..stream.listen((event) {
        if (event == globals.WidgetEvents.UPDATE_SKILL_SELECTOR) {
          setState(() {
            prepareSampleData();
          });
        }
      });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: sampleData.length,
      itemBuilder: (BuildContext context, int index) {
        return new InkWell(
          // highlightColor: Colors.red,
          // splashColor: Colors.blueAccent,
          onTap: () {
            if (!sampleData[index].isSelected) {
              setState(() {
                sampleData.forEach((element) => element.isSelected = false);
                sampleData[index].isSelected = true;
                globals.selectedSkill = sampleData[index].buttonText;
              });
              globals.startApp = true;
              this.widget.streamController.add(globals.WidgetEvents.START_APP);
            }
          },
          child: new RadioItem(sampleData[index]),
        );
      },
    );
  }

  void prepareSampleData() {
    if (sampleData.isNotEmpty) {
      sampleData.clear();
    }
    if (globals.puzzleNumberValueMax > 4) {
      sampleData.add(new RadioModel(false, 'LEFT'));
      sampleData.add(new RadioModel(false, 'RIGHT'));
    }
    sampleData.add(new RadioModel(false, 'ROOT'));
    sampleData.add(new RadioModel(true, 'TOTAL'));
    globals.selectedSkill = 'TOTAL';
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(5.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 30.0,
            width: 60.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      fontFamily: 'Itim',
                      //fontWeight: FontWeight.bold,
                      fontSize: 14.0)),
            ),
            decoration: new BoxDecoration(
              color: (_item.isSelected && _item.buttonText == 'LEFT')
                  ? Colors.redAccent
                  : (_item.isSelected && _item.buttonText == 'RIGHT')
                      ? Colors.greenAccent
                      : (_item.isSelected && _item.buttonText == 'ROOT')
                          ? Colors.orangeAccent
                          : (_item.isSelected && _item.buttonText == 'TOTAL')
                              ? Colors.purpleAccent
                              : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: (_item.isSelected && _item.buttonText == 'LEFT')
                      ? Colors.redAccent
                      : (_item.isSelected && _item.buttonText == 'RIGHT')
                          ? Colors.greenAccent
                          : (_item.isSelected && _item.buttonText == 'ROOT')
                              ? Colors.orangeAccent
                              : (_item.isSelected &&
                                      _item.buttonText == 'TOTAL')
                                  ? Colors.purpleAccent
                                  : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}
