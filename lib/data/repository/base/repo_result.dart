import 'package:passkey_example/data/source/remote/exceptions/api_exception.dart';

typedef SuccessCallback<T> = Future<void> Function(T data);
typedef FailureCallback = void Function(ApiException? error);

mixin RepoResultMixin<T> {
  Future<void> when({
    required SuccessCallback<T> success,
    required FailureCallback failure,
  });
}

abstract class RepoResult<T> with RepoResultMixin<T> {
  const factory RepoResult.success({required T data}) = Success<T>;

  const factory RepoResult.failure({required ApiException? error}) = Failure<T>;
}

abstract class Success<T> implements RepoResult<T> {
  const factory Success({required T data}) = _SuccessImpl<T>;

  T get data;
}

class _SuccessImpl<T> implements Success<T> {
  const _SuccessImpl({required this.data});

  @override
  final T data;

  @override
  Future<void> when({required SuccessCallback<T> success, required FailureCallback failure}) async {
    return success.call(data);
  }
}

abstract class Failure<T> implements RepoResult<T> {
  const factory Failure({required ApiException? error}) = _FailureImpl<T>;

  ApiException? get error;
}

class _FailureImpl<T> implements Failure<T> {
  const _FailureImpl({required this.error});

  @override
  final ApiException? error;

  @override
  Future<void> when({required SuccessCallback<T> success, required FailureCallback failure}) async {
    return failure(error);
  }
}
