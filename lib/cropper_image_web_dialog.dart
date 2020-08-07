import 'dart:async';

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cropper_image_web.dart';

// ignore: must_be_immutable
class CropperImageWebDialog extends StatefulWidget {

  final Completer completer;
  final Uint8List image;
  final String fileName;

  CropperImageWebDialog({
        @required this.completer,
        @required this.image,
        @required this.fileName
      });

  static showCropperDialog(context, String fileName,Uint8List image, Completer completer) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) => CropperImageWebDialog(
          completer: completer,
          image: image,
          fileName: fileName,
        ));
  }

  @override
  State<StatefulWidget> createState() => _CropperImageWebDialog();
}

class _CropperImageWebDialog extends State<CropperImageWebDialog> {
  var _cropperKey = GlobalKey();
  var _rotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        height: 550,
        constraints: BoxConstraints(minWidth: 400, maxWidth: 600),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              child: CropperImage(
                MemoryImage(widget.image),
                key: _cropperKey,
                rotate: _rotation,
              ),
            ),
                RaisedButton(
                  child: Text('Crop'),
                  onPressed: () {
                    (_cropperKey.currentContext as CropperImageElement).outImage().then((image) async {
                      var bytes = (await (image.toByteData(format: ImageByteFormat.png))).buffer.asUint8List();
                      widget.completer.complete({'image': bytes, 'filename': widget.fileName});

                    });
                    Navigator.pop(context);
                  },
                ),

              ]
            )
        ),

    );
  }
}