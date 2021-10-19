import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Clock());
}

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  int seconds = 0;

  void changeSeconds(String time) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
          seconds = int.parse(time);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.orange,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Input(setTime: changeSeconds),
                Counter( max : seconds)
              ],
            )));
  }
}

class Counter extends StatefulWidget {
  final int max;
  const Counter({Key? key, this.max = 0})
      : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late int max;
  late int seconds1 = max;
  late int seconds2 = max;
  Timer? timer1;
  Timer? timer2;
  bool ?start;
  bool ?isrunning;
  @override
  void initState() {
    super.initState();
    start = true;
    isrunning = true;
  }
  void startTimer1({bool reset = true}) {
    if (reset) {
      resetTimer1();
    }
    timer1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds1 > 0) {
        setState(() {
          seconds1--;
        });
      } else {
        timer1!.cancel();
      }
    });
  }

  void stopTimer1({reset = false}) {
    if (reset) {
      resetTimer1();
    }
    timer1?.cancel();
  }

  void resetTimer1() {
    setState(() {
      seconds1 = max;
    });
  }
  void startTimer2({bool reset = true}) {
    if (reset) {
      resetTimer2();
    }
    timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds2 > 0) {
        setState(() {
          seconds2--;
        });
      } else {
        timer2!.cancel();
      }
    });
  }

  void stopTimer2({reset = false}) {
    if (reset) {
      resetTimer2();
    }
    timer2?.cancel();
  }

  void resetTimer2() {
    setState(() {
      seconds2 = max;
    });
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      max = widget.max;
    });

    
    
    return SizedBox(
      height: 100,
      width: 100,
      child: TextButton(
          onPressed: () {

            if(start!){
              startTimer1();
              setState(() {
                start = false;
              });
            }
            else if (isrunning!) {
              stopTimer1(reset: false);
              startTimer2(reset: seconds2 == 0);
              setState(() {
                isrunning = !isrunning!;
              });
            } else {
              startTimer1(reset: seconds1 == 0);
              stopTimer2(reset: false);
              setState(() {
                isrunning = !isrunning!;
              });
            }         
          },
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [Text(
                      '$seconds1',
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '$seconds2',
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ])

            ,
          )),
    );
  }
}

class FlipedText extends StatelessWidget {
  final String text;
  const FlipedText({Key? key, this.text = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Transform(
        transform: Matrix4.rotationX(pi),
        alignment: Alignment.center,
        child: Container(
          color: Colors.black,
          child: Center(
              child: Text(
            text,
            style: const TextStyle(fontSize: 30, color: Colors.blue),
          )),
        ),
      ),
    );
  }
}

class Input extends StatefulWidget {
  final Function setTime;
  const Input({Key? key, required this.setTime}) : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  final myController = TextEditingController(text: '0');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: TextFormField(
            controller: myController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        ElevatedButton(
            onPressed: pressed,
            child: const Text('okay'))
      ],
    );
  }
  void pressed(){
    widget.setTime(myController.text);
  }
}
