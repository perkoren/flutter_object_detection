import 'package:logger/logger.dart';

class ObjectDetectionLogger extends Logger {

  ObjectDetectionLogger({
    LogFilter filter,
    LogPrinter printer,
    LogOutput output,
    Level level,
  }) : super(filter: filter, printer: printer, output: output, level: level);

}

final logger = Logger();