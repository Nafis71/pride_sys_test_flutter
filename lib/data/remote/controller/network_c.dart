import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, Response;

import '../../../common/utils/logger_util.dart';
import '../config/api_endpoints.dart';
import '../response/api_response.dart';

enum Method { post, get, put, delete, patch, download }

class NetworkController {
  Dio? _dio;
  static NetworkController? _instance;

  NetworkController._internal() {
    init();
  }

  factory NetworkController() => _instance ??= NetworkController._internal();


  static Map<String, String> header({String? token}) {
    logger.i(token);
    return {"Accept": "application/json"};
  }

  Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoints.baseUrl,
        connectTimeout: const Duration(seconds: 16),
        receiveTimeout: const Duration(seconds: 16),
        sendTimeout: const Duration(seconds: 16),
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
    logger.i("Base url from network controller : ${ApiEndPoints.baseUrl}");
    initInterceptors();
  }

  void initInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) {
          logger.i(
            "REQUEST[${requestOptions.method}] => RESPONSE: ${requestOptions.path}"
                "=> REQUEST VALUES: ${requestOptions.queryParameters} => HEADERS: ${requestOptions.headers}",
          );
          return handler.next(requestOptions);
        },
        onResponse: (response, handler) async {
          logger.i("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (err, handler) {
          logger.i("Error[${err.response?.statusCode}]");
          return handler.next(err);
        },
      ),
    );
  }

  Future<ApiResponse> request({
    required String url,
    required Method method,
    params,
    String? authToken,
    ResponseType? responseType,
    bool isMediaUpload = false,
    Function? progressCallback,
  }) async {
    try {
      logger.i("Params: $params");
      final response = await compute(_performHttpRequest, {
        'url': url,
        'method': method,
        'params': params,
        'isMediaUpload': isMediaUpload,
        'responseType': responseType,
        'progressCallback': progressCallback,
      });
      late ApiResponse apiResponse;
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        apiResponse = ApiResponse.success(data: response.data);
        return apiResponse;
      } else if (response.statusCode == 401) {
        apiResponse = ApiResponse.error(message: "User is authenticated", statusCode: response.statusCode);
        return apiResponse;
      } else if (response.statusCode == 404) {
        apiResponse = ApiResponse.error(statusCode: response.statusCode, message: "Content not found");
        return apiResponse;
      } else if (response.statusCode == 500) {
        apiResponse = ApiResponse.error(message: "Server error", statusCode: response.statusCode);
        return apiResponse;
      } else if (response.statusCode == 422) {
        apiResponse = ApiResponse.error(message: response.data['message'], statusCode: response.statusCode);
        return apiResponse;
      } else {
        apiResponse = ApiResponse.error(message: "Something went wrong", statusCode: response.statusCode);
        return apiResponse;
      }
    } on SocketException catch (e) {
      logger.e(e);
      Get.snackbar('Opps', "No Internet Connection");
      throw Exception("No Internet Connection");
    } on FormatException catch (e) {
      logger.e(e);
      throw Exception("Bad response format");
    } catch (e) {
      logger.e(e);
      throw Exception("Something went wrong");
    }
  }

  Future<Response> _performHttpRequest(Map<String, dynamic> data) async {
    final url = data['url'];
    final method = data['method'];
    final params = data['params'];
    final isMediaUpload = data['isMediaUpload'];
    final responseType = data['responseType'];
    final Function? progressCallback = data['progressCallback'];
    try {
      Response response;

      switch (method) {
        case Method.post:
          response = await _dio!.post(
            url,
            data: params,
            options: Options(
              contentType: isMediaUpload ? "multipart/form-data" : "application/json",
              headers: header(),
            ),
            onSendProgress: (sent, total) {
              if (total != -1) {
                double progress = (sent / total) * 100;
                if (progressCallback != null) progressCallback(progress);
              }
            },
          );
          break;
        case Method.delete:
          response = await _dio!.delete(
            url,
            options: Options(
              contentType: isMediaUpload ? "multipart/form-data" : "application/json",
              headers: header(),
            ),
          );
          break;
        case Method.patch:
          response = await _dio!.patch(
            url,
            data: params,
            options: Options(
              contentType: isMediaUpload ? "multipart/form-data" : "application/json",
              headers: header(),
            ),
          );
          break;
        case Method.download:
          try {
            final String savePath = params['savePath'];
            final tempPath = params['tempPath']; // temporary file
            await _dio!.download(
              url,
              tempPath,
              onReceiveProgress: (received, total) {
                if (total != -1) {
                  double progress = (received / total) * 100;
                  if (progressCallback != null) progressCallback(progress);
                }
              },
              options: Options(responseType: ResponseType.bytes, receiveTimeout: Duration(minutes: 3)),
            );
            final tempFile = File(tempPath);
            if (await tempFile.exists()) {
              await tempFile.rename(savePath);
            }
            return Response(data: params['savePath'], statusCode: 200, requestOptions: RequestOptions());
          } catch (exception, stackTrace) {
            logger.e(exception, stackTrace: stackTrace);
            return Response(data: params['savePath'], statusCode: 400, requestOptions: RequestOptions());
          }
        default:
          response = await _dio!.get(
            url,
            queryParameters: params,
            options: Options(
              responseType: responseType,
              contentType: isMediaUpload ? "multipart/form-data" : "application/json",
            ),
          );
          break;
      }
      return response;
    } on DioException catch (e) {
      handleDioError(e);
      throw Exception("Exception from performHTTPCallback :$e");
    }
  }

  static void handleDioError(DioException e) {
    logger.e(e);
  }
}
