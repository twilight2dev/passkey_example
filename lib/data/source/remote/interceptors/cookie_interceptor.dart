import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// For testing purposes.
// Instead, it should be stored in a secure storage location
class CookieManager {
  static String cookie = "";
}

class CookieInterceptor extends Interceptor {
  CookieInterceptor({required this.ref});

  final Ref ref;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final cookieStr = CookieManager.cookie;
    if (cookieStr.isNotEmpty) {
      options.headers['Cookie'] = cookieStr;
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    final cookies = response.headers['Set-Cookie'];
    if (cookies != null && cookies.isNotEmpty) {
      CookieManager.cookie = cookies.first;
    }
    return super.onResponse(response, handler);
  }
}
