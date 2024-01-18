import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passkey_example/data/source/remote/interceptors/log_interceptor.dart';
import 'package:passkey_example/data/source/remote/interceptors/cookie_interceptor.dart';

final apiV1ClientProvider = Provider<ApiV1Client>(
  (ref) => ApiV1Client(baseUrl: 'https://368a-2405-4802-1d8b-980-85d2-8d66-d91d-7988.ngrok-free.app', ref: ref),
);

class ApiV1Client extends BaseApiClient {
  ApiV1Client({required super.baseUrl, required super.ref});
}

class BaseApiClient {
  late final Dio _dio;

  Dio get dio => _dio;

  BaseApiClient({required String baseUrl, required Ref ref}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        // receiveTimeout: Duration(seconds: CFG.instance.api.receiveTimeOut * 60),
        // connectTimeout: Duration(seconds: CFG.instance.api.connectTimeOut * 60),
        // contentType: CFG.instance.api.contentType,
      ),
    );

    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(CookieInterceptor(ref: ref));
  }
}
