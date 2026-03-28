import 'package:pride_sys_test_flutter/domain/result/result.dart';

class Success<T> extends Result<T> {
  /// Optional data returned from the successful operation.
  ///
  /// Can be null if the operation succeeded but returned no data.
  final T? data;

  /// Creates a new [Success] instance.
  ///
  /// Parameters:
  /// - [data]: Optional data returned from the operation
  Success({this.data});
}
