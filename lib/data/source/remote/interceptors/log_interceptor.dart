import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    log('\nBEGIN HTTP REQUEST: ${options.method} ${options.baseUrl}${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('HTTP RESPONSE: ${response.data}');
    return super.onResponse(response, handler);
  }
}
