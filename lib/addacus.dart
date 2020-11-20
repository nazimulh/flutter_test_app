import 'dart:async';
import 'dart:math';

import 'package:flutter_test_app/number_selector_custom_radio.dart';
import 'package:flutter_test_app/skill_selector_custom_radio.dart';
import 'package:flutter_test_app/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'globals.dart' as globals;

class TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ADDACUS',
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: 'Itim',
                        fontWeight: FontWeight.bold,
                        // fontStyle: FontStyle.italic,
                        color: Colors.blue),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class TickCrossWidget extends StatelessWidget {
  final bool showTick;

  TickCrossWidget({Key key, this.showTick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showTick
                    ? Image.asset(
                  'images/tick.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.fill,
                )
                    : Image.asset(
                  'images/cross.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  final StreamController streamController;

  TimerWidget({Key key, this.streamController}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.

  @override
  void initState() {
    super.initState();

    // _stopWatchTimer.rawTime.listen((value) => print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    // _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    // _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    // _stopWatchTimer.records.listen((value) => print('records $value'));

    /// Can be set preset time. This case is "00:01.23".
    _stopWatchTimer.setPresetTime(mSec: globals.stopwatch.elapsedMilliseconds);
    // Start stop watch
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);

    this.widget.streamController
      ..stream.listen((event) {
        setState(() {
          if (event == globals.WidgetEvents.DISPLAY_ANSWERS) {
/*
            if (globals.stopwatch.isRunning) {
              globals.elapsedTimeInMillis +=
                  globals.stopwatch.elapsedMilliseconds;
              print('elapsedTimeInMillis: ' +
                  globals.elapsedTimeInMillis.toString());
              globals.stopwatch.stop();
            }

*/
            _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
          }
          if (event == globals.WidgetEvents.FINISHED_DISPLAY_ANSWERS) {
            globals.stopwatch.start();
            _stopWatchTimer.onExecute.add(StopWatchExecute.start);
          }
        });
      });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(5.0),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.value,
                    builder: (context, snap) {
                      final value = snap.data;
                      final displayTime =
                      StopWatchTimer.getDisplayTime(value, hours: true);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 200,
                            child: Container(
                              padding: EdgeInsets.only(left: 50),
                              child: Text(
                                displayTime,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Itim',
                                  color: Colors.redAccent,
                                  // fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ]),
        ));
  }
}

class ScoreWidget extends StatefulWidget {
  final StreamController streamController;

  ScoreWidget({Key key, this.streamController}) : super(key: key);

  @override
  _ScoreWidgetState createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  @override
  void initState() {
    super.initState();

    this.widget.streamController
      ..stream.listen((event) {
        if (event == globals.WidgetEvents.UPDATE_SCORE) {
          setState(() {});
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
    return Container(
      padding: EdgeInsets.only(left: 25, right: 5, top: 5, bottom: 5),
      // alignment: Alignment.topLeft,
      child: Text(
        'SCORE: ' +
            globals.scoreCount.toString() +
            '/' +
            globals.currentPuzzleCount.toString(),
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Itim',
          color: Colors.orangeAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class QuestionCountAdjustWidget extends StatefulWidget {
  @override
  _QuestionCountAdjustWidgetState createState() =>
      _QuestionCountAdjustWidgetState();
}

class _QuestionCountAdjustWidgetState extends State<QuestionCountAdjustWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.topLeft,
        margin: EdgeInsets.only(left: 25, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Questions: ' +
                    (globals.currentPuzzleCount + 1).toString() +
                    " of " +
                    globals.totalPuzzleCount.toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Itim',
                  // fontWeight: FontWeight.bold,
                  // fontStyle: FontStyle.italic,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(1),
                  child: SizedBox(
                    width: 60,
                    height: 30,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        // color: Colors.lightGreen,
                        elevation: 4,
                        child: Text('+10',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Itim',
                              // fontWeight: FontWeight.bold,
                              // fontStyle: FontStyle.italic,
                            )),
                        onPressed: () {
                          if (globals.totalPuzzleCount <= 990) {
                            setState(() {
                              globals.totalPuzzleCount += 10;
                            });
                          }
                        }),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(1),
                  child: SizedBox(
                    width: 60,
                    height: 30,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        // color: Colors.orange,
                        elevation: 4,
                        child: Text('-10',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Itim',
                              // fontWeight: FontWeight.bold,
                              // fontStyle: FontStyle.italic,
                            )),
                        onPressed: () {
                          if (globals.totalPuzzleCount > 10) {
                            setState(() {
                              globals.totalPuzzleCount -= 10;
                            });
                          }
                        }),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(1),
                  child: SizedBox(
                    width: 70,
                    height: 30,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        // color: Colors.orange,
                        elevation: 4,
                        child: Text('+100',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Itim',
                              // fontWeight: FontWeight.bold,
                              // fontStyle: FontStyle.italic,
                            )),
                        onPressed: () {
                          if (globals.totalPuzzleCount <= 900) {
                            setState(() {
                              globals.totalPuzzleCount += 100;
                            });
                          }
                        }),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(1),
                  child: SizedBox(
                    width: 70,
                    height: 30,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        // color: Colors.orange,
                        elevation: 4,
                        child: Text('-100',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Itim',
                              // fontWeight: FontWeight.bold,
                              // fontStyle: FontStyle.italic,
                            )),
                        onPressed: () {
                          if (globals.totalPuzzleCount > 100) {
                            setState(() {
                              globals.totalPuzzleCount -= 100;
                            });
                          }
                        }),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class BottomWidget extends StatefulWidget {
  final StreamController streamController;

  BottomWidget({Key key, this.streamController}) : super(key: key);

  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  int clickCount, answer;
  bool showKeypad, showTick;

  @override
  void initState() {
    super.initState();
    clickCount = answer = 0;
    showKeypad = true;

    this.widget.streamController
      ..stream.listen((event) {
        if (event == globals.WidgetEvents.UPDATE_PUZZLE_WIDGET) {
          setState(() {});
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
    Color digitButtonColor = Colors.teal; // Color.fromARGB(255, 128, 128, 128);
    TextStyle digitButtonStyle = TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontFamily: 'Itim',
      // fontWeight: FontWeight.bold
    );

    if (!showKeypad) {
      this.widget.streamController.add(globals.WidgetEvents.DISPLAY_ANSWERS);
      if (globals.stopwatch.isRunning) {
        globals.stopwatch.stop();
      }

      // Initialize timer for 3 seconds
      Timer(Duration(seconds: 3), () {
        setState(() {
          showKeypad = true;
          this
              .widget
              .streamController
              .add(globals.WidgetEvents.FINISHED_DISPLAY_ANSWERS);
          globals.stopwatch.start();
        });
      });
    }

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: showKeypad
          ? Container(
        // padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('7', style: digitButtonStyle),
                                  onPressed: () {
                                    checkAnswer(7);
                                  }),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('4', style: digitButtonStyle),
                                  onPressed: () {
                                    checkAnswer(4);
                                  }),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('1', style: digitButtonStyle),
                                  onPressed: () {
                                    checkAnswer(1);
                                  }),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  disabledColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('', style: digitButtonStyle),
                                  onPressed: null),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('8', style: digitButtonStyle),
                                  onPressed: () {
                                    checkAnswer(8);
                                  }),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('5', style: digitButtonStyle),
                                  onPressed: () {
                                    checkAnswer(5);
                                  }),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('2', style: digitButtonStyle),
                                  onPressed: () {
                                    checkAnswer(2);
                                  }),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('0', style: digitButtonStyle),
                                  onPressed: () {
                                    checkAnswer(0);
                                  }),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('9', style: digitButtonStyle),
                                  onPressed: () {
                                    checkAnswer(9);
                                  }),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('6', style: digitButtonStyle),
                                  onPressed: () {
                                    checkAnswer(6);
                                  }),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('3', style: digitButtonStyle),
                                  onPressed: () {
                                    checkAnswer(3);
                                  }),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: RaisedButton(
                                  disabledColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  color: digitButtonColor,
                                  elevation: 4,
                                  child:
                                  Text('', style: digitButtonStyle),
                                  onPressed: null),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )
          : TickCrossWidget(showTick: showTick),
    );
  }

  void checkAnswer(int digit) {
    int leftSum, midSum, rightSum, result;
    leftSum = midSum = rightSum = result = 0;
    for (var num in globals.numberList) {
      leftSum += (num >= 5) ? 5 : 0;
      midSum += num;
      rightSum += (num >= 5) ? num - 5 : num;
    }

    switch (globals.selectedSkill) {
      case 'LEFT':
        result = leftSum;
        break;
      case 'RIGHT':
        result = rightSum;
        break;
      case 'ROOT':
        result = (midSum % 10) % 5;
        break;
      case 'TOTAL':
      default:
        result = midSum;
        break;
    }

    clickCount++;
    answer += pow(10, clickCount % 2) * digit;

    if (clickCount == 1) {
      if (digit == result) {
        setState(() {
          globals.currentPuzzleCount++;
          globals.scoreCount++;
          showKeypad = false;
          showTick = true;
          clickCount = 0;
          answer = 0;
        });
        this.widget.streamController.add(globals.WidgetEvents.UPDATE_SCORE);
      }
    } else if (clickCount >= 2) {
      print('Your answer: $answer');
      globals.currentPuzzleCount++;
      setState(() {
        showKeypad = false;

        if (answer == result) {
          showTick = true;
          globals.scoreCount++;
        } else {
          showTick = false;
        }
        clickCount = 0;
        answer = 0;
      });
      this.widget.streamController.add(globals.WidgetEvents.UPDATE_SCORE);
    }
  }
}

