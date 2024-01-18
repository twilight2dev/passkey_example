import 'package:json_annotation/json_annotation.dart';

part 'init_authenticate_request.g.dart';

@JsonSerializable()
class InitAuthenticateRequest {
  InitAuthenticateRequest({
    this.username,
  });

  String? username;

  Map<String, dynamic> toJson() => _$InitAuthenticateRequestToJson(this);
}
