import 'package:pride_sys_test_flutter/domain/result/result.dart';

class Failure<T> extends Result<T> {
  /// Should provide clear information about what went wrong.
  final String? failureMessage;

  /// HTTP status code associated with the failure (if applicable).
  ///
  /// Useful for API-related failures to determine the type of error.
  /// Can be null for non-HTTP errors.
  final int? statusCode;

  /// Creates a new [Failure] instance.
  ///
  /// Parameters:
  /// - [failureMessage]: Error message describing the failure
  /// - [statusCode]: Optional HTTP status code
  Failure({this.statusCode, this.failureMessage});
}
