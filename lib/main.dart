import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'cropper_image_web_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  var image;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            image == null ? Container() : Image.memory(image),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
         var tmp = await getImage(context);
         setState(() {
           image = tmp['image'];
         });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<Map<String, dynamic>> getImage(context) async {
    Completer c = new Completer<Map<String, dynamic>>();
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..multiple = false
      ..accept = 'image/*';
    input.onChange.listen((e) async {
      final file = input.files.first;
      final reader = new FileReader();
      reader.readAsArrayBuffer(file);
      Uint8List result = await reader.onLoad.first.then((value) => reader.result);
      CropperImageWebDialog.showCropperDialog(context, file.name, result, c);
    });
    input.click();
    return c.future;
  }
}

