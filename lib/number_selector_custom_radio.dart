import 'dart:async';

import 'package:flutter_test_app/globals.dart' as globals;
import 'package:flutter/material.dart';

class NumberSelectorCustomRadioWidget extends StatefulWidget {
  final StreamController streamController;

  NumberSelectorCustomRadioWidget({Key key, this.streamController})
      : super(key: key);

  @override
  _NumberSelectorCustomRadioWidgetState createState() =>
      _NumberSelectorCustomRadioWidgetState();
}

class _NumberSelectorCustomRadioWidgetState
    extends State<NumberSelectorCustomRadioWidget> {
  List<RadioModel> sampleData = new List<RadioModel>();

  @override
  void initState() {
    super.initState();
    sampleData.add(new RadioModel(false, 4, '<5'));
    sampleData.add(new RadioModel(true, 9, '<10'));
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
                globals.puzzleNumberValueMax = sampleData[index].numberValueMax;
                globals.startApp = true;
                this
                    .widget
                    .streamController
                    .add(globals.WidgetEvents.UPDATE_SKILL_SELECTOR);
                this
                    .widget
                    .streamController
                    .add(globals.WidgetEvents.START_APP);
              });
            }
          },
          child: new RadioItem(sampleData[index]),
        );
      },
    );
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
              color: (_item.isSelected && _item.numberValueMax == 4)
                  ? Colors.lightGreen
                  : (_item.isSelected && _item.numberValueMax == 9)
                      ? Colors.orange
                      : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: (_item.isSelected && _item.numberValueMax == 4)
                      ? Colors.lightGreen
                      : (_item.isSelected && _item.numberValueMax == 9)
                          ? Colors.orange
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
  int numberValueMax;
  final String buttonText;

  RadioModel(this.isSelected, this.numberValueMax, this.buttonText);
}
