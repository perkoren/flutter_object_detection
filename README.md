# flutter-object-detection demo app

Demonstration of the firebase-ml-vision-object-detection api in Flutter (for now Android only)

Uses com.google.firebase:firebase-ml-vision-object-detection-model:19.0.5 model (dependency in android/app/build.gradle)

Depends on the local firebase_ml_vision project with a patch supporting object detection -> pubspec.yaml 
../flutterfire/packages/firebase_ml_vision

Applied [patch](https://github.com/FirebaseExtended/flutterfire/pull/2729) for the [ticket](https://github.com/FirebaseExtended/flutterfire/issues/1159)

For demo purposes uses fake google-services.json

## Run 
`flutter run`