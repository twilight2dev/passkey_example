import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passkey_example/data/repository/base/repo_result.dart';
import 'package:passkey_example/data/source/remote/exceptions/api_exception.dart';
import 'package:passkey_example/data/source/remote/response/base_response.dart';

abstract class BaseRepository {
  Ref get ref;

  // Apis follow the rules of base response
  Future<RepoResult<T?>> safeCallApi<T>(
    Future<BaseResponse<T?>> request, {
    bool autoHandleError = true,
  }) async {
    try {
      final response = await request;
      return _handleBaseResponse(response);
    } catch (exception, stackTrace) {
      log(' ---- TRACE: $stackTrace\n---- EXCEPTION: $exception');
      final e = _handleException(exception, autoHandleError: autoHandleError);
      return RepoResult.failure(error: e);
    }
  }

  Future<RepoResult<T?>> _handleBaseResponse<T>(BaseResponse<T?> response) async {
    if (response.isSuccessed) {
      return RepoResult.success(data: response.data);
    } else {
      return RepoResult.failure(error: response.exception);
    }
  }

  ApiException _handleException<T>(dynamic e, {bool autoHandleError = true}) {
    final exception = ApiException.parse(e);
    final isCancelRequest = exception is CancelledException;
    if (exception is ServiceUnavailableException) {
      // logout
    } else if (autoHandleError && !isCancelRequest) {}
    return exception;
  }
}
