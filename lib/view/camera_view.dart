import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_object_detection/service/logger_service.dart';

class ProfileModel extends ChangeNotifier {
  Uint8List planesList(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
    return allBytes.done().buffer.asUint8List();
  }

  FirebaseVisionImageMetadata imageMetaData(CameraImage image) {
    return FirebaseVisionImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rawFormat: image.format.raw,
        planeData: image.planes
            .map((Plane plane) => FirebaseVisionImagePlaneMetadata(
                bytesPerRow: plane.bytesPerRow,
                height: plane.height,
                width: plane.width))
            .toList());
  }

  Future<List<DetectedObject>> detectObjects(CameraImage availableImage) async {
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromBytes(
        planesList(availableImage.planes), imageMetaData(availableImage));
    final ObjectDetector detector = FirebaseVision.instance.objectDetector(
        const ObjectDetectorOptions(
            enableClassification: true, enableMultipleObjects: true));
    return detector.processImage(visionImage);
  }

  Widget _buildResults(
      List<DetectedObject> objects, CameraController controller) {
    final Size imageSize = Size(
      controller.value.previewSize.height,
      controller.value.previewSize.width,
    );

    return CustomPaint(
      painter: ObjectsCustomPainter(imageSize, objects),
    );
  }
}

class ObjectsCustomPainter extends CustomPainter {
  Size imageSize;
  List<DetectedObject> objects;
  List colors = [Colors.blueAccent, Colors.deepPurple, Colors.grey, Colors.green, Colors.deepOrangeAccent];
  Map colorMap = new Map();

  ObjectsCustomPainter(this.imageSize, this.objects);

  @override
  void paint(Canvas canvas, Size size) {

    for (DetectedObject object in objects) {
      logger.i("tracking id: ${object.trackingId} , category: ${object.category}, confidence: ${object.confidence}, "
          "rect.left: ${object.boundingBox.left}, rect.top: ${object.boundingBox.top}, rect.right: ${object.boundingBox.right}, rect.bottom: ${object.boundingBox.bottom}");

      colorMap[object.trackingId] = colors[object.trackingId % 5];

      Paint objectPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = colorMap[object.trackingId];

      canvas.drawRect(
        Rect.fromLTWH(
          object.boundingBox.left,
          object.boundingBox.top,
          object.boundingBox.width,
          object.boundingBox.height,
        ),
        objectPaint,
      );

      TextSpan span = new TextSpan(style: new TextStyle(color: colorMap[object.trackingId]), text: object.category.toString().substring(object.category.toString().lastIndexOf('.') + 1));
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, object.boundingBox.center);
    }
  }

  @override
  bool shouldRepaint(ObjectsCustomPainter oldDelegate) {
    return imageSize != oldDelegate.imageSize || objects != oldDelegate.objects;
  }
}

class CameraScreen extends StatefulWidget {
  final ProfileModel model;
  final Function(String) onPictureTaken;

  const CameraScreen({Key key, this.model, this.onPictureTaken})
      : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState(this.model);
}

class CameraScreenState extends State<CameraScreen> {
  CameraController _camera;
  final ProfileModel _model;
  List<DetectedObject> _objects;

  CameraScreenState(this._model);

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      CameraDescription description = cameras != null && cameras.isNotEmpty
          ? cameras.firstWhere(
              (element) => element.lensDirection == CameraLensDirection.back)
          : null;
      _camera = new CameraController(
        description,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      _camera.initialize().then((_) {
        if (!mounted) {
          return;
        }
        _camera.startImageStream((CameraImage availableImage) {
          this._model.detectObjects(availableImage).then((value) {
            _objects = value;
            setState(() {});
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 300, minWidth: 300),
        child: _camera == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                child: ClipRect(
                  child: Container(
                    child: Transform.scale(
                      scale: _camera.value.aspectRatio / _size.aspectRatio,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _camera.value.aspectRatio,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              CameraPreview(_camera),
                              _model._buildResults(_objects, _camera),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )));
  }
}
