import 'package:dio/dio.dart';

import 'http_client_adapter_factory_io.dart'
    if (dart.library.html) 'http_client_adapter_factory_web.dart'
    as adapter_impl;

HttpClientAdapter createHttpClientAdapter() =>
    adapter_impl.createHttpClientAdapter();
