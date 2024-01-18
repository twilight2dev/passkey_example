import 'package:json_annotation/json_annotation.dart';
import 'package:passkey_example/const/aliases.dart';
import 'package:passkeys/types.dart';

part 'init_register_response.g.dart';

@JsonSerializable(createToJson: false)
class InitRegisterResponseData {
  InitRegisterResponseData({
    required this.challenge,
    required this.rp,
    required this.user,
    required this.pubKeyCredParams,
    required this.timeout,
    required this.attestation,
    required this.authenticatorSelection,
  });

  final String challenge;
  final RelyingParty rp;
  final User user;
  final List<PubKeyCredParam> pubKeyCredParams;
  final int? timeout;
  final String? attestation;
  final AuthenticatorSelection authenticatorSelection;

  factory InitRegisterResponseData.fromJson(Map<String, dynamic> json) => _$InitRegisterResponseDataFromJson(json);

  RegisterPasskeyRequest toRegisterPasskeyRequest() {
    return RegisterPasskeyRequest(
      challenge: challenge,
      relyingParty: rp.toRelyingPartyType(),
      user: user.toUserType(),
      authSelectionType: authenticatorSelection.toAuthenticatorSelectionType(),
      pubKeyCredParams: pubKeyCredParams.map((e) => e.toPubKeyCredParamType()).toList(),
      timeout: timeout,
      attestation: attestation,
    );
  }
}

@JsonSerializable(createToJson: false)
class AuthenticatorSelection {
  AuthenticatorSelection({
    required this.residentKey,
    required this.requireResidentKey,
    required this.userVerification,
  });

  final String? residentKey;
  final bool? requireResidentKey;
  final String? userVerification;

  factory AuthenticatorSelection.fromJson(Map<String, dynamic> json) => _$AuthenticatorSelectionFromJson(json);

  AuthenticatorSelectionType toAuthenticatorSelectionType() {
    return AuthenticatorSelectionType(
      residentKey: residentKey ?? '',
      requireResidentKey: requireResidentKey ?? false,
      authenticatorAttachment: '',
      userVerification: userVerification ?? '',
    );
  }
}

@JsonSerializable(createToJson: false)
class PubKeyCredParam {
  PubKeyCredParam({
    required this.alg,
    required this.type,
  });

  final int? alg;
  final String? type;

  factory PubKeyCredParam.fromJson(Map<String, dynamic> json) => _$PubKeyCredParamFromJson(json);

  PubKeyCredParamType toPubKeyCredParamType() {
    return PubKeyCredParamType(
      alg: alg ?? 0,
      type: type ?? '',
    );
  }
}

@JsonSerializable(createToJson: false)
class RelyingParty {
  RelyingParty({
    required this.name,
    required this.id,
  });

  final String? name;
  final String? id;

  factory RelyingParty.fromJson(Map<String, dynamic> json) => _$RelyingPartyFromJson(json);

  RelyingPartyType toRelyingPartyType() {
    return RelyingPartyType(
      id: id ?? '',
      name: name ?? '',
    );
  }
}

@JsonSerializable(createToJson: false)
class User {
  User({
    required this.id,
    required this.name,
    required this.displayName,
  });

  final String? id;
  final String? name;
  final String? displayName;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  UserType toUserType() {
    return UserType(
      id: id ?? '',
      name: name ?? '',
      displayName: displayName ?? '',
    );
  }
}
