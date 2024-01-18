import 'package:json_annotation/json_annotation.dart';
import 'package:passkey_example/const/aliases.dart';

part 'complete_authenticate_request.g.dart';

@JsonSerializable()
class CompleteAuthenticateRequest {
  CompleteAuthenticateRequest({
    required this.id,
    required this.clientDataJson,
    required this.rawId,
    required this.authenticatorData,
    required this.signature,
  });

  final String? id;
  final String? rawId;
  final String? authenticatorData;
  final String? signature;
  @JsonKey(name: 'clientDataJSON')
  final String? clientDataJson;

  factory CompleteAuthenticateRequest.fromAuthenticatePasskeyResponse(AuthenticatePasskeyResponse data) {
    return CompleteAuthenticateRequest(
      authenticatorData: data.authenticatorData,
      signature: data.signature,
      id: data.id,
      clientDataJson: data.clientDataJSON,
      rawId: data.rawId,
    );
  }

  Map<String, dynamic> toJson() => _$CompleteAuthenticateRequestToJson(this);
}
