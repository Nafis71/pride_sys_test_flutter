class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final bool isSuccess;

  ApiResponse.success({this.data, this.message}) : isSuccess = true, statusCode = null;

  ApiResponse.error({this.message, required this.statusCode}) : data = null, isSuccess = false;
}
