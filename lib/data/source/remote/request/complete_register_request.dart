import 'package:json_annotation/json_annotation.dart';
import 'package:passkey_example/const/aliases.dart';

part 'complete_register_request.g.dart';

@JsonSerializable()
class CompleteRegisterRequest {
  CompleteRegisterRequest({
    required this.id,
    required this.clientDataJson,
    required this.attestationObject,
    required this.rawId,
  });

  final String? id;

  @JsonKey(name: 'clientDataJSON')
  final String? clientDataJson;
  final String? attestationObject;
  final String? rawId;

  factory CompleteRegisterRequest.fromRegisterPasskeyResponse(RegisterPasskeyResponse data) {
    return CompleteRegisterRequest(
      attestationObject: data.attestationObject,
      id: data.id,
      clientDataJson: data.clientDataJSON,
      rawId: data.rawId,
    );
  }

  Map<String, dynamic> toJson() => _$CompleteRegisterRequestToJson(this);
}
