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

  void changeSeconds(String time){
    print(seconds);
    setState(() {
      seconds = int.parse(time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orange,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [ TextField(onSubmitted: changeSeconds,),
               Counter(reversed: false, max : seconds)
               ,Counter(reversed: true,max: seconds,)],
          )
      ));
  }
}


class Counter extends StatefulWidget {

  final bool reversed;
  final int max;
  const Counter({Key? key, this.reversed = false , this.max = 0}) : super(key: key);
  
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {

  
  late int max;
  late int seconds = max;
  Timer? timer;
  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void stopTimer({reset = false}) {
    if (reset) {
      resetTimer();
    }
    timer?.cancel();
  }

  void resetTimer() {
    setState(() {
      seconds = max;
    });
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      max = widget.max;
    });
    print('counter variableis $max');
    bool isRunning = timer == null ? false : timer!.isActive;

    return SizedBox(
      height: 100,
      width: 100,
      child: TextButton(
          onPressed: () {
            if (isRunning) {
              stopTimer(reset: false);
            } else {
              startTimer(reset: seconds == 0);
            }
            isRunning = !isRunning;
          },
          
            child: Center(
              child: Container(alignment: Alignment.center, color: Colors.white, width: double.infinity , height: 100, child:widget.reversed ?Text(
                '$seconds', 
                style: const TextStyle(fontSize: 30 ,),textAlign: TextAlign.center  ,
              ) : FlipedText(text: '$seconds', ),
          ),
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
          transform:Matrix4.rotationX(pi),
          alignment: Alignment.center,

          child: Container(
            color: Colors.black,
            child: Center(child: Text(text,style: const TextStyle(fontSize: 30, color: Colors.blue),)),
          ),
        ),
      );
    }
  }

 class Input extends StatefulWidget {

   final Function setTime;
   const Input({ Key? key , required this.setTime}) : super(key: key);
 
   @override
   _InputState createState() => _InputState();
 }
 
 class _InputState extends State<Input> {

   final myController = TextEditingController(text: '0');

  void iniitState(){
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) { _onAfterBuild(context); });
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

   @override
   Widget build(BuildContext context) {
      return _onAfterBuild(context);
     
   }
   Widget _onAfterBuild(BuildContext context){
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
          ElevatedButton(onPressed: widget.setTime(myController.text), child: const Text('okay'))
       ],
     );
   }
 }