class PuzzleWidget extends StatefulWidget {
  final StreamController streamController;

  PuzzleWidget({Key key, this.streamController}) : super(key: key);

  @override
  _PuzzleWidgetState createState() => _PuzzleWidgetState();
}

class _PuzzleWidgetState extends State<PuzzleWidget>
    with TickerProviderStateMixin {
  List<int> numberList;
  bool newPuzzle, showAnswers;

  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    newPuzzle = true;
    showAnswers = false;

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..forward();

    _animation = Tween<Offset>(
      begin: const Offset(-10.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));

    this.widget.streamController
      ..stream.listen((event) {
        if (event == globals.WidgetEvents.DISPLAY_ANSWERS) {
          setState(() {
            newPuzzle = false;
            showAnswers = true;
          });
        } else if (event == globals.WidgetEvents.UPDATE_PUZZLE_WIDGET) {
          setState(() {
            newPuzzle = true;
            showAnswers = false;
          });
        } else {
          newPuzzle = true;
          showAnswers = false;
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PuzzleWidget oldWidget) {
    _controller.reset();
    _controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    int leftSum, midSum, rightSum;
    leftSum = midSum = rightSum = 0;
    if (!globals.startApp) {
      if (newPuzzle) {
        generatePuzzle();
      }
      for (var num in this.numberList) {
        leftSum += (num >= 5) ? 5 : 0;
        midSum += num;
        rightSum += (num >= 5) ? num - 5 : num;
      }
    }

    return globals.startApp
        ? SizedBox.shrink()
        : Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var num in this.numberList)
                  Visibility(
                    visible:
                    showAnswers && globals.puzzleNumberValueMax > 4,
                    child: Text(num >= 5 ? '5' : '',
                        style: TextStyle(
                          fontSize: 22, color: Colors.red,
                          fontFamily: 'Itim',
                          // fontWeight: FontWeight.bold,
                          // fontStyle: FontStyle.italic,
                        )),
                  ),
                Visibility(
                    visible:
                    showAnswers && globals.puzzleNumberValueMax > 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Divider(
                          color: Colors.red,
                          thickness: 1,
                        ),
                        Text('$leftSum',
                            style: TextStyle(
                              fontSize: 22, color: Colors.red,
                              fontFamily: 'Itim',
                              fontWeight: FontWeight.bold,
                              // fontStyle: FontStyle.italic,
                            )),
                      ],
                    )),
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var num in this.numberList)
                  Text('$num',
                      style: TextStyle(
                        fontSize: 22, color: Colors.black,
                        fontFamily: 'Itim',
                        // fontWeight: FontWeight.bold,
                        // fontStyle: FontStyle.italic,
                      )),
                Visibility(
                    visible: showAnswers,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        Text('$midSum',
                            style: TextStyle(
                              fontSize: 22, color: Colors.black,
                              fontFamily: 'Itim',
                              // fontWeight: FontWeight.bold,
                              // fontStyle: FontStyle.italic,
                            )),
                      ],
                    )),
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var num in this.numberList)
                  Visibility(
                    visible:
                    showAnswers && globals.puzzleNumberValueMax > 4,
                    child: Text(num >= 5 ? (num - 5).toString() : '$num',
                        style: TextStyle(
                          fontSize: 22, color: Colors.green,
                          fontFamily: 'Itim',
                          // fontWeight: FontWeight.bold,
                          // fontStyle: FontStyle.italic,
                        )),
                  ),
                Visibility(
                    visible:
                    showAnswers && globals.puzzleNumberValueMax > 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Divider(
                          color: Colors.green,
                          thickness: 1,
                        ),
                        Text('$rightSum',
                            style: TextStyle(
                              fontSize: 22, color: Colors.green,
                              fontFamily: 'Itim',
                              fontWeight: FontWeight.bold,
                              // fontStyle: FontStyle.italic,
                            )),
                      ],
                    )),
              ],
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  void generatePuzzle() {
    final _random = Random();
    int next(int min, int max) => min + _random.nextInt(max - min);
    this.numberList = List<int>.generate(globals.puzzleDigitCount,
            (index) => next(0, globals.puzzleNumberValueMax));
    globals.numberList = this.numberList;
    print("Puzzle: " + this.numberList.toString());
  }
}

class MyAddacusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Addacus App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: AddacusApp(title: 'Addacus App'),
    );
  }
}

class AddacusApp extends StatefulWidget {
  AddacusApp({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddacusAppState createState() => _AddacusAppState();
}

class _AddacusAppState extends State<AddacusApp> {
  final StreamController<globals.WidgetEvents> streamController =
  StreamController<globals.WidgetEvents>.broadcast();

  @override
  void initState() {
    super.initState();

    initializeGlobals();

    this.streamController
      ..stream.listen((event) {
        if (event == globals.WidgetEvents.FINISHED_DISPLAY_ANSWERS ||
            event == globals.WidgetEvents.START_APP) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    streamController.close();
    if (globals.stopwatch.isRunning) {
      globals.stopwatch.stop();
    }
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Elapsed time: " + globals.stopwatch.elapsedMilliseconds.toString());
    Widget digitAdjustButtonSection = Container(
      // alignment: Alignment.topLeft,
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Digits:' + globals.puzzleDigitCount.toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Itim',
                  // fontWeight: FontWeight.bold,
                  // fontStyle: FontStyle.italic,
                )),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(1),
              child: SizedBox(
                width: 60,
                height: 30,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: Colors.lightBlue,
                    elevation: 4,
                    child: Text('+',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Itim',
                          // fontWeight: FontWeight.bold,
                          // fontStyle: FontStyle.italic,
                        )),
                    onPressed: () {
                      if (globals.puzzleDigitCount < 10) {
                        setState(() {
                          globals.puzzleDigitCount++;
                          globals.startApp = true;
                        });
                        this
                            .streamController
                            .add(globals.WidgetEvents.UPDATE_PUZZLE_WIDGET);
                      }
                    }),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(1),
              child: SizedBox(
                width: 60,
                height: 30,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: Colors.lime,
                    elevation: 4,
                    child: Text('-',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Itim',
                          // fontWeight: FontWeight.bold,
                          // fontStyle: FontStyle.italic,
                        )),
                    onPressed: () {
                      if (globals.puzzleDigitCount > 2) {
                        setState(() {
                          globals.puzzleDigitCount--;
                          globals.startApp = true;
                        });
                        this
                            .streamController
                            .add(globals.WidgetEvents.UPDATE_PUZZLE_WIDGET);
                      }
                    }),
              ),
            ),
          ],
        ));

    Widget numberAdjustButtonSection = Container(
      // alignment: Alignment.topLeft,
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Numbers',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Itim',
                  // fontWeight: FontWeight.bold,
                  // fontStyle: FontStyle.italic,
                )),
            NumberSelectorCustomRadioWidget(
              streamController: this.streamController,
            ),
          ],
        ));

    Widget skillSelectorButtonSection = Container(
      // alignment: Alignment.topLeft,
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Text('Skill',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Itim',
                // fontWeight: FontWeight.bold,
                // fontStyle: FontStyle.italic,
              )),
          SkillSelectorCustomRadioWidget(
              streamController: this.streamController),
        ],
      ),
    );

    Widget gameOverWidget = Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      padding: EdgeInsets.only(top: 50),
      child: Center(
        child: SafeArea(
          minimum: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Game Over !!',
                style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'Itim',
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    color: Colors.orange),
                // textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Score: ' +
                    globals.scoreCount.toString() +
                    "/" +
                    globals.currentPuzzleCount.toString(),
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Itim',
                    // fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              Text(
                "Time: " +
                    _millisecondToTimeDurationString(
                        globals.stopwatch.elapsedMilliseconds),
                // globals.stopwatch.elapsed.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Itim',
                    // fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 180,
                  height: 50,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      color: Colors.lime,
                      elevation: 4,
                      child: Text('Play Again',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black54,
                            fontFamily: 'Itim',
                            // fontWeight: FontWeight.bold,
                            // fontStyle: FontStyle.italic,
                          )),
                      onPressed: () {
                        setState(() {
                          initializeGlobals();
                        });
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget gameRunningWidget = Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Center(
            child: SafeArea(
              minimum: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TitleWidget(),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: skillSelectorButtonSection,
                                  flex: 1,
                                ),
                                Expanded(
                                  child: PuzzleWidget(
                                      streamController: this.streamController),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      digitAdjustButtonSection,
                                      numberAdjustButtonSection,
                                      // skillSelectorButtonSection
                                    ],
                                  ),
                                  flex: 1,
                                ),
                              ]),
                        ),
                        globals.startApp
                            ? SizedBox.shrink()
                            : QuestionCountAdjustWidget(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // digitAdjustButtonSection,
                                  globals.startApp
                                      ? SizedBox.shrink()
                                      : ScoreWidget(
                                      streamController: this.streamController),
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // numberAdjustButtonSection,
                                  globals.startApp
                                      ? SizedBox.shrink()
                                      : TimerWidget(
                                      streamController: this.streamController),
                                ],
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                    // flex: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            globals.startApp
                                ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(20),
                              child: SizedBox(
                                width: 100,
                                height: 40,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(16)),
                                    color: Colors.lightGreen,
                                    elevation: 4,
                                    child: Text('START',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          // fontStyle: FontStyle.italic,
                                        )),
                                    onPressed: () {
                                      setState(() {
                                        resetGlobals();
                                      });
                                    }),
                              ),
                            )
                                : BottomWidget(
                                streamController: this.streamController),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )));

    return Scaffold(
      extendBody: true,
      body: globals.currentPuzzleCount < globals.totalPuzzleCount
          ? gameRunningWidget
          : gameOverWidget,
    );
  }

  String _millisecondToTimeDurationString(int elapsedTimeInMillisecond) {
    String time = '';
    int oneDay = 24 * 3600 * 1000;
    int oneHour = 3600 * 1000;
    int oneMinute = 60 * 1000;
    int oneSecond = 1000;
    int days = (elapsedTimeInMillisecond / oneDay).floor();
    int hours = ((elapsedTimeInMillisecond % oneDay) / oneHour).floor();
    int minutes =
    (((elapsedTimeInMillisecond % oneDay) % oneHour) / oneMinute).floor();
    int seconds =
    ((((elapsedTimeInMillisecond % oneDay) % oneHour) % oneMinute) /
        oneSecond)
        .floor();

    time += days > 0 ? days.toString() + ' days ' : '';
    time += hours > 0 ? hours.toString() + ' hours ' : '';
    time += minutes > 0 ? minutes.toString() + ' minutes ' : '';
    time += seconds > 0 ? seconds.toString() + ' seconds ' : '';
    return time;
  }

  void initializeGlobals() {
    globals.totalPuzzleCount = 10;
    globals.currentPuzzleCount = 0;
    globals.scoreCount = 0;
    globals.stopwatch = Stopwatch();
    globals.puzzleDigitCount = 10;
    globals.puzzleNumberValueMax = 9;
    globals.startApp = true;
  }

  void resetGlobals() {
    globals.totalPuzzleCount = 10;
    globals.currentPuzzleCount = 0;
    globals.scoreCount = 0;
    // globals.stopwatch = Stopwatch();
    if (globals.stopwatch.isRunning) {
      globals.stopwatch.reset();
    } else {
      globals.stopwatch.start();
    }
    // globals.puzzleDigitCount = 10;
    // globals.puzzleNumberValueMax = 9;
    globals.startApp = false;
  }
}
