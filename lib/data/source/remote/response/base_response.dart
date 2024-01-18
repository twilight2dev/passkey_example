import 'package:json_annotation/json_annotation.dart';
import 'package:passkey_example/data/source/remote/exceptions/api_exception.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  @JsonKey(defaultValue: false)
  final bool status;

  @JsonKey(defaultValue: '')
  final String message;

  @JsonKey(defaultValue: null)
  final T? data;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final ApiException? exception;

  bool get isSuccessed => status;

  BaseResponse({
    required this.message,
    required this.status,
    required this.data,
    this.exception,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$BaseResponseFromJson(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$BaseResponseToJson(this, toJsonT);
}

@JsonSerializable()
class EmptyResponseData {
  EmptyResponseData();

  factory EmptyResponseData.fromJson(Map<String, dynamic> json) {
    return _$EmptyResponseDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EmptyResponseDataToJson(this);
}
