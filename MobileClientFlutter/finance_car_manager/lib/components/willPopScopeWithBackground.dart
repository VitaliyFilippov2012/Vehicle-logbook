import 'dart:io';
import 'package:finance_car_manager/style/styles.dart';
import 'package:finance_car_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:finance_car_manager/state/appState.dart';

class WillPopScopeWithBackground extends StatefulWidget {
  final ValueChanged<String> onImageChanged;
  final bool takePhoto;
  final Widget childToFloatingButton;
  final Widget childToWillPop;
  final List<Widget> children;

  const WillPopScopeWithBackground({
    Key key,
    this.childToWillPop,
    this.onImageChanged,
    this.children,
    this.takePhoto = false,
    this.childToFloatingButton,
  }) : super(key: key);

  @override
  _WillPopScopeWithBackgroundState createState() =>
      _WillPopScopeWithBackgroundState();
}

class _WillPopScopeWithBackgroundState
    extends State<WillPopScopeWithBackground> {
  Image image = null;

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath.padRight(targetPath.length - 4) +'fff.jpg',
        quality: 40);
    print(result?.lengthSync() ?? 0);
    return result;
  }

  getImage(){
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      testCompressAndGetFile(imgFile, imgFile.path).then((value) =>
          widget.onImageChanged(Utility.base64String(value?.readAsBytesSync())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => widget.childToWillPop),
      ),
      child: Scaffold(
        body: ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: Scaffold(
              body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    for (final child in widget.children) child
                  ],
                ),
              ],
            ),
          )),
        ),
        floatingActionButton: widget.takePhoto
            ? FloatingActionButton(
                onPressed: () => {getImage()},
                tooltip: 'Pick Image',
                child: Icon(Icons.add_a_photo),
                backgroundColor: blueColor,
              )
            : widget.childToFloatingButton != null
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => widget.childToFloatingButton,
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                    backgroundColor: blueColor,
                  )
                : null,
      ),
    );
  }
}
