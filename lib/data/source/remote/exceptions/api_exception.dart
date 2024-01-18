import 'dart:io';

import 'package:dio/dio.dart';
import 'package:passkey_example/data/source/remote/const/api_error_code.dart';


class ApiException {
  final String errorMessage;

  ApiException(this.errorMessage);

  factory ApiException.defaultError(String error) => DefaultErrorException(error);
  factory ApiException.dioNetworkError(DioException error) => DioNetworkErrorException(error.message);
  factory ApiException.formatError() => FormatException();
  factory ApiException.internalServerError() => InternalServerErrorException();
  factory ApiException.noInternetConnection() => NoInternetConnectionException();
  factory ApiException.none() => NoException();
  factory ApiException.notFound() => NotFoundException();
  factory ApiException.serviceUnavailable() => ServiceUnavailableException();
  factory ApiException.unauthorized(String error) => UnauthorizedException(error);
  factory ApiException.cancel() => CancelledException();
  factory ApiException.unexpected() => UnexpectedException();

  static ApiException parse(error) {
    if (error is Exception) {
      try {
        ApiException exception;
        if (error is DioException) {
          exception = ApiException.handleResponse(error);
        } else {
          exception = ApiException.unexpected();
        }
        return exception;
      } on FormatException catch (_) {
        return ApiException.formatError();
      } catch (_) {
        return ApiException.unexpected();
      }
    } else {
      return ApiException.unexpected();
    }
  }

  static ApiException handleResponse(DioException dioException) {
    if (dioException.error is SocketException) {
      return ApiException.noInternetConnection();
    }
    if (dioException.type == DioExceptionType.cancel) return ApiException.cancel();
    if (dioException.type != DioExceptionType.badResponse) return ApiException.dioNetworkError(dioException);
    switch (dioException.response?.statusCode) {
      case ApiErrorCode.UNAUTHORIZE:
      case ApiErrorCode.UNAUTHENTICATED:
        return ApiException.unauthorized('UNAUTHORIZED REQUEST');
      case ApiErrorCode.NOT_FOUND:
        return ApiException.notFound();
      case ApiErrorCode.INTERNAL_SERVER:
        return ApiException.internalServerError();
      case ApiErrorCode.SERVICE_UNAVAILABLE:
        return ApiException.serviceUnavailable();
      case ApiErrorCode.BAD_REQUEST:
        final message = dioException.response?.data['message'];
        // ignore: sdk_version_since
        return ApiException.defaultError(message);
      default:
        return ApiException.defaultError('API ERROR WITH STATUS CODE: ${dioException.response?.statusCode}');
    }
  }
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String errorMessage) : super(errorMessage);
}

class CancelledException extends ApiException {
  CancelledException() : super('');
}

class NotFoundException extends ApiException {
  NotFoundException() : super('API NOT FOUND');
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException() : super('INTERNAL SERVER ERROR');
}

class ServiceUnavailableException extends ApiException {
  ServiceUnavailableException() : super('SERVICE UNAVAILABLE');
}

class FormatException extends ApiException {
  FormatException() : super('FORMAT EXCEPTION');
}

class DefaultErrorException extends ApiException {
  DefaultErrorException(String errorMessage) : super(errorMessage);
}

class DioNetworkErrorException extends ApiException {
  DioNetworkErrorException(String? errorMessage) : super(errorMessage ?? 'DIO NETWORK ERROR');
}

class NoInternetConnectionException extends ApiException {
  NoInternetConnectionException() : super('NO NETWORK');
}

class UnexpectedException extends ApiException {
  UnexpectedException() : super('UNEXPECTED EXCEPTION');
}

class NoException extends ApiException {
  NoException() : super('');
}
