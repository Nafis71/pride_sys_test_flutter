import 'package:logger/logger.dart';

/// shows colorful debugging logs
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 3,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);
