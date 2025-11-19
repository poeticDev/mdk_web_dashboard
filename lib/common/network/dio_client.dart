import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';

class DioClientFactory {
  const DioClientFactory();

  Dio create() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: <String, Object>{'Content-Type': 'application/json'},
      ),
    );
    if (kIsWeb) {
      dio.httpClientAdapter = BrowserHttpClientAdapter()
        ..withCredentials = true;
    } else {
      dio.httpClientAdapter = IOHttpClientAdapter();
    }
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (Object object) => debugPrint(object.toString()),
      ),
    );
    return dio;
  }
}
