import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/common/network/http_client_adapter_factory.dart';

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
    dio.httpClientAdapter = createHttpClientAdapter();
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
