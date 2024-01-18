import 'package:json_annotation/json_annotation.dart';
import 'package:passkey_example/const/aliases.dart';
import 'package:passkeys/types.dart';

part 'init_authenticate_response.g.dart';

@JsonSerializable(createToJson: false)
class InitAuthenticateResponseData {
  InitAuthenticateResponseData({
    required this.challenge,
    required this.allowCredentials,
    required this.timeout,
    required this.userVerification,
    required this.rpId,
  });

  final String? challenge;
  final List<AllowCredential>? allowCredentials;
  final int? timeout;
  final String? userVerification;
  final String? rpId;

  factory InitAuthenticateResponseData.fromJson(Map<String, dynamic> json) =>
      _$InitAuthenticateResponseDataFromJson(json);

  AuthenticatePasskeyRequest toAuthenticatePasskeyRequest() {
    return AuthenticatePasskeyRequest(
      challenge: challenge ?? '',
      allowCredentials: allowCredentials?.map((e) => e.toAllowCredentialType()).toList(),
      timeout: timeout,
      userVerification: userVerification,
      relyingPartyId: rpId ?? '',
      mediation: MediationType.Optional,
    );
  }
}

@JsonSerializable(createToJson: false)
class AllowCredential {
  AllowCredential({
    required this.id,
    required this.type,
    required this.transports,
  });

  final String? id;
  final String? type;
  final List<String>? transports;

  factory AllowCredential.fromJson(Map<String, dynamic> json) => _$AllowCredentialFromJson(json);

  AllowCredentialType toAllowCredentialType() {
    return AllowCredentialType(
      id: id ?? '',
      type: type ?? '',
      transports: transports ?? [],
    );
  }
}
