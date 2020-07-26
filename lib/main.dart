import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shuttle_run/services/openLink.dart';
import 'package:shuttle_run/services/soundManager.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'シャトルラン'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _level = 1;
  int _time = 0;
  bool _isFirst = true;

  final SoundManager soundManager = SoundManager();
  final Stopwatch stopwatch = Stopwatch();
  final OpenLink openLink = OpenLink();

  void _startShuttleRun() async{
    _incrementCounter();
    await _initMeasure();
    await _measure();
  }

  void _incrementCounter() async {

    if(!stopwatch.isRunning && !_isFirst){
      soundManager.resumeSound();
      stopwatch.start();
    }
    //スタート時に、音源を起動し、ストップウォッチを走らせる
    if(!stopwatch.isRunning && _isFirst){
      soundManager.playLocal('shuttle_run.mp3');
      stopwatch.start();
      _isFirst = false;
    }

    //オーバーフロー防止のため1秒間隔で動作
    new Timer (new Duration(seconds: 1), () async {
      int position;
      if(await soundManager.getCurrentPosition() == null){
        position = 0;
      }else {
        position = (await soundManager.getCurrentPosition() /1000).floor() -6;
      }


      _plusTime(position);

      if(stopwatch.isRunning){
        return _incrementCounter();
      }
      return;

    });

  }

  Future _initMeasure() async {
    new Timer (new Duration(seconds: 15), () async {
      _counter++;
    });
  }

  Future _measure() async{
    int time = 9;
    if(!stopwatch.isRunning){
      time = 0;
    }
    Timer.periodic(Duration(seconds: time), _plusCounter);
  }

  void _plusCounter(Timer time){
    if(!stopwatch.isRunning){
      time.cancel();
    }
    setState(() {
      if(!stopwatch.isRunning){
        time.cancel();
        _counter = 0;
      }else{
        _counter++;
      }
    });
  }

  void _plusTime(int position) {
    setState(() {
      if(position < 0) {
        _time = 0;
      }else{
        _time++;
      }
    });
  }

  void _pauseSound() {
    soundManager.pauseSound();
    stopwatch.stop();
  }

  void _stopSound() {
    soundManager.stopSound();
    stopwatch.stop();
    stopwatch.reset();
    _measure();
    setState(() {
      _time = 0;
      _isFirst = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_box),
            tooltip: '作者サイトへ',
            iconSize: 40,
            onPressed: openLink.launchURL,
          )
        ],
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 3,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              '回数：$_counter回',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.black,
            alignment: Alignment.center,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              '時間：$_time秒',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.black,
            alignment: Alignment.center,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Sound of screams but the'),
            color: Colors.teal[200],
            alignment: Alignment.center,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Who scream'),
            color: Colors.teal[200],
            alignment: Alignment.center,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution is coming...'),
            color: Colors.teal[200],
            alignment: Alignment.center,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Revolution, they...'),
            color: Colors.teal[200],
            alignment: Alignment.center,
          ),
        ],
      ),
      bottomSheet: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: _startShuttleRun,
              icon: Icon(Icons.directions_run),
              iconSize: 40,
              color: Colors.black,
              tooltip: 'Start',
              padding: EdgeInsets.only(right: 20.0, left: 20.0),
            ),
            IconButton(
              onPressed: _pauseSound,
              icon: Icon(Icons.pause),
              iconSize: 40,
              color: Colors.black,
              tooltip: 'Pause',
              padding: EdgeInsets.only(right: 20.0, left: 20.0),
            ),
            IconButton(
              onPressed: _stopSound,
              icon: Icon(Icons.stop),
              iconSize: 40,
              color: Colors.red,
              tooltip: 'Stop',
              padding: EdgeInsets.only(right: 20.0, left: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
