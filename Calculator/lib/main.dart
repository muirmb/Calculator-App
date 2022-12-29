import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _firstNum = 0;
  int _secondNum = 0;
  String _firstString = "", _secondString = "", _opString = "";
  int _result = 0;
  String _operation = "+";
  bool _gotFirst = false, _undef = false;
  bool _divSel = false, _mulSel = false, _subSel = false, _addSel = false, _foundResult = false, _powSel = false;


  void _setOperation(String op){

    // Factorial
    if(op == "!"){
      int res = 1;
      if(!_gotFirst) {
        for (int i = _firstNum; i > 1; i--) {
          res *= i;
        }
        setState(() {
          _firstNum = res;
          _firstString = '$_firstNum';
          _opString = '$res';
        });
      }
      else {
        for (int i = _secondNum; i > 1; i--) {
          res *= i;
        }
        setState(() {
          _secondNum = res;
          _secondString = '$_secondNum';
          _opString = '$res';
        });
      }
      return;
    }

    // Positive/negative
    else if(op == "+/-"){
      if(!_gotFirst) {
        setState(() {
          _firstNum = 0 - _firstNum;
          _firstString = '$_firstNum';
          _opString = '$_firstNum';
        });
      }
      else {
        setState(() {
          _secondNum = 0 - _secondNum;
          _secondString = '$_secondNum';
        });
      }
      return;
    }

    // Clear
    else if(op == "C"){
      setState(() {
        _firstNum = 0;
        _secondNum = 0;
        _result = 0;
        _firstString = "";
        _secondString = "";
        _opString = "";
      });
      return;
    }

    if(_gotFirst)
      compute();

    setState(() {
      _operation = op;
      _gotFirst = true;
      _opString = '$_firstNum$_operation';
    });

  }

  void _setFirst(int num){
    setState(() {
      _firstString += '$num';
      _firstNum = int.parse(_firstString);
    });
  }
  void _setSecond(int num){
    setState(() {
      _secondString += '$num';
      _secondNum = int.parse(_secondString);
    });
  }
  void _backFirst(){
    setState(() {
      _firstString = _firstString.substring(0,_firstString.length-1);
      _firstNum = int.parse(_firstString);
      _opString = _opString.substring(0,_opString.length-1);
    });
  }
  void _backSecond(){
    setState(() {
      _secondString = _secondString.substring(0,_secondString.length-1);
      _secondNum = int.parse(_secondString);
      _opString = _opString.substring(0,_opString.length-1);
    });
  }

  String _display(){
      return !_gotFirst ? '$_firstNum' : '$_secondNum';
  }

  void compute(){
    if(_operation == "+") {
      _result = _firstNum + _secondNum;
      setState(() {
        _addSel = false;
      });
    }
    else if(_operation == "-") {
      _result = _firstNum - _secondNum;
      setState(() {
        _subSel = false;
      });
    }
    else if(_operation == "x") {
      _result = _firstNum * _secondNum;
      setState(() {
        _mulSel = false;
      });
    }
    else if(_operation == "/") {
      if(_secondNum == 0) {
        _undef = true;
        _result = 0;
      }
      else
        _result = (_firstNum / _secondNum).round();
      setState(() {
        _divSel = false;
      });
    }
    else if(_operation == "^") {
      _result = pow(_firstNum, _secondNum).round();
      setState(() {
        _powSel = false;
      });
    }
    setState(() {
      _gotFirst = false;
      _firstNum = _result;
      _secondNum = 0;
      if(_undef)
        _opString = "ERROR";
      else
        _opString += _secondString + '=';
      _firstString = '$_firstNum';
      _secondString = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        _opString,
                        style: TextStyle(fontSize: 50, color: Colors.black54),
                      )
                  )
              )
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    _display(),
                    style: TextStyle(fontSize: 80),
                  )
                )
              )
            ),
            Expanded(
              flex: 10,
              child: GridView.count(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 4,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _setFirst(9) : _setSecond(9)},
                    child: const Text("9", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _setFirst(8) : _setSecond(8)},
                    child: const Text("8", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _setFirst(7) : _setSecond(7)},
                    child: const Text("7", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {
                      _setOperation("/"),
                      setState(() {
                        _divSel = true;
                      })
                    },
                    child: const Text("/", style: TextStyle(fontSize: 50)),
                    backgroundColor: _divSel ? Colors.blue[800] : Colors.blue,
                  ),
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _setFirst(6) : _setSecond(6)},
                    child: const Text("6", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _setFirst(5) : _setSecond(5)},
                    child: const Text("5", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _setFirst(4) : _setSecond(4)},
                    child: const Text("4", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {
                      _setOperation("x"),
                      setState(() {
                        _mulSel = true;
                      })
                    },
                    child: const Text("x", style: TextStyle(fontSize: 50)),
                    backgroundColor: _mulSel ? Colors.blue[800] : Colors.blue,
                  ),
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _setFirst(3) : _setSecond(3)},
                    child: const Text("3", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _setFirst(2) : _setSecond(2)},
                    child: const Text("2", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _setFirst(1) : _setSecond(1)},
                    child: const Text("1", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {
                      _setOperation("-"),
                      setState(() {
                        _subSel = true;
                      })
                    },
                    child: const Text("-", style: TextStyle(fontSize: 50)),
                    backgroundColor: _subSel ? Colors.blue[800] : Colors.blue,
                  ),
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _setFirst(0) : _setSecond(0)},
                    child: const Text("0", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {!_gotFirst ? _backFirst() : _backSecond()},
                    child: const Text("<", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {compute()},
                    child: const Text("=", style: TextStyle(fontSize: 50)),
                  ),
                  FloatingActionButton(
                    onPressed: () => {
                      _setOperation("+"),
                      setState(() {
                        _addSel = true;
                      })
                    },
                    child: const Text("+", style: TextStyle(fontSize: 50)),
                    backgroundColor: _addSel ? Colors.blue[800] : Colors.blue,
                  ),
                  FloatingActionButton(
                    onPressed: () => {
                      _setOperation("^"),
                      setState(() {
                        _powSel = true;
                      })
                    },
                    child: const Text("^", style: TextStyle(fontSize: 50)),
                    backgroundColor: _powSel ? Colors.blue[800] : Colors.blue,
                  ),
                  FloatingActionButton(
                    onPressed: () => {
                      _setOperation("!"),
                    },
                    child: const Text("!", style: TextStyle(fontSize: 50)),
                    backgroundColor: Colors.blue,
                  ),
                  FloatingActionButton(
                    onPressed: () => {
                      _setOperation("+/-"),
                    },
                    child: const Text("+/-", style: TextStyle(fontSize: 50)),
                    backgroundColor: Colors.blue,
                  ),
                  FloatingActionButton(
                    onPressed: () => {
                      _setOperation("C"),
                    },
                    child: const Text("C", style: TextStyle(fontSize: 50)),
                    backgroundColor: Colors.blue,
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
