import 'package:json_annotation/json_annotation.dart';

part 'init_register_request.g.dart';

@JsonSerializable()
class InitRegisterRequest {
  InitRegisterRequest({
    this.username,
  });

  String? username;

  Map<String, dynamic> toJson() => _$InitRegisterRequestToJson(this);
}
