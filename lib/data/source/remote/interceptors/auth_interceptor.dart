import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptors extends Interceptor {
  AuthInterceptors({required this.ref});

  final Ref ref;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // const accessToken = "";
    // if (accessToken != null && accessToken.isNotEmpty) {
    //   options.headers['Authorization'] = 'Bearer $accessToken';
    // }
    return super.onRequest(options, handler);
  }
}
